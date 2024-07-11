declare -a checkFlagsArray
declare -a cargoTestFlagsArray

cargoCheckHook() {
    echo "Executing cargoCheckHook"

    runHook preCheck

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        pushd "${buildAndTestSubdir}"
    fi

    if [[ -z ${dontUseCargoParallelTests-} ]]; then
        threads=$NIX_BUILD_CORES
    else
        threads=1
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

    (
        set -x
        cargo test \
              -j $NIX_BUILD_CORES \
              ${cargoCheckProfileFlag} \
              ${cargoCheckNoDefaultFeaturesFlag} \
              ${cargoCheckFeaturesFlag} \
              --target @rustHostPlatformSpec@ \
              --offline \
              ${cargoTestFlags} \
              ${cargoTestFlagsArray+"${cargoTestFlagsArray[@]}"} \
              -- \
              --test-threads=${threads} \
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
