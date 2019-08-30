.PHONY: all
all: out/html/index.html # format

.PHONY: debug
debug: generated manual-full.xml

manual-full.xml: *.xml **/*.xml **/**/*.xml
	xmllint --nonet --xinclude --noxincludenode manual.xml --output manual-full.xml

.PHONY: format
format:
	nix-shell --pure -Q --packages xmlformat \
		--run "find ../../ -iname '*.xml' -type f -print0 | xargs -0 -I{} -n1 \
		xmlformat --config-file '../xmlformat.conf' -i {}"

.PHONY: fix-misc-xml
fix-misc-xml:
	find . -iname '*.xml' -type f \
		-exec ../varlistentry-fixer.rb {} ';'

.PHONY: clean
clean:
	rm -f manual-full.xml generated

generated:
	nix-build ../../release.nix \
		--attr manualGeneratedSources.x86_64-linux \
		--out-link ./generated

doc-support: default.nix # !!!                     vvvvvvvvvvvv
	nix-build ../../release.nix -A doc-support.x86_64-linux --out-link ./doc-support


out/html/index.html: doc-support manual-full.xml
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
	mkdir -p out/html/highlightjs
	cp -r doc-support/highlightjs/highlight.pack.js out/html/highlightjs/
	cp -r doc-support/highlightjs/LICENSE out/html/highlightjs/
	cp -r doc-support/highlightjs/mono-blue.css out/html/highlightjs/
	cp -r doc-support/highlightjs/loader.js out/html/highlightjs/

	docbook-index \
		./manual-full.xml \
		./out/html/ \
		./out/html/index.js

	mkdir -p out/html/highlightjs/

	mkdir -p out/html/images/callouts
	cp doc-support/xsl/docbook/images/callouts/*.svg out/html/images/callouts/
	chmod u+w -R out/html/

out/html/extra:
	chmod u+w -R out/html/
	cp doc-support/elasticlunr/elasticlunr.min.js out/html/
	cp doc-support/search.js out/html/
	cp doc-support/style.css out/html/
	mkdir -p out/html/highlightjs
	cp -r doc-support/highlightjs/highlight.pack.js out/html/highlightjs/
	cp -r doc-support/highlightjs/LICENSE out/html/highlightjs/
	cp -r doc-support/highlightjs/mono-blue.css out/html/highlightjs/
	cp -r doc-support/highlightjs/loader.js out/html/highlightjs/
