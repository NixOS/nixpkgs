source $stdenv/setup

buildFlags="-f Makefile.bmp"

installPhase=installPhase
installPhase() {
    ensureDir "$out/lib/bmp/Input"
    cp libwma.so "$out/lib/bmp/Input"
}

genericBuild
