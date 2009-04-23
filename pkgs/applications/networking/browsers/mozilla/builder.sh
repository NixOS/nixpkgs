source $stdenv/setup

preConfigure() {
    cat > .mozconfig <<EOF
#. \$topsrcdir/browser/config/mozconfig
ac_add_options --prefix=$out
ac_add_options --enable-optimize
ac_add_options --disable-debug
ac_add_options --enable-xft
ac_add_options --disable-freetype2
#ac_add_options --enable-swg
ac_add_options --enable-strip
ac_add_options --enable-default-toolkit=gtk2
#ac_add_options --disable-shared
#ac_add_options --enable-static
#ac_add_options --with-system-jpeg
#ac_add_options --with-system-png
#ac_add_options --with-system-zlib
EOF
}

postInstall() {

    # Strip some more stuff
    strip -S $out/lib/*/* || true

    # We don't need this (do we?)
#    rm -rf $out/include

    # This fixes starting Firefox when there already is a running
    # instance.  The `firefox' wrapper script actually expects to be
    # in the same directory as `run-mozilla.sh', apparently.
    cd $out/bin
    mv firefox ../lib/firefox-*/
    ln -s ../lib/firefox-*/firefox .

    # Register extension etc.
    echo "running firefox -register..."
    (cd $out/lib/firefox-* && LD_LIBRARY_PATH=. ./firefox-bin -register) || false

    echo "running regxpcom..."
    (cd $out/lib/firefox-* && LD_LIBRARY_PATH=. ./regxpcom) || false
    
#    echo "running regchrome..."
#    (cd $out/lib/firefox-* && LD_LIBRARY_PATH=. ./regchrome) || false
    
}

buildFlags="-f client.mk build"

genericBuild
