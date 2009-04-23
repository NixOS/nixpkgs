source $stdenv/setup

buildPhase() {
    for i in bin/*; do
        patchelf \
            --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
            --set-rpath $libX11/lib:$libXext/lib \
            $i
    done
}

installPhase() {
    ensureDir $out
    cp -prvd * $out/
}

genericBuild
