preConfigurePhases="${preConfigurePhases:-} autoreconfPhase"

autoreconfPhase() {
    runHook preAutoreconf
    autoreconf ${autoreconfFlags:---install --force --verbose}
    runHook postAutoreconf
}
