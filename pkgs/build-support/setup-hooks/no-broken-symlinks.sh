# shellcheck shell=bash

# Guard against double inclusion.
if (("${noBrokenSymlinksHookInstalled:-0}" > 0)); then
  nixInfoLog "skipping because the hook has been propagated more than once"
  return 0
fi
declare -ig noBrokenSymlinksHookInstalled=1

# symlinks are often created in postFixup
# don't use fixupOutputHooks, it is before postFixup
postFixupHooks+=(noBrokenSymlinksInAllOutputs)

# A symlink is "dangling" if it points to a non-existent target.
# A symlink is "reflexive" if it points to itself.
# A symlink is "unreadable" if the readlink command fails, e.g. because of permission errors.
# A symlink is considered "broken" if it is either dangling, reflexive or unreadable.
noBrokenSymlinks() {
  local -r output="${1:?}"
  local path
  local pathParent
  local symlinkTarget
  local -i numDanglingSymlinks=0
  local -i numReflexiveSymlinks=0
  local -i numUnreadableSymlinks=0

  # NOTE(@connorbaker): This hook doesn't check for cycles in symlinks.

  if [[ ! -e $output ]]; then
    nixWarnLog "skipping non-existent output $output"
    return 0
  fi
  nixInfoLog "running on $output"

  # NOTE: path is absolute because we're running `find` against an absolute path (`output`).
  while IFS= read -r -d $'\0' path; do
    pathParent="$(dirname "$path")"
    if ! symlinkTarget="$(readlink "$path")"; then
      nixErrorLog "the symlink $path is unreadable"
      numUnreadableSymlinks+=1
      continue
    fi

    # Canonicalize symlinkTarget to an absolute path.
    if [[ $symlinkTarget == /* ]]; then
      nixInfoLog "symlink $path points to absolute target $symlinkTarget"
    else
      nixInfoLog "symlink $path points to relative target $symlinkTarget"
      # Use --no-symlinks to avoid dereferencing again and --canonicalize-missing to avoid existence
      # checks at this step (which can lead to infinite recursion).
      symlinkTarget="$(realpath --no-symlinks --canonicalize-missing "$pathParent/$symlinkTarget")"
    fi

    # use $TMPDIR like audit-tmpdir.sh
    if [[ $symlinkTarget = "$TMPDIR"/* ]]; then
      nixErrorLog "the symlink $path points to $TMPDIR directory: $symlinkTarget"
      numDanglingSymlinks+=1
      continue
    fi
    if [[ $symlinkTarget != "$NIX_STORE"/* ]]; then
      nixInfoLog "symlink $path points outside the Nix store; ignoring"
      continue
    fi

    if [[ $path == "$symlinkTarget" ]]; then
      nixErrorLog "the symlink $path is reflexive"
      numReflexiveSymlinks+=1
    elif [[ ! -e $symlinkTarget ]]; then
      nixErrorLog "the symlink $path points to a missing target: $symlinkTarget"
      numDanglingSymlinks+=1
    else
      nixDebugLog "the symlink $path is irreflexive and points to a target which exists"
    fi
  done < <(find "$output" -type l -print0)

  if ((numDanglingSymlinks > 0 || numReflexiveSymlinks > 0 || numUnreadableSymlinks > 0)); then
    nixErrorLog "found $numDanglingSymlinks dangling symlinks, $numReflexiveSymlinks reflexive symlinks and $numUnreadableSymlinks unreadable symlinks"
    exit 1
  fi
  return 0
}

noBrokenSymlinksInAllOutputs() {
  if [[ -z ${dontCheckForBrokenSymlinks-} ]]; then
    for output in $(getAllOutputNames); do
      noBrokenSymlinks "${!output}"
    done
  fi
}
