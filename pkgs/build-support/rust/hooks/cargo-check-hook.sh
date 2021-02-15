declare -a checkFlags

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

    argstr="--${cargoBuildType} --target @rustTargetPlatformSpec@ --frozen";

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

if [ -z "${checkPhase-}" ]; then
  checkPhase=cargoCheckHook
fi
