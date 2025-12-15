appendToVar prePhases moveBuildDir

moveBuildDir() {
    mkdir -p $out/.build
    cd $out/.build
}

appendToVar postPhases removeBuildDir

removeBuildDir() {
    rm -rf $out/.build
}
