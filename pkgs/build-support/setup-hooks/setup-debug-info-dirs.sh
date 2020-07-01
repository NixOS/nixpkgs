setupDebugInfoDirs () {
    addToSearchPath NIX_DEBUG_INFO_DIRS $1/lib/debug
}

addEnvHooks "$targetOffset" setupDebugInfoDirs
