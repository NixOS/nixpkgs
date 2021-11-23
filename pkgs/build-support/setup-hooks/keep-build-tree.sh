# shellcheck shell=bash
prePhases+=" moveBuildDir"

moveBuildDir() {
    mkdir -p $out/.build
    cd $out/.build
}
