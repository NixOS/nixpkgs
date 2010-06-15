source $stdenv/setup
source $makeWrapper

postInstall() {
    mv $out/bin $out/bin-orig
    mkdir $out/bin

    for i in $out/bin-orig/*; do
        echo "wrapping $(basename $i)"
        # !!! TODO: figure out the MONO_GAC_PREFIX automatically
        makeWrapper "$i" "$out/bin/$(basename $i)" \
            --suffix PATH ':' "$(dirname $(type -p mono))" \
            --suffix MONO_GAC_PREFIX ':' "$gtksharp" \
            --suffix MONO_GAC_PREFIX ':' "$out"
    done
}

genericBuild


