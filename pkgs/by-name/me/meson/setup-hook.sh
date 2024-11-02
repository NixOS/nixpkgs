# shellcheck shell=bash disable=SC2206

mesonConfigurePhase() {
    runHook preConfigure

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

    concatTo flagsArray mesonFlags mesonFlagsArray

    echoCmd 'mesonConfigurePhase flags' "${flagsArray[@]}"

    meson setup build "${flagsArray[@]}"
    cd build || { echoCmd 'mesonConfigurePhase' "could not cd to build"; exit 1; }

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

    echoCmd 'mesonCheckPhase flags' "${flagsArray[@]}"
    meson test --no-rebuild --print-errorlogs "${flagsArray[@]}"

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
