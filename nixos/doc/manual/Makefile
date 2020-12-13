MD_TARGETS=$(addsuffix .xml, $(basename $(shell find . -type f -regex '.*\.md$$')))

.PHONY: all
all: manual-combined.xml format

.PHONY: debug
debug: generated manual-combined.xml

manual-combined.xml: generated *.xml **/*.xml ${MD_TARGETS}
	rm -f ./manual-combined.xml
	nix-shell --pure -Q --packages xmloscopy \
		--run "xmloscopy --docbook5 ./manual.xml ./manual-combined.xml"

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
	rm -f ${MD_TARGETS} manual-combined.xml generated

generated:
	nix-build ../../release.nix \
		--attr manualGeneratedSources.x86_64-linux \
		--out-link ./generated

%.xml: %.md
	pandoc $^ -t docbook \
		--top-level-division=chapter \
		--extract-media=media \
		-f markdown+smart \
		> $@
