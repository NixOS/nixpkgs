# shellcheck shell=bash

_moveDLLsToLib() {
  if [[ "${dontMoveDLLsToLib-}" ]]; then return; fi
  # shellcheck disable=SC2154
  moveToOutput "bin/*.dll" "${!outputLib}"
}

preFixupHooks+=(_moveDLLsToLib)

addOutputDLLPaths() {
  for output in $(getAllOutputNames); do
    addToSearchPath "HOST_PATH" "${!output}/bin"
  done
}

preFixupHooks+=(addOutputDLLPaths)

_dllDeps() {
  [ -z "${OBJDUMP:-}" ] && echo "_dllDeps: '\$OBJDUMP' variable is empty, skipping." 1>&2 && return
  "$OBJDUMP" -p "$1" \
    | sed -n 's/.*DLL Name: \(.*\)/\1/p' \
    | sort -u
}

_linkDeps() {
  local target="$1" dir="$2" check="$3"
  [[ ! -x "$target" ]] && echo "_linkDeps: $target is not executable, skipping." 1>&2 && return
  echo 'target:' "$target"
  local dll
  _dllDeps "$target" | while read -r dll; do
    echo '  dll:' "$dll"
    if [[ -L "$dir/$dll" || -e "$dir/$dll" ]]; then continue; fi
    if [[ $dll = cygwin1.dll ]]; then
      CYGWIN+=\ winsymlinks:nativestrict ln -sr /bin/cygwin1.dll "$dir"
      continue
    fi
    # Locate the DLL - it should be an *executable* file on $HOST_PATH.
    local dllPath
    if ! dllPath="$(PATH="$(dirname "$target"):$HOST_PATH" type -P "$dll")"; then
      if [[ -z "$check" || -n "${allowedImpureDLLsMap[$dll]}" ]]; then
        continue
      fi
      echo unable to find "$dll" in "$HOST_PATH" >&2
      exit 1
    fi
    echo '    linking to:' "$dllPath"
    CYGWIN+=\ winsymlinks:nativestrict ln -sr "$dllPath" "$dir"
    # That DLL might have its own (transitive) dependencies,
    # so add also all DLLs from its directory to be sure.
    _linkDeps "$dllPath" "$dir" ""
  done
}

linkDLLs() {
  # shellcheck disable=SC2154
  if [ ! -d "$prefix" ]; then return; fi
  (
    set -e
    shopt -s globstar nullglob

    local -a allowedImpureDLLsArray
    concatTo allowedImpureDLLsArray allowedImpureDLLs

    local -A allowedImpureDLLsMap;

    for dll in "${allowedImpureDLLsArray[@]}"; do
      allowedImpureDLLsMap[$dll]=1
    done

    cd "$prefix"

    # Iterate over any DLL that we depend on.
    local target
    for target in {bin,lib,libexec}/**/*.{exe,dll}; do
      [[ ! -f "$target" || ! -x "$target" ]] ||
        _linkDeps "$target" "$(dirname "$target")" "1"
    done
  )
}

fixupOutputHooks+=(linkDLLs)
