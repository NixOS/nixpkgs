. $stdenv/setup

preConfigure=preConfigure
preConfigure() {
    cat > .mozconfig <<EOF
. \$topsrcdir/browser/config/mozconfig
ac_add_options --prefix=$out
ac_add_options --enable-optimize
ac_add_options --disable-debug
ac_add_options --enable-xft
ac_add_options --enable-swg
ac_add_options --enable-strip
ac_add_options --enable-default-toolkit=gtk2
#ac_add_options --disable-shared
#ac_add_options --enable-static
EOF
}

makeFlags="-f client.mk build"

genericBuild

# Strip some more stuff
strip -S $out/lib/*/* || true

# We don't need this (do we?)
rm -rf $out/include
