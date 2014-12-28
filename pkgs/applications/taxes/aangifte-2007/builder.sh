source $stdenv/setup

echo $NIX_CC

buildPhase() {
    for i in bin/*; do
        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath $libX11/lib:$libXext/lib:$libSM/lib:$(cat $NIX_CC/nix-support/orig-gcc)/lib \
            $i
    done
}

installPhase() {
    mkdir -p $out
    cp -prvd * $out/
}

genericBuild
