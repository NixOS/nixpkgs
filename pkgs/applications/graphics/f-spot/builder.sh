source $stdenv/setup
source $makeWrapper

postInstall() {
    mv $out/bin $out/bin-orig
    mkdir $out/bin

    for i in $out/bin-orig/*; do
        echo "wrapping $(basename $i)"
        # !!! TODO: figure out the MONO_GAC_PREFIX automatically
        makeWrapper "$i" "$out/bin/$(basename $i)" \
            --prefix PATH ':' "$(dirname $(type -p mono))" \
            --prefix LD_LIBRARY_PATH ':' "$sqlite/lib" \
            --prefix LD_LIBRARY_PATH ':' "$libgnomeui/lib/libglade/2.0" \
            --prefix MONO_GAC_PREFIX ':' "$gtksharp"
    done
    
    # !!! hack
    export ALL_INPUTS="$out $pkgs"

    find $out -name "*.dll.config" -o -name "*.exe.config" | while read configFile; do
        echo "modifying config file $configFile"
        $monoDLLFixer "$configFile"
    done
}

genericBuild
