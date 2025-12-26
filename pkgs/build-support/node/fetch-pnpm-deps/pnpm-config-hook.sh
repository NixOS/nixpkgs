# shellcheck shell=bash

pnpmConfigHook() {
    echo "Executing pnpmConfigHook"

    if [ -n "${pnpmRoot-}" ]; then
      pushd "$pnpmRoot"
    fi

    if [ -z "${pnpmDeps-}" ]; then
      echo "Error: 'pnpmDeps' must be set when using pnpmConfigHook."
      exit 1
    fi

    if ! command -v "pnpm" &> /dev/null; then
      echo "Error: 'pnpm' binary not found in PATH. Consider adding 'pkgs.pnpm' to 'nativeBuildInputs'." >&2
      exit 1
    fi

    echo "Found 'pnpm' with version '$(pnpm --version)'"

    fetcherVersion=$(cat "${pnpmDeps}/.fetcher-version" || echo 1)

    echo "Using fetcherVersion: $fetcherVersion"

    echo "Configuring pnpm store"

    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)
    export npm_config_arch="@npmArch@"
    export npm_config_platform="@npmPlatform@"

    if [[ $fetcherVersion -ge 3 ]]; then
      tar --zstd -xf "$pnpmDeps/pnpm-store.tar.zst" -C "$STORE_PATH"
    else
      cp -Tr "$pnpmDeps" "$STORE_PATH"
    fi

    chmod -R +w "$STORE_PATH"


    # If the packageManager field in package.json is set to a different pnpm version than what is in nixpkgs,
    # any pnpm command would fail in that directory, the following disables this
    pushd ..
    pnpm config set manage-package-manager-versions false
    popd

    pnpm config set store-dir "$STORE_PATH"

    # Prevent hard linking on file systems without clone support.
    # See: https://pnpm.io/settings#packageimportmethod
    pnpm config set package-import-method clone-or-copy

    if [[ -n "$pnpmWorkspace" ]]; then
        echo "'pnpmWorkspace' is deprecated, please migrate to 'pnpmWorkspaces'."
        exit 2
    fi

    echo "Installing dependencies"
    if [[ -n "$pnpmWorkspaces" ]]; then
        local IFS=" "
        for ws in $pnpmWorkspaces; do
            pnpmInstallFlags+=("--filter=$ws")
        done
    fi

    runHook prePnpmInstall

    if ! pnpm install \
        --offline \
        --ignore-scripts \
        "${pnpmInstallFlags[@]}" \
        --frozen-lockfile
    then
        echo
        echo "ERROR: pnpm failed to install dependencies"
        echo
        echo "If you see ERR_PNPM_NO_OFFLINE_TARBALL above this, follow these to fix the issue:"
        echo '1. Set pnpmDeps.hash to "" (empty string)'
        echo "2. Build the derivation and wait for it to fail with a hash mismatch"
        echo "3. Copy the 'got: sha256-' value back into the pnpmDeps.hash field"
        echo

        exit 1
    fi


    echo "Patching scripts"

    patchShebangs node_modules/{*,.*}

    if [ -n "${pnpmRoot-}" ]; then
      popd
    fi

    echo "Finished pnpmConfigHook"
}

postConfigureHooks+=(pnpmConfigHook)
