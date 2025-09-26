# shellcheck shell=bash disable=SC2154,SC2164

cargoNextestHook() {
    echo "Executing cargoNextestHook"

    runHook preCheck

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        pushd "${buildAndTestSubdir}"
    fi

    local flagsArray=(
        "--target" "@rustcTargetSpec@"
        "--offline"
    )

    if [[ -z ${dontUseCargoParallelTests-} ]]; then
        flagsArray+=("-j" "$NIX_BUILD_CORES")
    else
        flagsArray+=("-j" "1")
    fi

    if [ "${cargoCheckType}" != "debug" ]; then
        flagsArray+=("--cargo-profile" "${cargoCheckType}")
    fi

    if [ -n "${cargoCheckNoDefaultFeatures-}" ]; then
        flagsArray+=("--no-default-features")
    fi

    if [ -n "${cargoCheckFeatures-}" ]; then
        flagsArray+=("--features=$(concatStringsSep "," cargoCheckFeatures)")
    fi

    prependToVar checkFlags "--"
    concatTo flagsArray cargoTestFlags checkFlags checkFlagsArray

    echoCmd 'cargoNextestHook flags' "${flagsArray[@]}"
    cargo nextest run "${flagsArray[@]}"

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        popd
    fi

    echo "Finished cargoNextestHook"

    runHook postCheck
}

if [ -z "${dontCargoCheck-}" ] && [ -z "${checkPhase-}" ]; then
  checkPhase=cargoNextestHook
fi
