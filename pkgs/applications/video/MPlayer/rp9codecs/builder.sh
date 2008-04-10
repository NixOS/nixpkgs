source $stdenv/setup

buildPhase=true

installPhase() {
    mkdir $out
    cp -prv * $out
}
installPhase=installPhase

genericBuild
