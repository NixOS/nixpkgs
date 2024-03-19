addRLibPath () {
    if [[ -d "$1/library" ]]; then
        addToSearchPath R_LIBS_SITE "$1/library"
    fi
}

addEnvHooks "$targetOffset" addRLibPath
