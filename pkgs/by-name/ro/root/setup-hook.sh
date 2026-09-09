thisroot () {
    source @out@/bin/thisroot.sh
}

postHooks+=(thisroot)

addRootIncludePath() {
    addToSearchPath ROOT_INCLUDE_PATH $1/include
}

addEnvHooks "$targetOffset" addRootIncludePath
