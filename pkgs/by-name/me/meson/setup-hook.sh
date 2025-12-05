# shellcheck shell=bash disable=SC2206

mesonConfigurePhase() {
    runHook preConfigure

    : ${mesonBuildDir:=build}

    local flagsArray=()

    if [ -z "${dontAddPrefix-}" ]; then
        flagsArray+=("--prefix=$prefix")
    fi

    # See multiple-outputs.sh and meson’s coredata.py
    flagsArray+=(
        "--libdir=${!outputLib}/lib"
        "--libexecdir=${!outputLib}/libexec"
        "--bindir=${!outputBin}/bin"
        "--sbindir=${!outputBin}/sbin"
        "--includedir=${!outputInclude}/include"
        "--mandir=${!outputMan}/share/man"
        "--infodir=${!outputInfo}/share/info"
        "--localedir=${!outputLib}/share/locale"
        "-Dauto_features=${mesonAutoFeatures:-enabled}"
        "-Dwrap_mode=${mesonWrapMode:-nodownload}"
        "--buildtype=${mesonBuildType:-plain}"
    )

    # --no-undefined is universally a bad idea on freebsd because environ is in the csu
    if [[ "@hostPlatform@" == *-freebsd ]]; then
        flagsArray+=("-Db_lundef=false")
    fi

    concatTo flagsArray mesonFlags mesonFlagsArray

    echoCmd 'mesonConfigurePhase flags' "${flagsArray[@]}"

    meson setup "$mesonBuildDir" "${flagsArray[@]}"
    cd "$mesonBuildDir" || { echoCmd 'mesonConfigurePhase' "could not cd to $mesonBuildDir"; exit 1; }

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echoCmd 'mesonConfigurePhase' "enabled parallel building"
    fi

    if [[ ${checkPhase-ninjaCheckPhase} = ninjaCheckPhase && -z $dontUseMesonCheck ]]; then
        checkPhase=mesonCheckPhase
    fi
    if [[ ${installPhase-ninjaInstallPhase} = ninjaInstallPhase && -z $dontUseMesonInstall ]]; then
        installPhase=mesonInstallPhase
    fi

    runHook postConfigure
}

mesonCheckPhase() {
    runHook preCheck

    local flagsArray=()
    concatTo flagsArray mesonCheckFlags mesonCheckFlagsArray

    if [ -z "${dontAddTimeoutMultiplier:-}" ]; then
        flagsArray+=("--timeout-multiplier=0")
    fi

    # Parallel checking is enabled by default.
    local buildCores=1
    if [ "${enableParallelChecking-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    TERM=dumb ninja -j"$buildCores" $ninjaFlags "${ninjaFlagsArray[@]}" meson-test-prereq

    echoCmd 'mesonCheckPhase flags' "${flagsArray[@]}"
    meson test --no-rebuild --print-errorlogs --max-lines=1000000 "${flagsArray[@]}"

    runHook postCheck
}

mesonInstallPhase() {
    runHook preInstall

    local flagsArray=()

    if [[ -n "$mesonInstallTags" ]]; then
        flagsArray+=("--tags" "$(concatStringsSep "," mesonInstallTags)")
    fi
    concatTo flagsArray mesonInstallFlags mesonInstallFlagsArray

    echoCmd 'mesonInstallPhase flags' "${flagsArray[@]}"
    meson install --no-rebuild "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseMesonConfigure-}" ] && [ -z "${configurePhase-}" ]; then
    # shellcheck disable=SC2034
    setOutputFlags=
    configurePhase=mesonConfigurePhase
fi
