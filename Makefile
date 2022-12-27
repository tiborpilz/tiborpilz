#
# Author: Jake Zimmerman <jake@zimmerman.io>
#
# ===== Usage ================================================================
#
# make                  Prepare public/ folder (all markdown & assets)
# make public/index.html  Recompile just public/index.html
#
# make watch            Start a local HTTP server and rebuild on changes
# PORT=4242 make watch  Like above, but use port 4242
#
# make clean            Delete all generated files
#
# ============================================================================

SOURCES := $(shell find pages -type f -name '*.md') README.md
TARGETS := $(patsubst pages/%.md,public/pages/%.html,$(SOURCES))

.PHONY: all
all: public/.nojekyll $(TARGETS) public/index.html

.PHONY: clean
clean:
	rm -rf public

.PHONY: watch
watch:
	./tools/serve.sh --watch

public/.nojekyll: $(wildcard public/*) public/.nojekyll
	rm -vrf public && mkdir -p public/pages && cp -vr assets/.nojekyll assets/* public

.PHONY: public
public: public/.nojekyll

# Generalized rule: how to build a .html file from each .md
# Note: you will need pandoc 2 or greater for this to work
public/pages/%.html: pages/%.md template.html5 Makefile tools/build.sh
	tools/build.sh "$<" "$@"

public/index.html: README.md template.html5 Makefile tools/build.sh
	tools/build.sh "$<" "$@"
