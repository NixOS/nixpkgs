. $stdenv/setup
. $makeWrapper

postInstall=postInstall
postInstall() {
    mv $out/bin $out/bin-orig
    mkdir $out/bin

    for i in $out/bin-orig/*; do
        echo "wrapping $(basename $i)"
        # !!! TODO: figure out the MONO_GAC_PREFIX automatically
        makeWrapper "$i" "$out/bin/$(basename $i)" \
            --suffix PATH ':' "$(dirname $(type -p mono))" \
            --suffix LD_LIBRARY_PATH ':' "$sqlite/lib" \
            --suffix LD_LIBRARY_PATH ':' "$libgnomeui/lib/libglade/2.0" \
            --suffix MONO_GAC_PREFIX ':' "$gtksharp"
    done
    
    # !!! hack
    export ALL_INPUTS="$out $pkgs"

    find $out -name "*.dll.config" -o -name "*.exe.config" | while read configFile; do
        echo "modifying config file $configFile"
        $monoDLLFixer "$configFile"
    done
}

genericBuild
