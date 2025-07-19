#!/usr/bin/env bash

bunConfigHook() {
    echo "Executing bunConfigHook"

    # HOME directory is provided by writableTmpDirAsHomeHook
    # The hook ensures HOME points to a writable location
    if [[ -n "$bunOfflineCache" ]]; then
        offlineCache="$bunOfflineCache"
    fi
    if [[ -z "$offlineCache" ]]; then
        echo bunConfigHook: No bunOfflineCache or offlineCache were defined\! >&2
        exit 2
    fi

    local -r cacheLockfile="$offlineCache/bun.lock"
    local -r srcLockfile="$PWD/bun.lock"

    echo "Validating consistency between $srcLockfile and $cacheLockfile"

    if ! @diff@ "$srcLockfile" "$cacheLockfile"; then
        # If the diff failed, first double-check that the file exists, so we can
        # give a friendlier error msg.
        if ! [ -e "$srcLockfile" ]; then
            echo
            echo "ERROR: Missing bun.lock from src. Expected to find it at: $srcLockfile"
            echo "Hint: You can copy a vendored bun.lock file via postPatch."
            echo

            exit 1
        fi

        if ! [ -e "$cacheLockfile" ]; then
            echo
            echo "ERROR: Missing lockfile from cache. Expected to find it at: $cacheLockfile"
            echo

            exit 1
        fi

        echo
        echo "ERROR: fetchBunDeps hash is out of date"
        echo
        echo "The bun.lock in src is not the same as the in $offlineCache."
        echo
        echo "To fix the issue:"
        echo "1. Use \`lib.fakeHash\` as the fetchBunDeps hash value"
        echo "2. Build the derivation and wait for it to fail with a hash mismatch"
        echo "3. Copy the 'got: sha256-' value back into the fetchBunDeps hash field"
        echo

        exit 1
    fi

    # Configure Bun to use the offline cache
    # Bun doesn't have a config command yet, so we use environment variables
    # See: https://bun.sh/docs/runtime/env
    export BUN_INSTALL_CACHE_DIR="$offlineCache"

    # Create and use a temporary directory inside HOME for Bun operations
    local bun_tmp_dir="$HOME/.bun-tmp"
    mkdir -p "$bun_tmp_dir"
    export BUN_TMPDIR="$bun_tmp_dir"

    # Create additional directories Bun might need
    mkdir -p "$HOME/.bun/install/cache"

    # Configure additional Bun directories
    export BUN_CONFIG_DIR="$HOME/.bun"

    echo "Using Bun temp directory: $bun_tmp_dir"

    # Fix up the lockfile
    fixup-bun-lock bun.lock

    # Create a specific cache directory
    local bun_cache_dir="$HOME/.bun-cache"
    mkdir -p "$bun_cache_dir"

    # Create test files in each directory to verify they're writable
    echo "test" > "$bun_tmp_dir/test-tmp.txt"
    echo "test" > "$bun_cache_dir/test-cache.txt"
    echo "test" > "$HOME/.bun/test-bun.txt"

    echo "DEBUG: Created test files to verify directories are writable"

    # Create a bunfig.toml file to explicitly configure Bun
    cat > "$PWD/bunfig.toml" << EOF
[install]
# Set cache directory to a writable location
cache = "$bun_cache_dir"
# Configure global directories
globalDir = "$HOME/.bun/global"
globalBinDir = "$HOME/.bun/bin"
# Don't update lockfile
frozenLockfile = true
# Don't use default cache
dry = false

# Make sure Bun uses our temp directory
tmpdir = "$bun_tmp_dir"

[install.lockfile]
# Don't save lockfile changes
save = false
EOF

    echo "Created bunfig.toml:"
    cat "$PWD/bunfig.toml"

    # Debug: Check Bun's configuration and directories
    echo "DEBUG: Bun version: $(bun --version)"
    echo "DEBUG: Bun's cache directory: $(bun pm cache)"
    echo "DEBUG: Checking if bun recognizes our config:"
    bun --config="$PWD/bunfig.toml" pm cache || echo "Failed to use config"

    echo "DEBUG: Current directory contents:"
    ls -la "$PWD"

    echo "DEBUG: BUN_TMPDIR directory:"
    ls -la "$bun_tmp_dir"

    # Install dependencies from the offline cache
    # Using the bunfig.toml for configuration
    bun install \
        --frozen-lockfile \
        --no-progress \
        --no-save \
        --offline \
        --no-cache \
        --cache-dir="$bun_cache_dir" \
        --backend=copyfile \
        --config="$PWD/bunfig.toml" \
        --verbose

    # TODO: Check if this is really needed
    patchShebangs node_modules

    echo "finished bunConfigHook"
}

if [[ -z "${dontBunInstallDeps-}" ]]; then
    postConfigureHooks+=(bunConfigHook)
fi
