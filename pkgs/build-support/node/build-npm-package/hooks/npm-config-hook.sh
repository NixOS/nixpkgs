# shellcheck shell=bash

npmConfigHook() {
    echo "Executing npmConfigHook"

    # Use npm patches in the nodejs package
    export NIX_NODEJS_BUILDNPMPACKAGE=1
    export prefetchNpmDeps="@prefetchNpmDeps@"

    if [ -n "${npmRoot-}" ]; then
      pushd "$npmRoot"
    fi

    echo "Configuring npm"

    export HOME="$TMPDIR"
    export npm_config_nodedir="@nodeSrc@"
    export npm_config_node_gyp="@nodeGyp@"

    if [ -z "${npmDeps-}" ]; then
        echo
        echo "ERROR: no dependencies were specified"
        echo 'Hint: set `npmDeps` if using these hooks individually. If this is happening with `buildNpmPackage`, please open an issue.'
        echo

        exit 1
    fi

    local -r cacheLockfile="$npmDeps/package-lock.json"
    local -r srcLockfile="$PWD/package-lock.json"

    echo "Validating consistency between $srcLockfile and $cacheLockfile"

    if ! @diff@ "$srcLockfile" "$cacheLockfile"; then
      # If the diff failed, first double-check that the file exists, so we can
      # give a friendlier error msg.
      if ! [ -e "$srcLockfile" ]; then
        echo
        echo "ERROR: Missing package-lock.json from src. Expected to find it at: $srcLockfile"
        echo "Hint: You can copy a vendored package-lock.json file via postPatch."
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
      echo "ERROR: npmDepsHash is out of date"
      echo
      echo "The package-lock.json in src is not the same as the in $npmDeps."
      echo
      echo "To fix the issue:"
      echo '1. Use `lib.fakeHash` as the npmDepsHash value'
      echo "2. Build the derivation and wait for it to fail with a hash mismatch"
      echo "3. Copy the 'got: sha256-' value back into the npmDepsHash field"
      echo

      exit 1
    fi

    export CACHE_MAP_PATH="$TMP/MEOW"
    @prefetchNpmDeps@ --map-cache

    @prefetchNpmDeps@ --fixup-lockfile "$srcLockfile"

    local cachePath

    if [ -z "${makeCacheWritable-}" ]; then
        cachePath="$npmDeps"
    else
        echo "Making cache writable"
        cp -r "$npmDeps" "$TMPDIR/cache"
        chmod -R 700 "$TMPDIR/cache"
        cachePath="$TMPDIR/cache"
    fi

    npm config set cache "$cachePath"
    npm config set offline true
    npm config set progress false

    echo "Installing dependencies"

    if ! npm ci --ignore-scripts $npmInstallFlags "${npmInstallFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"; then
        echo
        echo "ERROR: npm failed to install dependencies"
        echo
        echo "Here are a few things you can try, depending on the error:"
        echo '1. Set `makeCacheWritable = true`'
        echo "  Note that this won't help if npm is complaining about not being able to write to the logs directory -- look above that for the actual error."
        echo '2. Set `npmFlags = [ "--legacy-peer-deps" ]`'
        echo

        exit 1
    fi

    patchShebangs node_modules

    npm rebuild $npmRebuildFlags "${npmRebuildFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"

    patchShebangs node_modules

    rm "$CACHE_MAP_PATH"
    unset CACHE_MAP_PATH

    if [ -n "${npmRoot-}" ]; then
      popd
    fi

    echo "Finished npmConfigHook"
}

postPatchHooks+=(npmConfigHook)
