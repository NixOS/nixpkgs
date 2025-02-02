# shellcheck shell=bash disable=SC2154,SC2164

cargoCheckHook() {
    echo "Executing cargoCheckHook"

    runHook preCheck

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        pushd "${buildAndTestSubdir}"
    fi

    local flagsArray=("-j" "$NIX_BUILD_CORES")

    if [[ -z ${dontUseCargoParallelTests-} ]]; then
        prependToVar checkFlags "--test-threads=$NIX_BUILD_CORES"
    else
        prependToVar checkFlags "--test-threads=1"
    fi

    if [ "${cargoCheckType}" != "debug" ]; then
        flagsArray+=("--profile" "${cargoCheckType}")
    fi

    if [ -n "${cargoCheckNoDefaultFeatures-}" ]; then
        flagsArray+=("--no-default-features")
    fi

    if [ -n "${cargoCheckFeatures-}" ]; then
        flagsArray+=("--features=$(concatStringsSep "," cargoCheckFeatures)")
    fi

    flagsArray+=(
        "--target" "@rustHostPlatformSpec@"
        "--offline"
    )

    prependToVar checkFlags "--"
    concatTo flagsArray cargoTestFlags checkFlags checkFlagsArray

    echoCmd 'cargoCheckHook flags' "${flagsArray[@]}"
    @setEnv@ cargo test "${flagsArray[@]}"

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        popd
    fi

    echo "Finished cargoCheckHook"

    runHook postCheck
}

if [ -z "${dontCargoCheck-}" ] && [ -z "${checkPhase-}" ]; then
  checkPhase=cargoCheckHook
fi
