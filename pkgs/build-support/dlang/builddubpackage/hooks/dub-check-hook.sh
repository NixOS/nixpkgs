dubCheckHook() {
    runHook preCheck
    echo "Executing dubCheckHook"

    local flagsArray=(
        --skip-registry=all
    )
    concatTo flagsArray dubTestFlags dubFlags

    echoCmd 'dubCheckHook flags' "${flagsArray[@]}"
    dub test "${flagsArray[@]}"

    echo "Finished dubCheckHook"
    runHook postCheck
}

if [[ -z "${dontDubCheck-}" && -z "${checkPhase-}" ]]; then
    checkPhase=dubCheckHook
fi
