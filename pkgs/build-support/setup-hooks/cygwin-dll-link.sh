addLinkDLLPaths() {
    addToSearchPath "LINK_DLL_FOLDERS" "$1/lib"
    addToSearchPath "LINK_DLL_FOLDERS" "$1/bin"
}

addEnvHooks "$targetOffset" addLinkDLLPaths

addOutputDLLPaths() {
  for output in $(getAllOutputNames); do
    addToSearchPath "LINK_DLL_FOLDERS" "${!output}/lib"
    addToSearchPath "LINK_DLL_FOLDERS" "${!output}/bin"
  done
}

postInstallHooks+=(addOutputDLLPaths)

_dllDeps() {
    "$OBJDUMP" -p "$1" \
        | sed -n 's/.*DLL Name: \(.*\)/\1/p' \
        | sort -u
}

_linkDeps() {
    local target="$1" dir="$2" check="$3"
    echo 'target:' "$target"
    local dll
    _dllDeps "$target" | while read dll; do
        echo '  dll:' "$dll"
        if [[ -e "$dir/$dll" ]]; then continue; fi
        # Locate the DLL - it should be an *executable* file on $LINK_DLL_FOLDERS.
        local dllPath="$(PATH="$(dirname "$target"):$LINK_DLL_FOLDERS" type -P "$dll")"
        if [[ -z "$dllPath" ]]; then
          if [[ -z "$check" || -n "${allowedImpureDLLsMap[$dll]}" ]]; then
             continue
          fi
          echo unable to find $dll in $LINK_DLL_FOLDERS >&2
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
    for target in {bin,libexec}/**/*.{exe,dll}; do
      [[ ! -f "$target" || ! -x "$target" ]] ||
        _linkDeps "$target" "$(dirname "$target")" "1"
    done
  )
}

fixupOutputHooks+=(linkDLLs)
