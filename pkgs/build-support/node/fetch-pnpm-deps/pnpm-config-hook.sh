# shellcheck shell=bash

pnpmConfigHook() {
    echo "Executing pnpmConfigHook"

    if [ -z "${pnpmDeps-}" ]; then
        echo "Error: 'npmDeps' should be set when using npmConfigHook."
        exit 1
    fi

    echo "Configuring pnpm store"

    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    cp -Tr "$pnpmDeps" "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    pnpm config set store-dir "$STORE_PATH"

    echo "Installing dependencies"

    if ! pnpm install --offline --frozen-lockfile --ignore-script; then
        echo
        echo "ERROR: pnpm failed to install dependencies"
        echo

        exit 1
    fi

    patchShebangs node_modules/{*,.*}

    echo "Finished pnpmConfigHook"
}

postConfigureHooks+=(pnpmConfigHook)
