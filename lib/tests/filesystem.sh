#!/usr/bin/env bash

# Tests lib/filesystem.nix
# Run:
# [nixpkgs]$ lib/tests/filesystem.sh
# or:
# [nixpkgs]$ nix-build lib/tests/release.nix

set -euo pipefail
shopt -s inherit_errexit

# Use
#     || die
die() {
  echo >&2 "test case failed: " "$@"
  exit 1
}

if test -n "${TEST_LIB:-}"; then
  NIX_PATH=nixpkgs="$(dirname "$TEST_LIB")"
else
  NIX_PATH=nixpkgs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
fi
export NIX_PATH

work="$(mktemp -d)"
clean_up() {
  rm -rf "$work"
}
trap clean_up EXIT
cd "$work"

mkdir directory
touch regular
ln -s target symlink
mkfifo fifo

checkPathType() {
    local path=$1
    local expectedPathType=$2
    local actualPathType=$(nix-instantiate --eval --strict --json 2>&1 \
        -E '{ path }: let lib = import <nixpkgs/lib>; in lib.filesystem.pathType path' \
        --argstr path "$path")
    if [[ "$actualPathType" != "$expectedPathType" ]]; then
        die "lib.filesystem.pathType \"$path\" == $actualPathType, but $expectedPathType was expected"
    fi
}

checkPathType "$PWD/directory" '"directory"'
checkPathType "$PWD/regular" '"regular"'
checkPathType "$PWD/symlink" '"symlink"'
checkPathType "$PWD/fifo" '"unknown"'

checkPathIsDirectory() {
    local path=$1
    local expectedIsDirectory=$2
    local actualIsDirectory=$(nix-instantiate --eval --strict --json 2>&1 \
        -E '{ path }: let lib = import <nixpkgs/lib>; in lib.filesystem.pathIsDirectory path' \
        --argstr path "$path")
    if [[ "$actualIsDirectory" != "$expectedIsDirectory" ]]; then
        die "lib.filesystem.pathIsDirectory \"$path\" == $actualIsDirectory, but $expectedIsDirectory was expected"
    fi
}

checkPathIsDirectory "$PWD/directory" "true"
checkPathIsDirectory "$PWD/regular" "false"
checkPathIsDirectory "$PWD/symlink" "false"
checkPathIsDirectory "$PWD/fifo" "false"
checkPathIsDirectory "$PWD/non-existent" "false"

checkPathIsRegularFile() {
    local path=$1
    local expectedIsRegularFile=$2
    local actualIsRegularFile=$(nix-instantiate --eval --strict --json 2>&1 \
        -E '{ path }: let lib = import <nixpkgs/lib>; in lib.filesystem.pathIsRegularFile path' \
        --argstr path "$path")
    if [[ "$actualIsRegularFile" != "$expectedIsRegularFile" ]]; then
        die "lib.filesystem.pathIsRegularFile \"$path\" == $actualIsRegularFile, but $expectedIsRegularFile was expected"
    fi
}

checkPathIsRegularFile "$PWD/directory" "false"
checkPathIsRegularFile "$PWD/regular" "true"
checkPathIsRegularFile "$PWD/symlink" "false"
checkPathIsRegularFile "$PWD/fifo" "false"
checkPathIsRegularFile "$PWD/non-existent" "false"

echo >&2 tests ok
