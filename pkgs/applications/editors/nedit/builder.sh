source $stdenv/setup

export NIX_CFLAGS_COMPILE="-DBUILD_UNTESTED_NEDIT -L$motif/lib $NIX_CFLAGS_COMPILE"

installPhase() {
    ensureDir $out/bin
    cp -p source/nedit source/nc $out/bin
}

genericBuild
