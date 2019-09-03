MD_TARGETS=$(addsuffix .xml, $(basename $(wildcard ./*.md ./**/*.md)))

.PHONY: all
all: ${MD_TARGETS}

.PHONY: debug
debug:
	nix-shell --run "xmloscopy --docbook5 ./manual.xml ./manual-full.xml"

.PHONY: format
format: doc-support
	find . -iname '*.xml' -type f | while read f; do \
		echo $$f ;\
		xmlformat --config-file "doc-support/xmlformat.conf" -i $$f ;\
	done

.PHONY: fix-misc-xml
fix-misc-xml:
	find . -iname '*.xml' -type f \
		-exec ../nixos/doc/varlistentry-fixer.rb {} ';'

.PHONY: clean
clean:
	rm -f ${MD_TARGETS} doc-support .version manual-full.xml functions/library/locations.xml functions/library/generated
	rm -rf ./out/ ./highlightjs

.PHONY: validate
validate: manual-full.xml doc-support
	jing doc-support/docbook.rng manual-full.xml

out/html/index.html: doc-support manual-full.xml style.css highlightjs
	mkdir -p out/html
	xsltproc \
		--nonet --xinclude \
		--output $@ \
		doc-support/chunk-xhtml.xsl \
		./manual-full.xml

	# Assert that every generated HTML file has a ToC
	for f in $$(find ./out/html -name '*.html'); do \
		grep -q 'class="toc"' "$$f"; \
	done

	docbook-index \
		./manual-full.xml \
		./out/html/ \
		./out/html/index.js

doc-support: default.nix
	nix-build -A doc-support --out-link ./doc-support

%.section.xml: %.section.md
	pandoc $^ -w docbook+smart \
		-f markdown+smart \
	  | sed -e 's|<ulink url=|<link xlink:href=|' \
	      -e 's|</ulink>|</link>|' \
	      -e 's|<sect. id=|<section xml:id=|' \
	      -e 's|</sect[0-9]>|</section>|' \
	      -e '1s| id=| xml:id=|' \
	      -e '1s|\(<[^ ]* \)|\1xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink" |' \
	| cat  > $@

%.chapter.xml: %.chapter.md
	pandoc $^ -w docbook+smart \
		--top-level-division=chapter \
		-f markdown+smart \
	  | sed -e 's|<ulink url=|<link xlink:href=|' \
	      -e 's|</ulink>|</link>|' \
	      -e 's|<sect. id=|<section xml:id=|' \
	      -e 's|</sect[0-9]>|</section>|' \
	      -e '1s| id=| xml:id=|' \
	      -e '1s|\(<[^ ]* \)|\1|' \
	| cat  > $@
