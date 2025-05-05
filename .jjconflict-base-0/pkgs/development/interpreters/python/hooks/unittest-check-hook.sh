# Setup hook for unittest.
# shellcheck shell=bash

echo "Sourcing unittest-check-hook"

unittestCheckPhase() {
    echo "Executing unittestCheckPhase"
    runHook preCheck

    local -a flagsArray=()

    # Compatibility layer to the obsolete unittestFlagsArray
    eval "flagsArray+=(${unittestFlagsArray[*]-})"

    concatTo flagsArray unittestFlags
    echoCmd 'unittest flags' "${flagsArray[@]}"
    @pythonCheckInterpreter@ -m unittest discover "${flagsArray[@]}"

    runHook postCheck
    echo "Finished executing unittestCheckPhase"
}

if [[ -z "${dontUseUnittestCheck-}" ]] && [[ -z "${installCheckPhase-}" ]]; then
    echo "Using unittestCheckPhase"
    appendToVar preDistPhases unittestCheckPhase
fi
