addRLibPath () {
    appendToSearchPath R_LIBS_SITE $1/library
}

envHooks+=(addRLibPath)
