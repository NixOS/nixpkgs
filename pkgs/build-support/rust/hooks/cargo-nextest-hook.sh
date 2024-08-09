declare -a checkFlagsArray
declare -a cargoTestFlagsArray

cargoNextestHook() {
    echo "Executing cargoNextestHook"

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
        cargoCheckProfileFlag="--cargo-profile ${cargoCheckType}"
    fi

    if [ -n "${cargoCheckNoDefaultFeatures-}" ]; then
        cargoCheckNoDefaultFeaturesFlag=--no-default-features
    fi

    if [ -n "${cargoCheckFeatures-}" ]; then
        cargoCheckFeaturesFlag="--features=${cargoCheckFeatures// /,}"
    fi

    (
        set -x
        cargo nextest run \
              -j ${threads} \
              ${cargoCheckProfileFlag} \
              ${cargoCheckNoDefaultFeaturesFlag} \
              ${cargoCheckFeaturesFlag} \
              --target @rustHostPlatformSpec@ \
              --offline \
              ${cargoTestFlags} \
              ${cargoTestFlagsArray+"${cargoTestFlagsArray[@]}"} \
              -- \
              ${checkFlags} \
              ${checkFlagsArray+"${checkFlagsArray[@]}"}
    )

    if [[ -n "${buildAndTestSubdir-}" ]]; then
        popd
    fi

    echo "Finished cargoNextestHook"

    runHook postCheck
}

if [ -z "${dontCargoCheck-}" ] && [ -z "${checkPhase-}" ]; then
  checkPhase=cargoNextestHook
fi
