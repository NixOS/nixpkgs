. $stdenv/setup
. $makeWrapper

export PERL5LIB=$perlXMLParser/lib/site_perl:$PERL5LIB

export MONO_GAC_PREFIX=$monodoc:$gtksharp

postInstall=postInstall
postInstall() {
    mv $out/bin $out/bin-orig
    mkdir $out/bin

    for i in $out/bin-orig/*; do
        echo "wrapping $(basename $i)"
        # !!! TODO: figure out the MONO_GAC_PREFIX automatically
        makeWrapper "$i" "$out/bin/$(basename $i)" \
            --suffix PATH ':' "$(dirname $(type -p mono))" \
            --suffix LD_LIBRARY_PATH ':' "$gtksharp/lib" \
            --suffix MONO_GAC_PREFIX ':' "$gtksharp" \
            --suffix MONO_GAC_PREFIX ':' "$gtkmozembedsharp" \
            --suffix MONO_GAC_PREFIX ':' "$gtksourceviewsharp" \
            --suffix MONO_GAC_PREFIX ':' "$monodoc"
    done
}

genericBuild

