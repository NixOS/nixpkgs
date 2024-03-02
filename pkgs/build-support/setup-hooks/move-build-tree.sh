prePhases+=" moveBuildDir"

moveBuildDir() {
    mkdir -p $out/.build
    cd $out/.build
}

postPhases+=" removeBuildDir"

removeBuildDir() {
    rm -rf $out/.build
}
