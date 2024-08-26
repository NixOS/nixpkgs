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

    nixInfoLog "${FUNCNAME[0]}: flagsArray: ${flagsArray[@]}"

    meson setup build "${flagsArray[@]}"
    cd build || { nixErrorLog "${FUNCNAME[0]}: could not cd to build"; exit 1; }

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        nixInfoLog "${FUNCNAME[0]}: enabled parallel building"
    fi

    if [[ ${checkPhase-ninjaCheckPhase} = ninjaCheckPhase && -z $dontUseMesonCheck ]]; then
        checkPhase=mesonCheckPhase
        nixInfoLog "${FUNCNAME[0]}: set checkPhase to mesonCheckPhase"
    fi
    if [[ ${installPhase-ninjaInstallPhase} = ninjaInstallPhase && -z $dontUseMesonInstall ]]; then
        installPhase=mesonInstallPhase
        nixInfoLog "${FUNCNAME[0]}: set installPhase to mesonInstallPhase"
    fi

    runHook postConfigure
}

mesonCheckPhase() {
    runHook preCheck

    local flagsArray=()
    concatTo flagsArray mesonCheckFlags mesonCheckFlagsArray

    nixInfoLog "${FUNCNAME[0]}: flagsArray: ${flagsArray[@]}"
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

    nixInfoLog "${FUNCNAME[0]}: flagsArray: ${flagsArray[@]}"
    meson install --no-rebuild "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseMesonConfigure-}" ] && [ -z "${configurePhase-}" ]; then
    # shellcheck disable=SC2034
    setOutputFlags=
    configurePhase=mesonConfigurePhase
    nixInfoLog "${FUNCNAME[0]}: set configurePhase to mesonConfigurePhase"
fi
