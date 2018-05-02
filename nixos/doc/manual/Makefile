debug:
	nix-shell --packages xmloscopy \
		--run 'xmloscopy --docbook5 ./manual.xml ./manual-combined.xml'

generated: ./options-to-docbook.xsl
	nix-build ../../release.nix \
		--attr manualGeneratedSources.x86_64-linux \
		--out-link ./generated
