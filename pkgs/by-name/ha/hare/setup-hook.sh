addHarepath () {
    for haredir in third-party stdlib; do
        if [[ -d "$1/src/hare/$haredir" ]]; then
            addToSearchPath HAREPATH "$1/src/hare/$haredir"
        fi
    done
}

addEnvHooks "$hostOffset" addHarepath
