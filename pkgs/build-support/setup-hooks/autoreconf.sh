preConfigurePhases="${preConfigurePhases:-} autoreconfPhase"

autoreconfPhase() {
    runHook preAutoreconf

    local flagsArray=()
    if [[ -v autoreconfFlags ]]; then
        concatTo flagsArray autoreconfFlags
    else
        flagsArray+=(--install --force --verbose)
    fi

    autoreconf "${flagsArray[@]}"
    runHook postAutoreconf
}
