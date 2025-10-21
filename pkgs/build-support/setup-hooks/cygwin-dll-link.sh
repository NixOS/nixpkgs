# shellcheck shell=bash

_moveDLLsToLib() {
  if [[ "${dontMoveDLLsToLib-}" ]]; then return; fi
  # shellcheck disable=SC2154
  moveToOutput "bin/*.dll" "${!outputLib}"
}

preFixupHooks+=(_moveDLLsToLib)

_addOutputDLLPaths() {
  for output in $(getAllOutputNames); do
    addToSearchPath "HOST_PATH" "${!output}/bin"
  done
}

preFixupHooks+=(_addOutputDLLPaths)

_dllDeps() {
  if [[ -z "${OBJDUMP:-}" ]]; then
    echo "_dllDeps: '\$OBJDUMP' variable is empty, skipping." 1>&2
    return
  fi
  "$OBJDUMP" -p "$1" \
    | sed -n 's/.*DLL Name: \(.*\)/\1/p' \
    | sort -u
}

declare -Ag _linkDeps_visited

_linkDeps() {
  local target="$1" dir="$2"
  if [[ -v _linkDeps_visited[$target] ]]; then
    echo "_linkDeps: $target was already linked." 1>&2
    return
  fi
  if [[ ! -f "$target" || ! -x "$target" ]]; then
    echo "_linkDeps: $target is not an executable file, skipping." 1>&2
    return
  fi

  local realTarget output inOutput
  realTarget="$(readlink -f "$target")"
  for output in $outputs ; do
    if [[ $realTarget == "${!output}"* ]]; then
      echo "_linkDeps: $target ($realTarget) is in $output (${!output})." 1>&2
      inOutput=1
      break
    fi
  done

  echo 'target:' "$target"
  local dll
  while read -r dll; do
    echo '  dll:' "$dll"
    if [[ -v _linkDeps_visited[$dir/$dll] ]]; then
      echo "_linkDeps: $dll was already linked into $dir." 1>&2
      continue
    fi
    if [[ -L "$dir/$dll" || -e "$dir/$dll" ]]; then
      echo '    already exists'
      _linkDeps "$dir/$dll" "$dir"
    else
      local dllPath
      if [[ $dll = cygwin1.dll ]]; then
        dllPath=/bin/cygwin1.dll
      else
        # Locate the DLL - it should be an *executable* file on $HOST_PATH.
        # This intentionally doesn't use $dir because we want to prefer dependencies
        # that are already linked next to the target.
        if ! dllPath="$(PATH="$(dirname "$target"):$HOST_PATH" type -P "$dll")"; then
          if [[ -z "$inOutput" || -n "${allowedImpureDLLsMap[$dll]}" ]]; then
            continue
          fi
          echo unable to find "$dll" in "$HOST_PATH" >&2
          exit 1
        fi
      fi
      echo '    linking to:' "$dllPath"
      CYGWIN+=\ winsymlinks:nativestrict ln -sr "$dllPath" "$dir"
      _linkDeps "$dllPath" "$dir"
    fi
    _linkDeps_visited[$dir/$dll]=1
  done < <(_dllDeps "$target")
}

# linkDLLsDir can be used to override the destination path for links.  This is
# useful if you're trying to link dependencies of libraries into the directory
# containing an executable.
#
# Arguments can be a file or directory path. Directories are searched
# recursively.
linkDLLs() {
  # shellcheck disable=SC2154
  (
    set -e
    shopt -s globstar nullglob

    local -a allowedImpureDLLsArray
    concatTo allowedImpureDLLsArray allowedImpureDLLs

    local -A allowedImpureDLLsMap;

    for dll in "${allowedImpureDLLsArray[@]}"; do
      allowedImpureDLLsMap[$dll]=1
    done

    local target file
    for target in "$@"; do
      # Iterate over any DLL that we depend on.
      if [[ -f "$target" ]]; then
        _linkDeps "$target" "${linkDLLsDir-$(dirname "$target")}"
      elif [[ -d "$target" ]]; then
        for file in "${target%/}"/**/*.{exe,dll}; do
          _linkDeps "$file" "${linkDLLsDir-$(dirname "$file")}"
        done
      else
        echo "linkDLLs: $target is not a file or directory, skipping." 1>&2
      fi
    done
  )
}

_linkDLLs() {
  # shellcheck disable=SC2154
  if [[ ! -d $prefix || ${dontLinkDLLs-} ]]; then return; fi
  linkDLLs "$prefix"/{bin,lib,libexec}/
}

fixupOutputHooks+=(_linkDLLs)
