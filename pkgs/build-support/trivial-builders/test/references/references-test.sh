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

  # Inject the path to compare from the Nix expression

  # Associative Arrays
  declare -A samples=( @SAMPLES@ )
  declare -A directRefs=( @DIRECT_REFS@ )
  declare -A closures=( @CLOSURES@ )

  # Path string
  collectiveClosure=@COLLECTIVE_CLOSURE@

echo >&2 Testing direct closures...
for i in "${!samples[@]}"; do
  echo >&2 Checking "$i" "${samples[$i]}" "${directRefs[$i]}"
  diff -U3 \
    <(sort <"${directRefs[$i]}") \
    <(nix-store -q --references "${samples[$i]}" | sort)
done

echo >&2 Testing closure...
for i in "${!samples[@]}"; do
  echo >&2 Checking "$i" "${samples[$i]}" "${closures[$i]}"
  diff -U3 \
    <(sort <"${closures[$i]}") \
    <(nix-store -q --requisites "${samples[$i]}" | sort)
done

echo >&2 Testing mixed closures...
echo >&2 Checking all samples "(${samples[*]})" "$collectiveClosure"
diff -U3 \
  <(sort <"$collectiveClosure") \
  <(nix-store -q --requisites "${samples[@]}" | sort)

echo 'OK!'
