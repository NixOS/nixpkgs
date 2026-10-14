# shellcheck shell=bash

absolutizeIcdLibraryPath() {
  local jsonFile="$1"
  local libPath="$2"

  if [[ -z "$jsonFile" || -z "$libPath" ]]; then
    nixErrorLog "absolutizeIcdLibraryPath: expected <json-file> <library-prefix>"
    return 1
  fi

  if [[ ! -f "$jsonFile" ]]; then
    nixErrorLog "absolutizeIcdLibraryPath: JSON file not found: $jsonFile"
    return 1
  fi

  @jq@ --arg lib "$libPath" \
    '.ICD.library_path |= $lib + .' \
    "$jsonFile" | @sponge@ "$jsonFile"
}

fixupEglExternalPlatformIcdJsonHook() {
  case "${absolutizeEglExternalPlatformIcdJson-}" in
    1|true|yes) ;;
    *) return 0 ;;
  esac

  local jsonDir="$prefix/share/egl/egl_external_platform.d"

  if [[ ! -d "$jsonDir" ]]; then
    return 0
  fi

  local f
  for f in "$jsonDir"/*.json; do
    if [[ ! -e "$f" ]]; then
      continue
    fi
    absolutizeIcdLibraryPath "$f" "$prefix/lib/"
  done
}

fixupOutputHooks+=(fixupEglExternalPlatformIcdJsonHook)
