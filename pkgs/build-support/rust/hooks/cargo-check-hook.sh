# shellcheck shell=bash disable=SC2154,SC2164

cargoCheckHook() {
    echo "Executing cargoCheckHook"

    runHook preCheck

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        pushd "${buildAndTestSubdir}"
    fi

    local flagsArray=("-j" "$NIX_BUILD_CORES")

    export RUST_TEST_THREADS=$NIX_BUILD_CORES
    if [[ ! -z ${dontUseCargoParallelTests-} ]]; then
        RUST_TEST_THREADS=1
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
        "--target" "@rustcTargetSpec@"
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
