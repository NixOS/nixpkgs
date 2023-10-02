# shellcheck shell=bash disable=SC2086,SC2154,SC2206

addMakeFlags() {
    export prefix="$out"
    export MANDIR="${!outputMan}/share/man"
    export MANTARGET=man
    export BINOWN=
    export STRIP_FLAG=
}

bmakeBuildPhase() {
    runHook preBuild

    local flagsArray=(
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES}}
        SHELL="$SHELL"
        $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
        $buildFlags ${buildFlagsArray+"${buildFlagsArray[@]}"}
    )

    echoCmd 'build flags' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"

    runHook postBuild
}

bmakeCheckPhase() {
    runHook preCheck

    if [ -z "${checkTarget:-}" ]; then
        #TODO(@oxij): should flagsArray influence make -n?
        if bmake -n ${makefile:+-f $makefile} check >/dev/null 2>&1; then
            checkTarget="check"
        elif bmake -n ${makefile:+-f $makefile} test >/dev/null 2>&1; then
            checkTarget="test"
        fi
    fi

    if [ -z "${checkTarget:-}" ]; then
        echo "no test target found in bmake, doing nothing"
    else
        local flagsArray=(
            ${enableParallelChecking:+-j${NIX_BUILD_CORES}}
            SHELL="$SHELL"
            # Old bash empty array hack
            $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
            ${checkFlags:-VERBOSE=y} ${checkFlagsArray+"${checkFlagsArray[@]}"}
            ${checkTarget}
        )

        echoCmd 'check flags' "${flagsArray[@]}"
        bmake ${makefile:+-f $makefile} "${flagsArray[@]}"
    fi

    runHook postCheck
}

bmakeInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    local flagsArray=(
        ${enableParallelInstalling:+-j${NIX_BUILD_CORES}}
        SHELL="$SHELL"
        # Old bash empty array hack
        $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
        $installFlags ${installFlagsArray+"${installFlagsArray[@]}"}
        ${installTargets:-install}
    )

    echoCmd 'install flags' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"

    runHook postInstall
}

bmakeDistPhase() {
    runHook preDist

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    # Old bash empty array hack
    local flagsArray=(
        $distFlags ${distFlagsArray+"${distFlagsArray[@]}"} ${distTarget:-dist}
    )

    echo 'dist flags: %q' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"

    if [ "${dontCopyDist:-0}" != 1 ]; then
        mkdir -p "$out/tarballs"

        # Note: don't quote $tarballs, since we explicitly permit
        # wildcards in there.
        cp -pvd ${tarballs:-*.tar.gz} "$out/tarballs"
    fi

    runHook postDist
}

preConfigureHooks+=(addMakeFlags)

if [ -z "${dontUseBmakeBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=bmakeBuildPhase
fi

if [ -z "${dontUseBmakeCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=bmakeCheckPhase
fi

if [ -z "${dontUseBmakeInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=bmakeInstallPhase
fi

if [ -z "${dontUseBmakeDist-}" ] && [ -z "${distPhase-}" ]; then
    distPhase=bmakeDistPhase
fi
