addLeanPath() {
    local buildLib="$1/.lake/build/lib/lean"
    if [ -d "$buildLib" ]; then
        addToSearchPath LEAN_PATH "$buildLib"
    fi
}

addEnvHooks "$hostOffset" addLeanPath
