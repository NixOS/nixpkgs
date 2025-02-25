# shellcheck shell=bash
# shellcheck disable=SC2164

bunConfigHook() {
    echo "Executing bunConfigHook"

    if [ -n "${bunRoot-}" ]; then
      pushd "$bunRoot"
    fi

    if [ -z "${bunDeps-}" ]; then
      echo "Error: 'bunDeps' must be set when using bunConfigHook."
      exit 1
    fi

    # `bunDeps` should be a tarball
    unpackFile "$bunDeps"
    bunDepsCopy="$(stripHash "$bunDeps" | xargs realpath)"

    echo "Configuring bun store"

    HOME=$(mktemp -d)
    BUN_INSTALL_CACHE_DIR=$(mktemp -d)
    export HOME BUN_INSTALL_CACHE_DIR

    cp -Tr "$bunDepsCopy" "$BUN_INSTALL_CACHE_DIR"
    chmod -R +w "$BUN_INSTALL_CACHE_DIR"

    echo "Installing dependencies"
    if [[ -n "$bunWorkspaces" ]]; then
        local IFS=" "
        for ws in $bunWorkspaces; do
            bunInstallFlags+=("--filter=$ws")
        done
    fi

    runHook preBunInstall

    bun install \
        --offline \
        --ignore-scripts \
        "${bunInstallFlags[@]}" \
        --frozen-lockfile

    echo "Patching scripts"

    patchShebangs node_modules/{*,.*}

    if [ -n "${bunRoot-}" ]; then
      popd
    fi

    echo "Finished bunConfigHook"
}

postConfigureHooks+=(bunConfigHook)
