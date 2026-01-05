dubCheckHook() {
    runHook preCheck
    echo "Executing dubCheckHook"

    dub test --skip-registry=all "${dubTestFlags[@]}" "${dubFlags[@]}"

    echo "Finished dubCheckHook"
    runHook postCheck
}

if [[ -z "${dontDubCheck-}" && -z "${checkPhase-}" ]]; then
    checkPhase=dubCheckHook
fi
