#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jshon diffutils
#
# TODO: copy usage from `nix edit`
# Usage: nix-update-sha [-f <file>]<INSTALLABLE>
#
# Example: nix-update-src.sh nixpkgs.hello

# FIXME: find a nix replacement for nix-prefetch-url

set -euo pipefail

usage() {
  echo "Usage: $0 [-f <file>] <INSTALLABLE>" >&2
  exit 1
}

main () {
  set -eu

  ### command-line parsing
  local nix_args=()
  while getopts ":f:" o; do
    case "${o}" in
      f)
        nix_args+=(-f "${OPTARG}")
        ;;
      *)
        usage
        ;;
    esac
  done
  shift $((OPTIND-1))

  local drvAttr=$1
  [[ -z $drvAttr ]] && usage

  ### drvAttr heuristics

  # add the .src attribute if it exists
  if nixFile "$drvAttr.src" "${nix_args[@]}" &>/dev/null; then
    log "switching from $drvAttr to $drvAttr.src"
    drvAttr=$drvAttr.src
  fi

  # look if the derivation has multiple sources
  if nixFile "$drvAttr.sources" "${nix_args[@]}" 2>/dev/null; then
    nixKeys "$drvAttr.sources" "${nix_args[@]}"
    for key in $(nixKeys "$drvAttr.sources" "${nix_args[@]}"); do
      updateSha "$drvAttr.sources.$key" "${nix_args[@]}"
    done
  else
    updateSha "$drvAttr" "${nix_args[@]}"
  fi
}

updateSha() {
  set -eu
  local drvAttr=$1
  local oldHash newHash hashMethod hashFile
  shift

  log "Updating $drvAttr"

  # Get the old hash
  oldHash=$(nixEval "$drvAttr.outputHash" "$@" --raw)

  log "Fetching source..."
  newHash=$(nix-prefetch-url -A "$drvAttr")

  if [[ "$oldHash" = "$newHash" ]]; then
    log "Hash unchanged. All good."
    return 0
  fi

  log "Looking for file to update"
  hashMethod=$(nixEval "$drvAttr.outputHashAlgo" "$@" --raw)
  hashFile=$(nixFile "$drvAttr.$hashMethod" "$@")
  if [[ ! -f "$hashFile" ]]; then
    log "ERROR: file '$hashFile' with method '$hashMethod' not found"
    return 1
  fi

  log "Rewriting hash $oldHash to $newHash"
  replaceSha "$hashFile" "$oldHash" "$newHash"
}

replaceSha () {
  local file=$1 old=$2 new=$3
  diff -U3 "$file" <(sed -e "s/$old/$new/" "$file") --color || true
  sed -e "s/$old/$new/" -i "$file"
}

nixKeys () {
  nixEval "$@" --json | jshon -k
}

nixEval () {
  nix eval "$@"
}

nixFile () {
  EDITOR=echo nix edit "$@"
}

log () { echo >&2; echo "$@" >&2; }

# Run the stuff!
main "$@"
