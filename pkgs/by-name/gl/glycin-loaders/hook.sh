glycinLoadersPatchHook() {
  echo "executing glycinLoadersPatchHook"

  local glycinPath

  if [[ -z ${glycinCargoDepsPath:-} ]]; then
    # When cargoSetupHook is used, `cargoDepsCopy` would be set and preferred.
    # Otherwise, fallback to vendor/
    local cargoDepsPath=${cargoDepsCopy:-vendor}
  fi

  while read -r path; do
    # Ensure the paths we're patching exist (and that this crate probably isn't something like glycin-utils)
    if [[ -f $path/src/sandbox.rs ]]; then
      glycinPath="$path"
      break
    fi
  done < <(find "$cargoDepsPath" -type d -name 'glycin*')

  if [[ -z ${glycinPath:-} ]]; then
    echo >&2 "error: glycin was not found within the cargo dependencies at '$cargoDepsPath'."
    echo >&2 "are you sure glycin-loaders is still required?"
    exit 1
  fi
  echo "patching glycin crate at '$glycinPath'"

  substituteInPlace "$glycinPath/src/sandbox.rs" \
    --replace-fail '"/usr"' '"/nix/store"' \
    --replace-fail '"bwrap"' '"@bwrap@"'

  # Replace hash of file we patch in vendored glycin.
  jq \
    --arg hash "$(sha256sum "$glycinPath/src/sandbox.rs" | cut -d' ' -f 1)" \
    '.files."src/sandbox.rs" = $hash' \
    "$glycinPath/.cargo-checksum.json" |
    sponge "$glycinPath/.cargo-checksum.json"
}

glycinLoadersWrapperArgsHook() {
  echo "executing glycinLoadersWrapperArgsHook"
  gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "@out@/share")
}

if [[ -z ${dontPatchGlycinLoaders:-} ]]; then
  prePatchHooks+=(glycinLoadersPatchHook)
fi

if [[ -z ${dontWrapGlycinLoaders:-} ]]; then
  preFixupPhases+=(glycinLoadersWrapperArgsHook)
fi
