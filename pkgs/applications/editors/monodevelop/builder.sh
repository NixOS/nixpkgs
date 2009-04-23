source $stdenv/setup
source $makeWrapper

export MONO_GAC_PREFIX=$monodoc:$gtksharp

postInstall() {
    mv $out/bin $out/bin-orig
    mkdir $out/bin

    moz=$(ls $mozilla/lib/*/libgtkembedmoz.so)

    for i in $out/bin-orig/*; do
        echo "wrapping $(basename $i)"
        # !!! TODO: figure out the MONO_GAC_PREFIX automatically
        makeWrapper "$i" "$out/bin/$(basename $i)" \
            --suffix PATH ':' "$(dirname $(type -p mono))" \
            --suffix PATH ':' "$(dirname $(type -p mono))" \
            --suffix LD_LIBRARY_PATH ':' "$gtksharp/lib" \
            --suffix MONO_GAC_PREFIX ':' "$gtksharp" \
            --suffix MONO_GAC_PREFIX ':' "$gtkmozembedsharp" \
            --suffix MONO_GAC_PREFIX ':' "$gtksourceviewsharp" \
            --suffix MONO_GAC_PREFIX ':' "$monodoc" \
            --set MOZILLA_FIVE_HOME "$(dirname $moz)"
    done
}

genericBuild

