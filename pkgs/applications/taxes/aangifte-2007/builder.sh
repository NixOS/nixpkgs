source $stdenv/setup

buildPhase=buildPhase
buildPhase() {
    for i in bin/*; do
        patchelf \
            --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
            --set-rpath $libX11/lib:$libXext/lib:$libSM/lib \
            $i
    done
}

installPhase=installPhase
installPhase() {
    ensureDir $out
    cp -prvd * $out/
}

genericBuild