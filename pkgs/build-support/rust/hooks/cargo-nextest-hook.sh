declare -a checkFlags
declare -a cargoTestFlags

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
        cargoCheckProfileFlag="--${cargoCheckType}"
    fi

    if [ -n "${cargoCheckNoDefaultFeatures-}" ]; then
        cargoCheckNoDefaultFeaturesFlag=--no-default-features
    fi

    if [ -n "${cargoCheckFeatures-}" ]; then
        cargoCheckFeaturesFlag="--features=${cargoCheckFeatures// /,}"
    fi

    argstr="${cargoCheckProfileFlag} ${cargoCheckNoDefaultFeaturesFlag} ${cargoCheckFeaturesFlag}
        --target @rustTargetPlatformSpec@ --frozen ${cargoTestFlags}"

    (
        set -x
        cargo nextest run \
              -j ${threads} \
              ${argstr} -- \
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
