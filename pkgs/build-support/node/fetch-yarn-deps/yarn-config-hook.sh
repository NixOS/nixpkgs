yarnConfigHook() {
    echo "Executing yarnConfigHook"

    # Use a constant HOME directory
    export HOME=$(mktemp -d)
    if [[ -n "$yarnOfflineCache" ]]; then
        offlineCache="$yarnOfflineCache"
    fi
    if [[ -z "$offlineCache" ]]; then
        echo yarnConfigHook: No yarnOfflineCache or offlineCache were defined\! >&2
        exit 2
    fi
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn install \
        --frozen-lockfile \
        --force \
        --production=false \
        --ignore-engines \
        --ignore-platform \
        --ignore-scripts \
        --no-progress \
        --non-interactive \
        --offline

    # TODO: Check if this is really needed
    patchShebangs node_modules

    echo "finished yarnConfigHook"
}

if [[ -z "${dontYarnInstallDeps-}" ]]; then
    postConfigureHooks+=(yarnConfigHook)
fi
