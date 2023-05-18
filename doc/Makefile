MD_TARGETS=$(addsuffix .xml, $(basename $(shell find . -type f -regex '.*\.md$$' -not -name README.md)))

PANDOC ?= pandoc

pandoc_media_dir = media
# NOTE: Keep in sync with conversion script (/maintainers/scripts/db-to-md.sh).
# TODO: Remove raw-attribute when we can get rid of DocBook altogether.
pandoc_commonmark_enabled_extensions = +attributes+fenced_divs+footnotes+bracketed_spans+definition_lists+pipe_tables+raw_attribute
# Not needed:
# - docbook-reader/citerefentry-to-rst-role.lua (only relevant for DocBook → MarkDown/rST/MyST)
pandoc_flags = --extract-media=$(pandoc_media_dir) \
	--lua-filter=$(PANDOC_LUA_FILTERS_DIR)/diagram-generator.lua \
	--lua-filter=build-aux/pandoc-filters/myst-reader/roles.lua \
	--lua-filter=$(PANDOC_LINK_MANPAGES_FILTER) \
	--lua-filter=build-aux/pandoc-filters/docbook-writer/rst-roles.lua \
	--lua-filter=build-aux/pandoc-filters/docbook-writer/labelless-link-is-xref.lua \
	-f commonmark$(pandoc_commonmark_enabled_extensions)+smart

.PHONY: all
all: validate format out/html/index.html out/epub/manual.epub

.PHONY: render-md
render-md: ${MD_TARGETS}

.PHONY: debug
debug:
	nix-shell --run "xmloscopy --docbook5 ./manual.xml ./manual-full.xml"

.PHONY: format
format: doc-support/result
	find . -iname '*.xml' -type f | while read f; do \
		echo $$f ;\
		xmlformat --config-file "doc-support/result/xmlformat.conf" -i $$f ;\
	done

.PHONY: fix-misc-xml
fix-misc-xml:
	find . -iname '*.xml' -type f \
		-exec ../nixos/doc/varlistentry-fixer.rb {} ';'

.PHONY: clean
clean:
	rm -f ${MD_TARGETS} doc-support/result .version manual-full.xml functions/library/locations.xml functions/library/generated
	rm -rf ./out/ ./highlightjs ./media

.PHONY: validate
validate: manual-full.xml doc-support/result
	jing doc-support/result/docbook.rng manual-full.xml

out/html/index.html: doc-support/result manual-full.xml style.css highlightjs
	mkdir -p out/html
	xsltproc \
		--nonet --xinclude \
		--output $@ \
		doc-support/result/xhtml.xsl \
		./manual-full.xml

	mkdir -p out/html/highlightjs/
	cp -r highlightjs out/html/

	cp -r $(pandoc_media_dir) out/html/
	cp ./overrides.css out/html/
	cp ./style.css out/html/style.css

	mkdir -p out/html/images/callouts
	cp doc-support/result/xsl/docbook/images/callouts/*.svg out/html/images/callouts/
	chmod u+w -R out/html/

out/epub/manual.epub: manual-full.xml
	mkdir -p out/epub/scratch
	xsltproc --nonet \
		--output out/epub/scratch/ \
		doc-support/result/epub.xsl \
		./manual-full.xml

	cp -r $(pandoc_media_dir) out/epub/scratch/OEBPS
	cp ./overrides.css out/epub/scratch/OEBPS
	cp ./style.css out/epub/scratch/OEBPS
	mkdir -p out/epub/scratch/OEBPS/images/callouts/
	cp doc-support/result/xsl/docbook/images/callouts/*.svg out/epub/scratch/OEBPS/images/callouts/
	echo "application/epub+zip" > mimetype
	zip -0Xq "out/epub/manual.epub" mimetype
	rm mimetype
	cd "out/epub/scratch/" && zip -Xr9D "../manual.epub" *
	rm -rf "out/epub/scratch/"

highlightjs: doc-support/result
	mkdir -p highlightjs
	cp -r doc-support/result/highlightjs/highlight.pack.js highlightjs/
	cp -r doc-support/result/highlightjs/LICENSE highlightjs/
	cp -r doc-support/result/highlightjs/mono-blue.css highlightjs/
	cp -r doc-support/result/highlightjs/loader.js highlightjs/


manual-full.xml: ${MD_TARGETS} .version functions/library/locations.xml functions/library/generated *.xml **/*.xml **/**/*.xml
	xmllint --nonet --xinclude --noxincludenode manual.xml --output manual-full.xml

.version: doc-support/result
	ln -rfs ./doc-support/result/version .version

doc-support/result: doc-support/default.nix
	(cd doc-support; nix-build)

functions/library/locations.xml: doc-support/result
	ln -rfs ./doc-support/result/function-locations.xml functions/library/locations.xml

functions/library/generated: doc-support/result
	ln -rfs ./doc-support/result/function-docs functions/library/generated

%.section.xml: %.section.md
	$(PANDOC) $^ -t docbook \
		$(pandoc_flags) \
		-o $@

%.chapter.xml: %.chapter.md
	$(PANDOC) $^ -t docbook \
		--top-level-division=chapter \
		$(pandoc_flags) \
		-o $@
