.PHONY: all
all: manual-combined.xml format

.PHONY: debug
debug: generated manual-combined.xml

manual-combined.xml: generated *.xml
	rm -f ./manual-combined.xml
	nix-shell --packages xmloscopy \
		--run "xmloscopy --docbook5 ./manual.xml ./manual-combined.xml"

.PHONY: format
format:
	find ../../ -iname '*.xml' -type f -print0 | xargs -0 -I{} -n1 \
		xmlformat --config-file "../xmlformat.conf" -i {}

.PHONY: fix-misc-xml
fix-misc-xml:
	find . -iname '*.xml' -type f \
		-exec ../varlistentry-fixer.rb {} ';'

.PHONY: clean
clean:
	rm -f manual-combined.xml generated

generated: ./options-to-docbook.xsl
	nix-build ../../release.nix \
		--attr manualGeneratedSources.x86_64-linux \
		--out-link ./generated
