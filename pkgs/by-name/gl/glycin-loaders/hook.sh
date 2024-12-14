glycinLoadersPatchPhase() {
  local glycinPath

  # When cargoSetupHook is used, `cargoDepsCopy` would be set and preferred.
  # Otherwise, fallback to vendor/
  for path in ${cargoDepsCopy:-vendor}/glycin{,-*}; do
    local name="$(basename "$path")"

    # We need to check if the name is actually glycin, not something like glycin-utils
    # and that the path exists
    if [[ "${name%-*}" = "glycin" && -f "$path/src/sandbox.rs" ]]; then
      glycinPath="$path"
      break
    fi
  done

  if [[ -z "${glycinPath-}" ]]; then
    echo >&2 "error: Glycin is not found within Cargo dependencies."
    if [[ -z "${cargoDepsCopy-}" ]]; then
      echo >&2 "(\$cargoDepsCopy is unset; searching under vendor/)"
    else
      echo >&2 "(\$cargoDepsCopy is set; searching under $cargoDeps)"
    fi
    echo >&2 "Are you sure glycin-loaders.patchHook is still required?"
    exit 1
  fi

  substituteInPlace "$glycinPath/src/sandbox.rs" \
    --replace-fail '"/usr"' '"/nix/store"' \
    --replace-fail '"bwrap"' '"@bwrap@"'

  # Replace hash of file we patch in vendored glycin.
  jq \
    --arg hash "$(sha256sum "$glycinPath/src/sandbox.rs" | cut -d' ' -f 1)" \
    '.files."src/sandbox.rs" = $hash' \
    "$glycinPath/.cargo-checksum.json" \
    | sponge "$glycinPath/.cargo-checksum.json"

  gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "@glycinloaders@/share")
}

if [[ -z "${dontPatchGlycinLoaders-}" ]]; then
  prePatchHooks+=(glycinLoadersPatchPhase)
fi
