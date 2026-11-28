# shellcheck shell=bash

ninjaBuildPhase() {
    runHook preBuild

    local buildCores=1
    local flagsArray=()

    # Parallel building is enabled by default.
    # NOTE: -j disables ninja's client jobserver mode.
    if [ "${enableParallelBuilding-1}" ] && ! inJobserver; then
        buildCores="$NIX_BUILD_CORES"
        flagsArray+=("-j$buildCores")
    elif [ -z "${enableParallelBuilding-1}" ]; then
        flagsArray+=("-j1")
    fi

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
        local flagsArray=()

        if [ "${enableParallelChecking-1}" ] && ! inJobserver; then
            buildCores="$NIX_BUILD_CORES"
            flagsArray+=("-j$buildCores")
        elif [ -z "${enableParallelChecking-1}" ]; then
          flagsArray+=("-j1")
        fi

        concatTo flagsArray ninjaFlags ninjaFlagsArray checkTarget

        echoCmd 'check flags' "${flagsArray[@]}"
        TERM=dumb ninja "${flagsArray[@]}"
    fi

    runHook postCheck
}

ninjaInstallPhase() {
    runHook preInstall

    local buildCores=1
    local flagsArray=()

    # Parallel building is enabled by default.
    if [ "${enableParallelInstalling-1}" ] && ! inJobserver; then
        buildCores="$NIX_BUILD_CORES"
        flagsArray+=("-j$buildCores")
    elif [ -z "${enableParallelInstalling-1}" ]; then
        flagsArray+=("-j1")
    fi

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
