# shellcheck shell=bash

build2ConfigurePhase() {
    runHook preConfigure

    local flagsArray=(
        "config.c=$CC"
        "config.cxx=$CXX"
        "config.cc.coptions+=-O2"
        "config.cc.poptions+=-DNDEBUG"
        "config.install.root=$prefix"
        "config.install.bin=${!outputBin}/bin"
        "config.install.doc=${!outputDoc}/share/doc/${shareDocName}"
        "config.install.exec_root=${!outputBin}"
        "config.install.include=${!outputInclude}/include"
        "config.install.lib=${!outputLib}/lib"
        "config.install.libexec=${!outputLib}/libexec"
        "config.install.man=${!outputDoc}/share/man"
        "config.install.sbin=${!outputBin}/sbin"
        "config.install.bin.mode=755"
    )
    concatTo flagsArray build2ConfigureFlags build2ConfigureFlagsArray

    # shellcheck disable=SC2157
    if [ -n "@isTargetDarwin@" ]; then
        flagsArray+=("config.bin.ld=ld64-lld")
        flagsArray+=("config.cc.loptions+=-fuse-ld=lld")
        flagsArray+=("config.cc.loptions+=-headerpad_max_install_names")
    fi

    echo 'configure flags' "${flagsArray[@]}"

    b configure "${flagsArray[@]}"

    runHook postConfigure
}

build2BuildPhase() {
    runHook preBuild

    local flagsArray=()
    concatTo flagsArray build2BuildFlags build2BuildFlagsArray

    echo 'build flags' "${flagsArray[@]}"
    b "${flagsArray[@]}"

    runHook postBuild
}

build2CheckPhase() {
    runHook preCheck

    local flagsArray=()
    concatTo flagsArray build2CheckFlags build2CheckFlags

    echo 'check flags' "${flagsArray[@]}"

    b test "${build2Dir:-.}" "${flagsArray[@]}"

    runHook postCheck
}

build2InstallPhase() {
    runHook preInstall

    local flagsArray=()
    concatTo flagsArray build2InstallFlags build2InstallFlagsArray installTargets

    echo 'install flags' "${flagsArray[@]}"
    b install "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseBuild2Configure-}" ] && [ -z "${configurePhase-}" ]; then
    # shellcheck disable=SC2034
    setOutputFlags=
    configurePhase=build2ConfigurePhase
fi

if [ -z "${dontUseBuild2Build-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=build2BuildPhase
fi

if [ -z "${dontUseBuild2Check-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=build2CheckPhase
fi

if [ -z "${dontUseBuild2Install-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=build2InstallPhase
fi
