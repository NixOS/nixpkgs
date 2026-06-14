# shellcheck shell=bash

versionAtLeast () {
    local cur_version=$1 min_version=$2
    printf "%s\0%s" "$min_version" "$cur_version" | sort -zVC
}

pnpmCacheConfigHook() {
    echo "Executing pnpmCacheConfigHook"

    if [ -z "${NIX_ATTRS_SH_FILE-}" ]; then
      echo "Error: '__structuredAttrs = true' must be set when using pnpmCacheConfigHook" >&2
      exit 1
    fi

    if [ -n "${pnpmRoot-}" ]; then
      pushd "$pnpmRoot"
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

    export npm_config_arch="@npmArch@"
    export pnpm_config_arch="@npmArch@"
    export npm_config_platform="@npmPlatform@"
    export pnpm_config_platform="@npmPlatform@"

    # Prevent hard linking on file systems without clone support.
    # See: https://pnpm.io/settings#packageimportmethod
    pnpm config set package-import-method clone-or-copy

    # mitm-cache doesn't set a full URL and pnpm defaults to https. Force it to treat it as a plain text proxy
    pnpm config set https-proxy "http://$https_proxy"

    runHook prePnpmInstall

    echo "Final pnpm config:"
    pnpm config list
    echo

    if ! pnpm install \
        --reporter append-only \
        --ignore-scripts \
        "${pnpmInstallFlags[@]}" \
        --frozen-lockfile
    then
        echo
        echo "ERROR: pnpm failed to install dependencies"
        echo

        exit 1
    fi

    echo "Patching scripts"

    patchShebangs node_modules/{*,.*}

    if [ -n "${pnpmRoot-}" ]; then
      popd
    fi

    echo "Finished pnpmCacheConfigHook"
}

postConfigureHooks+=(pnpmCacheConfigHook)
