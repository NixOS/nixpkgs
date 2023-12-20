#!/usr/bin/env bash

# -------------------------------------------------------------------------- #
#
#                         trivial-builders test
#
# -------------------------------------------------------------------------- #
#
# Execute this build script directly (quick):
#
# * Classic
#   $ NIX_PATH="nixpkgs=$PWD" nix-shell -p tests.trivial-builders.references.testScriptBin --run references-test
#
# * Flake-based
#   $ nix run .#tests.trivial-builders.references.testScriptBin
#
# or in the build sandbox with a ~20s VM overhead:
#
# * Classic
#   $ nix-build --no-out-link -A tests.trivial-builders.references
#
# * Flake-based
#   $ nix build -L --no-link .#tests.trivial-builders.references
#
# -------------------------------------------------------------------------- #

# strict bash
set -euo pipefail

# debug
# set -x
# PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

cd "$(dirname "${BASH_SOURCE[0]}")"  # nixpkgs root

  # Injected by Nix (to avoid evaluating in a derivation)
  # turn them into arrays
  # shellcheck disable=SC2206 # deliberately unquoted
  declare -A samples=( @SAMPLES@ )
  # shellcheck disable=SC2206 # deliberately unquoted
  declare -A directRefs=( @DIRECT_REFS@ )
  # shellcheck disable=SC2206 # deliberately unquoted
  declare -A references=( @REFERENCES@ )

echo >&2 Testing direct references...
for i in "${!samples[@]}"; do
  echo >&2 Checking "$i" "${samples[$i]}" "${directRefs[$i]}"
  diff -U3 \
    <(sort <"${directRefs[$i]}") \
    <(nix-store -q --references "${samples[$i]}" | sort)
done

echo >&2 Testing closure...
for i in "${!samples[@]}"; do
  echo >&2 Checking "$i" "${samples[$i]}" "${references[$i]}"
  diff -U3 \
    <(sort <"${references[$i]}") \
    <(nix-store -q --requisites "${samples[$i]}" | sort)
done

echo 'OK!'
