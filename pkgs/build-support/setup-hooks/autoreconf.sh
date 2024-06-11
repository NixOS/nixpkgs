preConfigurePhases="${preConfigurePhases:-} autoreconfPhase"

autoreconfPhase() {
    runHook preAutoreconf

    local flagsArray=()
    : "${autoreconfFlags:=--install --force --verbose}"
    concatTo flagsArray autoreconfFlags

    autoreconf "${flagsArray[@]}"
    runHook postAutoreconf
}
