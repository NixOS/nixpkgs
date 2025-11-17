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

    local -r cacheLockfile="$offlineCache/yarn.lock"
    local -r srcLockfile="$PWD/yarn.lock"

    echo "Validating consistency between $srcLockfile and $cacheLockfile"

    if ! @diff@ "$srcLockfile" "$cacheLockfile"; then
      # If the diff failed, first double-check that the file exists, so we can
      # give a friendlier error msg.
      if ! [ -e "$srcLockfile" ]; then
        echo
        echo "ERROR: Missing yarn.lock from src. Expected to find it at: $srcLockfile"
        echo "Hint: You can copy a vendored yarn.lock file via postPatch."
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
      echo "ERROR: fetchYarnDeps hash is out of date"
      echo
      echo "The yarn.lock in src is not the same as the in $offlineCache."
      echo
      echo "To fix the issue:"
      echo '1. Use `lib.fakeHash` as the fetchYarnDeps hash value'
      echo "2. Build the derivation and wait for it to fail with a hash mismatch"
      echo "3. Copy the 'got: sha256-' value back into the fetchYarnDeps hash field"
      echo

      exit 1
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
