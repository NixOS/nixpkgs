MD_TARGETS=$(addsuffix .xml, $(basename $(wildcard ./*.md ./**/*.md)))

.PHONY: all
all: validate format out/html/index.html out/epub/manual.epub

.PHONY: debug
debug:
	nix-shell --run "xmloscopy --docbook5 ./manual.xml ./manual-full.xml"

.PHONY: format
format:
	find . -iname '*.xml' -type f | while read f; do \
		echo $$f ;\
		xmlformat --config-file "$$XMLFORMAT_CONFIG" -i $$f ;\
	done

.PHONY: fix-misc-xml
fix-misc-xml:
	find . -iname '*.xml' -type f \
		-exec ../nixos/doc/varlistentry-fixer.rb {} ';'

.PHONY: clean
clean:
	rm -f ${MD_TARGETS} .version manual-full.xml functions/library/locations.xml
	rm -rf ./out/ ./highlightjs

.PHONY: validate
validate: manual-full.xml
	jing "$$RNG" manual-full.xml

out/html/index.html: manual-full.xml style.css highlightjs
	mkdir -p out/html
	xsltproc ${xsltFlags} \
		--nonet --xinclude \
		--output $@ \
		"$$XSL/docbook/xhtml/docbook.xsl" \
		./manual-full.xml

	mkdir -p out/html/highlightjs/
	cp -r highlightjs out/html/

	cp ./overrides.css out/html/
	cp ./style.css out/html/style.css

	mkdir -p out/html/images/callouts
	cp "$$XSL/docbook/images/callouts/"*.svg out/html/images/callouts/
	chmod u+w -R out/html/

out/epub/manual.epub: manual-full.xml
	mkdir -p out/epub/scratch
	xsltproc ${xsltFlags} --nonet \
		--output out/epub/scratch/ \
		"$$XSL/docbook/epub/docbook.xsl" \
		./manual-full.xml

	cp ./overrides.css out/epub/scratch/OEBPS
	cp ./style.css out/epub/scratch/OEBPS
	mkdir -p out/epub/scratch/OEBPS/images/callouts/
	cp "$$XSL/docbook/images/callouts/"*.svg out/epub/scratch/OEBPS/images/callouts/
	echo "application/epub+zip" > mimetype
	zip -0Xq "out/epub/manual.epub" mimetype
	rm mimetype
	cd "out/epub/scratch/" && zip -Xr9D "../manual.epub" *
	rm -rf "out/epub/scratch/"

highlightjs:
	mkdir -p highlightjs
	cp -r "$$HIGHLIGHTJS/highlight.pack.js" highlightjs/
	cp -r "$$HIGHLIGHTJS/LICENSE" highlightjs/
	cp -r "$$HIGHLIGHTJS/mono-blue.css" highlightjs/
	cp -r "$$HIGHLIGHTJS/loader.js" highlightjs/


manual-full.xml: ${MD_TARGETS} .version functions/library/locations.xml *.xml **/*.xml **/**/*.xml
	xmllint --nonet --xinclude --noxincludenode manual.xml --output manual-full.xml

.version:
	nix-instantiate --eval \
		-E '(import ../lib).version' > .version

functions/library/locations.xml:
	nix-build ./lib-function-locations.nix \
		--out-link ./functions/library/locations.xml

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
