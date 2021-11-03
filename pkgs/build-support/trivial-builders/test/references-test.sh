#!/usr/bin/env bash

# -------------------------------------------------------------------------- #
#
#                         trivial-builders test
#
# -------------------------------------------------------------------------- #
#
#  This file can be run independently (quick):
#
#      $ pkgs/build-support/trivial-builders/references-test.sh
#
#  or in the build sandbox with a ~20s VM overhead
#
#      $ nix-build -A tests.trivial-builders.references
#
# -------------------------------------------------------------------------- #

# strict bash
set -euo pipefail

# debug
# set -x
# PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

cd "$(dirname ${BASH_SOURCE[0]})"  # nixpkgs root

if [[ -z ${SAMPLE:-} ]]; then
  echo "Running the script directly is currently not supported."
  echo "If you need to iterate, remove the raw path, which is not returned by nix-build."
  exit 1
#   sample=( `nix-build --no-out-link sample.nix` )
#   directRefs=( `nix-build --no-out-link invoke-writeDirectReferencesToFile.nix` )
#   references=( `nix-build --no-out-link invoke-writeReferencesToFile.nix` )
#   echo "sample: ${#sample[@]}"
#   echo "direct: ${#directRefs[@]}"
#   echo "indirect: ${#references[@]}"
else
  # Injected by Nix (to avoid evaluating in a derivation)
  # turn them into arrays
  sample=($SAMPLE)
  directRefs=($DIRECT_REFS)
  references=($REFERENCES)
fi

echo >&2 Testing direct references...
for i in "${!sample[@]}"; do
  echo >&2 Checking '#'$i ${sample[$i]} ${directRefs[$i]}
  diff -U3 \
    <(sort <${directRefs[$i]}) \
    <(nix-store -q --references ${sample[$i]} | sort)
done

echo >&2 Testing closure...
for i in "${!sample[@]}"; do
  echo >&2 Checking '#'$i ${sample[$i]} ${references[$i]}
  diff -U3 \
    <(sort <${references[$i]}) \
    <(nix-store -q --requisites ${sample[$i]} | sort)
done

echo 'OK!'
