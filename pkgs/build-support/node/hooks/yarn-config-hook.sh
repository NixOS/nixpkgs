# shellcheck shell=bash

yarnConfigHook() {
    echo "Executing yarnConfigHook"

    echo "Configuring yarn"

    export HOME="$TMPDIR"
    export npm_config_nodedir="@nodeSrc@"

    if [ -z "${yarnDeps-}" ]; then
        echo
        echo "ERROR: no dependencies were specified"
        echo 'Hint: set `yarnDeps` if using these hooks individually. If this is happening with `buildYarnPackage`, please open an issue.'
        echo

        exit 1
    fi

    local -r cacheLockfile="$yarnDeps/yarn.lock"
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
      echo "ERROR: yarnDepsHash is out of date"
      echo
      echo "The yarn.lock in src is not the same as the in $yarnDeps."
      echo
      echo "To fix the issue:"
      echo '1. Use `lib.fakeHash` as the npmDepsHash value'
      echo "2. Build the derivation and wait for it to fail with a hash mismatch"
      echo "3. Copy the 'got: sha256-' value back into the yarnDepsHash field"
      echo

      exit 1
    fi

    @fixupYarnLock@ "$srcLockfile"

    @yarn@ config --offline set yarn-offline-mirror "$yarnDeps"

    echo "Installing dependencies"

    if ! @yarn@ install --offline --ignore-scripts $yarnInstallFlags "${yarnInstallFlagsArray[@]}"; then
        echo
        echo "ERROR: yarn failed to install dependencies"
        echo

        # TODO: what diags?

        exit 1
    fi

    patchShebangs node_modules

    npm rebuild "${npmRebuildFlags[@]}" "${npmFlags[@]}"

    patchShebangs node_modules

    echo "Finished yarnConfigHook"
}

postPatchHooks+=(yarnConfigHook)
