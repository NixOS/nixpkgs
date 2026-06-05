# shellcheck shell=bash

versionAtLeast () {
    local cur_version=$1 min_version=$2
    printf "%s\0%s" "$min_version" "$cur_version" | sort -zVC
}

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

    pushd "$HOME"
    pnpmVersion=$(pnpm --version)

    if versionAtLeast "$pnpmVersion" "11"; then
      # pnpm 11 uses a different mechanism to manage package manager versions
      export pnpm_config_pm_on_fail=ignore

      # Disable lockfile verification against supply-chain policies. This is
      # already done in fetchPnpmDeps, so if these checks failed there, we
      # wouldn't be here in the first place
      export pnpm_config_trust_lockfile=true
    else
      pnpm config set manage-package-manager-versions false
    fi
    popd

    echo "Found 'pnpm' with version '$pnpmVersion'"

    fetcherVersion=$(cat "${pnpmDeps}/.fetcher-version")

    echo "Using fetcherVersion: $fetcherVersion"

    echo "Configuring pnpm store"

    export STORE_PATH=$(mktemp -d)
    export npm_config_arch="@npmArch@"
    export pnpm_config_arch="@npmArch@"
    export npm_config_platform="@npmPlatform@"
    export pnpm_config_platform="@npmPlatform@"

    tar --zstd -xf "$pnpmDeps/pnpm-store.tar.zst" -C "$STORE_PATH"

    chmod -R +w "$STORE_PATH"

    # Reconstruct the SQLite database from the SQL dump if needed.
    # The fetch phase stores a text SQL dump instead of the binary db
    # to ensure reproducibility across platforms.
    if [ -f "$STORE_PATH/v11/index.db.sql" ]; then
      sqlite3 "$STORE_PATH/v11/index.db" < "$STORE_PATH/v11/index.db.sql"
      rm "$STORE_PATH/v11/index.db.sql"
    fi

    pnpm config set store-dir "$STORE_PATH"

    # Prevent hard linking on file systems without clone support.
    # See: https://pnpm.io/settings#packageimportmethod
    pnpm config set package-import-method clone-or-copy

    echo "Installing dependencies"

    local -a pnpmWorkspacesArray
    concatTo pnpmWorkspacesArray pnpmWorkspaces

    for ws in "${pnpmWorkspacesArray[@]}"; do
        pnpmInstallFlags+=("--filter=$ws")
    done

    runHook prePnpmInstall

    echo "Final pnpm config:"
    pnpm config list
    echo

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
        echo "If you see ERR_PNPM_LOCKFILE_CONFIG_MISMATCH above this, try changing the pnpm version"
        echo "Found 'pnpm' with version '$pnpmVersion'"
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
