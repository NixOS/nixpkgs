haredoBuildPhase() {
    runHook preBuild

    local buildTargets jobs
    read -ra buildTargets <<<"${haredoBuildTargets-}"
    echoCmd "haredo build targets" "${buildTargets[@]}"
    if [[ ! -v enableParallelBuilding || -n "${enableParallelBuilding-}" ]]; then
        jobs="${NIX_BUILD_CORES}"
    fi
    haredo ${jobs:+"-j${jobs}"} "${buildTargets[@]}"

    runHook postBuild
}

haredoCheckPhase() {
    runHook preCheck

    local checkTargets jobs

    if [[ -n "${haredoCheckTargets:-}" ]]; then
        read -ra checkTargets <<<"${haredoCheckTargets}"
    else
        for dofile in "check.do" "test.do"; do
            [[ -r "${dofile}" ]] && {
                checkTargets=("${dofile%".do"}")
                break
            }
        done
    fi

    if [[ -z "${checkTargets:-}" ]]; then
        printf -- 'haredoCheckPhase ERROR: no check targets were found' 1>&2
        exit 1
    else
        echoCmd "haredo check targets" "${checkTargets[@]}"
        if [[ ! -v enableParallelChecking || -n "${enableParallelChecking-}" ]]; then
            jobs="${NIX_BUILD_CORES}"
        fi
        haredo ${jobs:+"-j${jobs}"} "${checkTargets[@]}"
    fi

    runHook postCheck
}

haredoInstallPhase() {
    runHook preInstall

    local installTargets jobs
    read -ra installTargets <<<"${haredoInstallTargets:-"install"}"
    echoCmd "haredo install targets" "${installTargets[@]}"
    if [[ ! -v enableParallelInstalling || -n "${enableParallelInstalling-}" ]]; then
        jobs="${NIX_BUILD_CORES}"
    fi
    haredo ${jobs:+"-j${jobs}"} "${installTargets[@]}"

    runHook postInstall
}

if [[ -z "${dontUseHaredoBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase="haredoBuildPhase"
fi

if [[ -z "${dontUseHaredoCheck-}" && -z "${checkPhase-}" ]]; then
    checkPhase="haredoCheckPhase"
fi

if [[ -z "${dontUseHaredoInstall-}" && -z "${installPhase-}" ]]; then
    installPhase="haredoInstallPhase"
fi
