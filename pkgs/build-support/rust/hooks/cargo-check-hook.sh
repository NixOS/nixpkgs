declare -a checkFlags
declare -a cargoTestFlags

cargoCheckHook() {
    echo "Executing cargoCheckHook"

    runHook preCheck

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        pushd "${buildAndTestSubdir}"
    fi

    if [[ -z ${dontUseCargoParallelTests-} ]]; then
        export RUST_TEST_THREADS=$NIX_BUILD_CORES
    else
        export RUST_TEST_THREADS=1
    fi

    if [ "${cargoCheckType}" != "debug" ]; then
        cargoCheckProfileFlag="--profile ${cargoCheckType}"
    fi

    if [ -n "${cargoCheckNoDefaultFeatures-}" ]; then
        cargoCheckNoDefaultFeaturesFlag=--no-default-features
    fi

    if [ -n "${cargoCheckFeatures-}" ]; then
        cargoCheckFeaturesFlag="--features=${cargoCheckFeatures// /,}"
    fi

    argstr="${cargoCheckProfileFlag} ${cargoCheckNoDefaultFeaturesFlag} ${cargoCheckFeaturesFlag}
        --target @rustHostPlatformSpec@ --offline ${cargoTestFlags}"

    (
        set -x
        cargo test \
              -j $NIX_BUILD_CORES \
              ${argstr} -- \
              ${checkFlags} \
              ${checkFlagsArray+"${checkFlagsArray[@]}"}
    )

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        popd
    fi

    echo "Finished cargoCheckHook"

    runHook postCheck
}

if [ -z "${dontCargoCheck-}" ] && [ -z "${checkPhase-}" ]; then
  checkPhase=cargoCheckHook
fi
