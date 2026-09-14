#!/usr/bin/env nix-shell
#!nix-shell -i bash
#!nix-shell -p jq git
# shellcheck shell=bash
#
# Usage: eval-pkg-sets.sh [extra flags for nix-* commands ...]
#
# Must be executed in a git checkout of Nixpkgs.

set -euo pipefail

NIXPKGS="$(git rev-parse --show-toplevel)"
PKGSETS="$(nix-env --readonly-mode --json --drv-path -f "$NIXPKGS" -qaP -A haskell.compiler "$@" \
  | jq -r 'to_entries | unique_by(.value.drvPath) .[] .key | sub("^haskell.compiler";"haskell.packages")')"

trap 'exit 1' SIGINT SIGTERM

set +e

badsets=""
for set in $PKGSETS; do
  # Confirm an equivalent package set to haskell.compiler.$entry exists and is usable
  if ! nix-instantiate --readonly-mode -A "$set.ghc" "$@" > /dev/null 2>&1; then
    echo "Skipping $set... ($set.ghc does not evaluate)"
  else
    echo "Evaluating $set..."

    if ! nix-env --readonly-mode -f "$NIXPKGS" -qaP --drv-path -A "$set" "$@" > /dev/null; then
      badsets+="$set "
    fi
  fi
done

if [ -n "$badsets" ]; then
  echo "Found potential eval issues in the following sets:" >&2
  # shellcheck disable=SC2086
  printf '%s\n' $badsets
  exit 1
fi
