pytestXdistHook() {
    pytestFlagsArray+=(
        "--numprocesses=$NIX_BUILD_CORES"
    )
}

# the flags should be added before pytestCheckHook runs so
# until we have dependency mechanism in generic builder, we need to use this ugly hack.

if [ -z "${dontUsePytestXdist-}" ] && [ -z "${dontUsePytestCheck-}" ]; then
    if [[ " ${preDistPhases[*]:-} " =~ " pytestCheckPhase " ]]; then
        _preDistPhases="${preDistPhases[*]} "
        _preDistPhases="${_preDistPhases/ pytestCheckPhase / pytestXdistHook pytestCheckPhase }"
        if [[ -n "${__structuredAttrs-}" ]]; then
            preDistPhases=()
        else
            preDistPhases=""
        fi
        appendToVar preDistPhases $_preDistPhases
        unset _preDistPhases
    else
        appendToVar preDistPhases pytestXdistHook
    fi
fi
