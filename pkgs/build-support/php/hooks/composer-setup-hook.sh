composerSetupPreConfigureHook() {
    echo "Executing composerSetupPreConfigureHook"

    if [[ -z $composerDeps ]]; then
        die "composerSetupPreConfigureHook: missing composerDeps variable."
    fi

    if [[ ! -f $composerDeps/packages.json ]]; then
        die "composerSetupPreConfigureHook: Package passed to composerDeps is likely not a Composer repository - it lacks packages.json file."
    fi

    if [[ -n $composerRoot ]]; then
        pushd "$composerRoot"
    fi

    # Disable fetching from packagist.
    composer config repo.packagist false

    # Add our custom repo.
    composer config repo.c4 '{"type": "composer", "url": "file://'"$composerDeps"'"}'

    # Synchronize the lock file with the config changes.
    composer update --lock

    if [[ -n $composerRoot ]]; then
        popd
    fi

    echo "Finished composerSetupPreConfigureHook"
}

if [[ -z "${dontComposerSetupPreConfigure-}" ]]; then
    preConfigureHooks+=(composerSetupPreConfigureHook)
fi
