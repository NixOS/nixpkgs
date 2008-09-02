source $stdenv/setup

dontStrip=1
dontPatchELF=1

installPhase() {
    ensureDir $out/lib/mozilla/plugins
    cp -p libflashplayer.so $out/lib/mozilla/plugins
    patchelf --set-rpath "$zlib/lib:$alsaLib/lib" $out/lib/mozilla/plugins/libflashplayer.so
}

genericBuild
