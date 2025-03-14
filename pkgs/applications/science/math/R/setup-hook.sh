addRLibPath () {
    if [[ -d "$1/library" ]]; then
        appendToSearchPath R_LIBS_SITE "$1/library"
    fi
}

addEnvHooks "$targetOffset" addRLibPath
