preConfigurePhases="${preConfigurePhases:-} autoreconfPhase"

autoreconfPhase() {
    runHook preAutoreconf

    if [ -z "$__structuredAttrs" ]; then
        autoreconfFlags=(${autoreconfFlags[*]})
    fi

    defaultFlags=(--install --force --verbose)
    autoreconf "${autoreconfFlags[@]:-"${defaultFlags[@]}"}"

    runHook postAutoreconf
}
