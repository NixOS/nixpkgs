#!/usr/bin/env bash

# -------------------------------------------------------------------------- #
#
#                         trivial-builders test
#
# -------------------------------------------------------------------------- #
#
#  This file can be run independently (quick):
#
#      $ pkgs/build-support/trivial-builders/test.sh
#
#  or in the build sandbox with a ~20s VM overhead
#
#      $ nix-build -A tests.trivial-builders
#
# -------------------------------------------------------------------------- #

# strict bash
set -euo pipefail

# debug
# set -x
# PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

cd "$(dirname ${BASH_SOURCE[0]})"  # nixpkgs root

testDirectReferences() {
  expr="$1"
  diff -U3 \
    <(sort <$(nix-build --no-out-link --expr "with import ../../.. {}; writeDirectReferencesToFile ($expr)")) \
    <(nix-store -q --references $(nix-build --no-out-link --expr "with import ../../.. {}; ($expr)") | sort)
}

testDirectReferences 'hello'
testDirectReferences 'figlet'
testDirectReferences 'writeText "hi" "hello"'
testDirectReferences 'writeText "hi" "hello ${hello}"'
testDirectReferences 'writeText "hi" "hello ${hello} ${figlet}"'



testClosure() {
  expr="$1"
  diff -U3 \
    <(sort <$(nix-build --no-out-link --expr "with import ../../.. {}; writeReferencesToFile ($expr)")) \
    <(nix-store -q --requisites $(nix-build --no-out-link --expr "with import ../../.. {}; ($expr)") | sort)
}

testClosure 'hello'
testClosure 'figlet'
testClosure 'writeText "hi" "hello"'
testClosure 'writeText "hi" "hello ${hello}"'
testClosure 'writeText "hi" "hello ${hello} ${figlet}"'


echo 'OK!'
