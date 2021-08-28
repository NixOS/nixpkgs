preConfigurePhases+=" mesonShlibsToStaticPhase"

mesonShlibsToStaticPhase() {
    runHook preMesonShlibsToStatic
	replaceMesonFunction() {
		foundFiles=$(find . -name "meson.build" -exec grep -El "	* *$1 *\(" {} \;)
		for mesonFile in $foundFiles
		do
			echo "$mesonFile";
			cp "$mesonFile" "$mesonFile.tmp_file_mesonShlibsToStaticPhase"
			sed -i -E "s=(	* *)$1( *)\(=\1$2(\2=g" "$mesonFile";
			echo -n "[meson-shlibs-to-static] applied patch : "
			diff -u "$mesonFile.tmp_file_mesonShlibsToStaticPhase" "$mesonFile" || echo ""
			rm -f "$mesonFile.tmp_file_mesonShlibsToStaticPhase"
		done
	}
	replaceMesonFunction "shared_library" "static_library"
	replaceMesonFunction "shared_module" "static_library"

    runHook postMesonShlibsToStatic
}
