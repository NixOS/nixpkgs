addRLibPath () {
    addToSearchPath R_LIBS_SITE $1/library
}

envHooks=(${envHooks[@]} addRLibPath)
