nobConfigurePhase() {
    runHook preConfigure

    cc nob.c -o nob

    runHook postConfigure
}

nobBuildPhase() {
    runHook preBuild

    ./nob

    runHook postBuild
}

nobInstallPhase() {
    runHook preInstall

    ./nob install

    runHook postInstall
}

if [ -z "${configurePhase}" ]; then
    configurePhase=nobConfigurePhase
fi

if [ -z "${buildPhase}" ]; then
    buildPhase=nobBuildPhase
fi

if [ -z "${installPhase}" ]; then
    installPhase=nobInstallPhase
fi
