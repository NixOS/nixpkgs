bunConfigHook() {
    echo "Executing bunConfigHook"

    # Use a constant HOME directory
    export HOME=$(mktemp -d)
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
      echo '1. Use `lib.fakeHash` as the fetchBunDeps hash value'
      echo "2. Build the derivation and wait for it to fail with a hash mismatch"
      echo "3. Copy the 'got: sha256-' value back into the fetchBunDeps hash field"
      echo

      exit 1
    fi

    # Configure Bun to use the offline cache
    bun config set cache "$offlineCache"
    fixup-bun-lock bun.lock
    bun install \
        --frozen-lockfile \
        --no-progress \
        --no-save \
        --offline

    # TODO: Check if this is really needed
    patchShebangs node_modules

    echo "finished bunConfigHook"
}

if [[ -z "${dontBunInstallDeps-}" ]]; then
    postConfigureHooks+=(bunConfigHook)
fi
