linkNodeModulesHook() {
    echo "Executing linkNodeModulesHook"
    runHook preShellHook

    if [ -n "${npmRoot-}" ]; then
      pushd "$npmRoot"
    fi

    @nodejs@ @script@ @storePrefix@ "${npmDeps}/node_modules"
    if test -d node_modules/.bin; then
        export PATH=$(readlink -f node_modules/.bin):$PATH
    fi

    if [ -n "${npmRoot-}" ]; then
      popd
    fi

    runHook postShellHook
    echo "Finished executing linkNodeModulesShellHook"
}

if [ -z "${dontLinkNodeModules:-}" ] && [ -z "${shellHook-}" ]; then
    echo "Using linkNodeModulesHook shell hook"
    shellHook=linkNodeModulesHook
fi


if [ -z "${dontLinkNodeModules:-}" ]; then
    echo "Using linkNodeModulesHook preConfigure hook"
    preConfigureHooks+=(linkNodeModulesHook)
fi
