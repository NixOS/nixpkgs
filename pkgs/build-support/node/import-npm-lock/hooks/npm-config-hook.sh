# shellcheck shell=bash

npmConfigHook() {
    echo "Executing npmConfigHook"

    if [ -n "${npmRoot-}" ]; then
      pushd "$npmRoot"
    fi

    if [ -z "${npmDeps-}" ]; then
        echo "Error: 'npmDeps' should be set when using npmConfigHook."
        exit 1
    fi

    echo "Configuring npm"

    export HOME="$TMPDIR"
    export npm_config_nodedir="@nodeSrc@"
    export npm_config_node_gyp="@nodeGyp@"
    npm config set offline true
    npm config set progress false
    npm config set fund false

    echo "Installing patched package.json/package-lock.json"

    # Save original package.json/package-lock.json for closure size reductions.
    # The patched one contains store paths we don't want at runtime.
    mv package.json .package.json.orig
    if test -f package-lock.json; then # Not all packages have package-lock.json.
        mv package-lock.json .package-lock.json.orig
    fi
    cp --no-preserve=mode "${npmDeps}/package.json" package.json
    cp --no-preserve=mode "${npmDeps}/package-lock.json" package-lock.json

    echo "Installing dependencies"

    if ! npm install --ignore-scripts $npmInstallFlags "${npmInstallFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"; then
        echo
        echo "ERROR: npm failed to install dependencies"
        echo
        echo "Here are a few things you can try, depending on the error:"
        echo '1. Set `npmFlags = [ "--legacy-peer-deps" ]`'
        echo

        exit 1
    fi

    patchShebangs node_modules

    npm rebuild $npmRebuildFlags "${npmRebuildFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"

    patchShebangs node_modules

    # Canonicalize symlinks from relative paths to the Nix store.
    node @canonicalizeSymlinksScript@ @storePrefix@

    # Revert to pre-patched package.json/package-lock.json for closure size reductions
    mv .package.json.orig package.json
    if test -f ".package-lock.json.orig"; then
        mv .package-lock.json.orig package-lock.json
    fi

    if [ -n "${npmRoot-}" ]; then
      popd
    fi

    echo "Finished npmConfigHook"
}

postConfigureHooks+=(npmConfigHook)
