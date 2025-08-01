# shellcheck shell=bash

ninjaBuildPhase() {
    runHook preBuild

    local buildCores=1

    # Parallel building is enabled by default.
    if [ "${enableParallelBuilding-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        "-j$buildCores"
    )
    concatTo flagsArray ninjaFlags ninjaFlagsArray

    echoCmd 'build flags' "${flagsArray[@]}"
    TERM=dumb ninja "${flagsArray[@]}"

    runHook postBuild
}

ninjaCheckPhase() {
    runHook preCheck

    if [ -z "${checkTarget:-}" ]; then
        if ninja -t query test >/dev/null 2>&1; then
            checkTarget="test"
        fi
    fi

    if [ -z "${checkTarget:-}" ]; then
        echo "no test target found in ninja, doing nothing"
    else
        local buildCores=1

        if [ "${enableParallelChecking-1}" ]; then
            buildCores="$NIX_BUILD_CORES"
        fi

        local flagsArray=(
            "-j$buildCores"
        )
        concatTo flagsArray ninjaFlags ninjaFlagsArray checkTarget

        echoCmd 'check flags' "${flagsArray[@]}"
        TERM=dumb ninja "${flagsArray[@]}"
    fi

    runHook postCheck
}

ninjaInstallPhase() {
    runHook preInstall

    local buildCores=1

    # Parallel building is enabled by default.
    if [ "${enableParallelInstalling-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    # shellcheck disable=SC2086
    local flagsArray=(
        "-j$buildCores"
    )
    concatTo flagsArray ninjaFlags ninjaFlagsArray installTargets=install

    echoCmd 'install flags' "${flagsArray[@]}"
    TERM=dumb ninja "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseNinjaBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=ninjaBuildPhase
fi

if [ -z "${dontUseNinjaCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=ninjaCheckPhase
fi

if [ -z "${dontUseNinjaInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=ninjaInstallPhase
fi
