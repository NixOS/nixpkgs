# shellcheck shell=bash

npmCheckHook() {
    echo "Executing npmCheckHook"

    runHook preCheck

    npm test $npmTestFlags "${npmTestFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"

    runHook postCheck

    echo "Finished npmCheckHook"
}

if [ -z "${dontNpmCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=npmCheckHook
fi
