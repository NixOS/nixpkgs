MD_TARGETS=$(addsuffix .xml, $(basename $(wildcard ./*.md ./**/*.md)))

.PHONY: all
all: validate format out/html/index.html out/epub/manual.epub

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

	cp doc-support/elasticlunr/elasticlunr.min.js out/html/
	cp doc-support/search.js out/html/
	docbook-index \
		./manual-full.xml \
		./out/html/ \
		./out/html/index.js

	mkdir -p out/html/highlightjs/
	cp -r highlightjs out/html/

	cp ./overrides.css out/html/
	cp ./style.css out/html/style.css

	mkdir -p out/html/images/callouts
	cp doc-support/xsl/docbook/images/callouts/*.svg out/html/images/callouts/
	chmod u+w -R out/html/

out/epub/manual.epub: manual-full.xml
	mkdir -p out/epub/scratch
	xsltproc --nonet \
		--output out/epub/scratch/ \
		doc-support/epub.xsl \
		./manual-full.xml

	cp ./overrides.css out/epub/scratch/OEBPS
	cp ./style.css out/epub/scratch/OEBPS
	mkdir -p out/epub/scratch/OEBPS/images/callouts/
	cp doc-support/xsl/docbook/images/callouts/*.svg out/epub/scratch/OEBPS/images/callouts/
	echo "application/epub+zip" > mimetype
	zip -0Xq "out/epub/manual.epub" mimetype
	rm mimetype
	cd "out/epub/scratch/" && zip -Xr9D "../manual.epub" *
	rm -rf "out/epub/scratch/"

highlightjs: doc-support
	mkdir -p highlightjs
	cp -r doc-support/highlightjs/highlight.pack.js highlightjs/
	cp -r doc-support/highlightjs/LICENSE highlightjs/
	cp -r doc-support/highlightjs/mono-blue.css highlightjs/
	cp -r doc-support/highlightjs/loader.js highlightjs/

style.css: doc-support
	cp doc-support/style.css style.css

manual-full.xml: ${MD_TARGETS} .version functions/library/locations.xml functions/library/generated *.xml **/*.xml **/**/*.xml
	xmllint --nonet --xinclude --noxincludenode manual.xml --output manual-full.xml

.version: doc-support
	ln -fs ./doc-support/version .version

doc-support: default.nix
	nix-build -A doc-support --out-link ./doc-support

functions/library/locations.xml: doc-support
	ln -fs $(realpath ./doc-support/function-locations.xml) functions/library/locations.xml

functions/library/generated: doc-support
	ln -fs $(realpath ./doc-support/function-docs) functions/library/generated

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
