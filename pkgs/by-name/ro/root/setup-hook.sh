addRootIncludePath() {
    addToSearchPath ROOT_INCLUDE_PATH $1/include
}

addEnvHooks "$targetOffset" addRootIncludePath
