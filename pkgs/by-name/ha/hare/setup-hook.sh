readonly hareDefaultFlags=(@hare_default_flags@)

setHareEnv() {
    HARECACHE="$(mktemp -d)"
    export HARECACHE
    echoCmd 'HARECACHE' "$HARECACHE"
    HAREFLAGS="${HAREFLAGS-} ${hareDefaultFlags[*]}"
    export HAREFLAGS
    echoCmd 'HAREFLAGS' "$HAREFLAGS"
    makeFlagsArray+=(
        HARECACHE="$HARECACHE"
        HAREFLAGS="$HAREFLAGS"
    )
    echoCmd 'makeFlagsArray' "${makeFlagsArray[@]}"
}

addHarepath() {
    for haredir in third-party stdlib; do
        if [[ -d "$1/src/hare/$haredir" ]]; then
            addToSearchPath HAREPATH "$1/src/hare/$haredir"
        fi
    done
}

setHareEnv
addEnvHooks "${hostOffset:?}" addHarepath
