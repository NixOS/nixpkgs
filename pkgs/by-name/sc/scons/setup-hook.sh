# shellcheck shell=bash disable=SC2206

sconsConfigurePhase() {
    runHook preConfigure

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "scons/setup-hook: enabled parallel building"
    fi

    runHook postConfigure
}

sconsBuildPhase() {
    runHook preBuild

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        prependToVar buildFlags "${prefixKey:-prefix=}$prefix"
    fi

    local flagsArray=(
      ${enableParallelBuilding:+-j${NIX_BUILD_CORES}}
    )
    concatTo flagsArray sconsFlags sconsFlagsArray buildFlags buildFlagsArray

    echoCmd 'scons build flags' "${flagsArray[@]}"
    scons "${flagsArray[@]}"

    runHook postBuild
}

sconsInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        prependToVar installFlags "${prefixKey:-prefix=}$prefix"
    fi

    local flagsArray=(
        ${enableParallelInstalling:+-j${NIX_BUILD_CORES}}
    )
    concatTo flagsArray sconsFlags sconsFlagsArray installFlags installFlagsArray installTargets=install

    echoCmd 'scons install flags' "${flagsArray[@]}"
    scons "${flagsArray[@]}"

    runHook postInstall
}

sconsCheckPhase() {
    runHook preCheck

    if [ -z "${checkTarget:-}" ]; then
        if scons -n check >/dev/null 2>&1; then
            checkTarget="check"
        elif scons -n test >/dev/null 2>&1; then
            checkTarget="test"
        fi
    fi

    if [ -z "${checkTarget:-}" ]; then
        echo "no check/test target found, doing nothing"
    else
        local flagsArray=(
            ${enableParallelChecking:+-j${NIX_BUILD_CORES}}
        )
        concatTo flagsArray sconsFlags sconsFlagsArray checkFlagsArray checkTarget

        echoCmd 'scons check flags' "${flagsArray[@]}"
        scons "${flagsArray[@]}"
    fi

    runHook postCheck
}

if [ -z "${dontUseSconsConfigure-}" ] && [ -z "${configurePhase-}" ]; then
    configurePhase=sconsConfigurePhase
fi

if [ -z "${dontUseSconsBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=sconsBuildPhase
fi

if [ -z "${dontUseSconsCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=sconsCheckPhase
fi

if [ -z "${dontUseSconsInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=sconsInstallPhase
fi
