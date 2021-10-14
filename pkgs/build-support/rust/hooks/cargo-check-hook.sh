declare -a checkFlags
declare -a cargoTestFlags

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
        cargoCheckProfileFlag="--${cargoCheckType}"
    fi

    argstr="${cargoCheckProfileFlag} --target @rustTargetPlatformSpec@ --frozen ${cargoTestFlags}";

    (
        set -x
        cargo test \
              -j $NIX_BUILD_CORES \
              ${argstr} -- \
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
