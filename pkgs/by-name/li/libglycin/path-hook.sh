find_glycin_loader_paths() {
  if [ -d "$1/share/glycin-loaders" ]; then
    addToSearchPath NIX_GLYCIN_LOADER_PATHS $1/share
  fi
}

addEnvHooks "$hostOffset" find_glycin_loader_paths

glycinLoadersWrapperArgsHook() {
  echo "executing glycinLoadersWrapperArgsHook"
  if [[ -n "$NIX_GLYCIN_LOADER_PATHS" ]]; then
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$NIX_GLYCIN_LOADER_PATHS")
  fi
}

if [[ -z ${dontWrapGlycinLoaders:-} ]]; then
  preFixupPhases+=(glycinLoadersWrapperArgsHook)
fi
