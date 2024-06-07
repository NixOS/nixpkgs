yarnConfigHook(){
    runHook preConfigure
    echo "Executing yarnConfigHook"

    # Use a constant HOME directory
    mkdir -p /tmp/home
    export HOME=/tmp/home
    # TODO: Maybe support other shell variables such as $yarnOfflineCache?
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install \
        --offline --frozen-lockfile \
        --force --production=false \
        --ignore-engines --ignore-scripts
    patchShebangs node_modules

    echo "finished yarnConfigHook"
    runHook postConfigure
}

if [[ -z "${dontYarnInstallDeps-}" && -z "${configurePhase-}" ]]; then
    configurePhase=yarnConfigHook
fi
