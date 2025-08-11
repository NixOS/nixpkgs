# shellcheck shell=bash

denoConfigHook() {
  echo "Executing denoConfigHook"

  if [ -z "${denoDeps-}" ]; then
    echo
    echo "ERROR: no dependencies were specified"
    echo 'Hint: set `denoDeps` if using these hooks individually. If this is happening with `buildDenoPackage`, please open an issue.'
    echo

    exit 1
  fi

  local -r cacheLockfile="$denoDeps/deno.lock"
  local -r srcLockfile="$PWD/deno.lock"

  echo "Validating consistency between $srcLockfile and $cacheLockfile"

  if ! diff "$srcLockfile" "$cacheLockfile"; then
    # If the diff failed, first double-check that the file exists, so we can
    # give a friendlier error msg.
    if ! [ -e "$srcLockfile" ]; then
      echo
      echo "ERROR: Missing deno.lock from src. Expected to find it at: $srcLockfile"
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
    echo "ERROR: denoDepsHash is out of date"
    echo
    echo "The deno.lock in src is not the same as the in $denoDeps."
    echo
    echo "To fix the issue:"
    echo '1. Use `lib.fakeHash` as the denoDepsHash value'
    echo "2. Build the derivation and wait for it to fail with a hash mismatch"
    echo "3. Copy the 'got: sha256-' value back into the denoDepsHash field"
    echo

    exit 1
  fi

  local -r cacheTsTypes="$denoDeps/ts-types.json"
  local -r srcTsTypes="$tsTypesJsonPath"

  echo "Validating consistency between $srcTsTypes and $cacheTsTypes"
  if ! diff "$srcTsTypes" "$cacheTsTypes"; then
    echo
    echo "ERROR: denoDepsHash is out of date"
    echo
    echo "The @ts-types in src are not the same as the in $denoDeps."
    echo
    echo "To fix the issue:"
    echo '1. Use `lib.fakeHash` as the denoDepsHash value'
    echo "2. Build the derivation and wait for it to fail with a hash mismatch"
    echo "3. Copy the 'got: sha256-' value back into the denoDepsHash field"
    echo

    exit 1
  fi


  # NOTE: we need to use vendor in the build too, since we used it for the deps
  useVendor() {
    jq '.vendor = true' deno.json >temp.json &&
      rm -f deno.json &&
      mv temp.json deno.json
  }
  echo "Adding vendor to deno.json"
  useVendor

  echo "Installing dependencies"

  installDeps() {
    mkdir -p $DENO_DIR
    mkdir -p $vendorDir
    file-transformer-npm --in-path "$denoDeps/$npmJsonName" --cache-path $DENO_DIR
    file-transformer-vendor --cache-path $(pwd)/$DENO_DIR --vendor-path $(pwd)/$vendorDir --url-file-map "$denoDeps/$vendorJsonName"
  }
  installDeps

  if ! deno install $denoInstallFlags_ $denoFlags_; then
    echo
    echo "ERROR: deno failed to install dependencies"
    echo

    exit 1
  fi

  installDenort() {
    version="$(deno --version | head -1 | awk '{print $2}')"
    zipfile=denort-"$hostPlatform_".zip
    dir="$DENO_DIR"/dl/release/v"$version"
    mkdir -p "$dir"
    cp "@denortBinary@" ./denort
    zip "$dir"/"$zipfile" ./denort
    rm ./denort
  }
  if [ -n "${binaryEntrypointPath-}" ]; then
    echo "Installing denort for binary build"
    installDenort
  fi

  patchShebangs "$DENO_DIR"
  patchShebangs node_modules
  patchShebangs "$vendorDir"

  echo "Finished denoConfigHook"
}

postPatchHooks+=(denoConfigHook)
