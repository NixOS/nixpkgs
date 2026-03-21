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

expectSuccess() {
    local expr=$1
    local expectedResultRegex=$2
    if ! result=$(nix-instantiate --eval --strict --json \
        --expr "with (import <nixpkgs/lib>).filesystem; $expr"); then
        die "$expr failed to evaluate, but it was expected to succeed"
    fi
    if [[ ! "$result" =~ $expectedResultRegex ]]; then
        die "$expr == $result, but $expectedResultRegex was expected"
    fi
}

expectFailure() {
    local expr=$1
    local expectedErrorRegex=$2
    if result=$(nix-instantiate --eval --strict --json 2>"$work/stderr" \
        --expr "with (import <nixpkgs/lib>).filesystem; $expr"); then
        die "$expr evaluated successfully to $result, but it was expected to fail"
    fi
    if [[ ! "$(<"$work/stderr")" =~ $expectedErrorRegex ]]; then
        die "Error was $(<"$work/stderr"), but $expectedErrorRegex was expected"
    fi
}

expectSuccess "pathType /." '"directory"'
expectSuccess "pathType $PWD/directory" '"directory"'
expectSuccess "pathType $PWD/regular" '"regular"'
expectSuccess "pathType $PWD/symlink" '"symlink"'
expectSuccess "pathType $PWD/fifo" '"unknown"'

# Only check error message when a Nixpkgs-specified error is thrown,
# which is only the case when `readFileType` is not available
# and the fallback implementation needs to be used.
if [[ "$(nix-instantiate --eval --expr 'builtins ? readFileType')" == false ]]; then
    expectFailure "pathType $PWD/non-existent" \
        "error: evaluation aborted with the following error message: 'lib.filesystem.pathType: Path $PWD/non-existent does not exist.'"
fi

expectSuccess "pathIsDirectory /." "true"
expectSuccess "pathIsDirectory $PWD/directory" "true"
expectSuccess "pathIsDirectory $PWD/regular" "false"
expectSuccess "pathIsDirectory $PWD/symlink" "false"
expectSuccess "pathIsDirectory $PWD/fifo" "false"
expectSuccess "pathIsDirectory $PWD/non-existent" "false"

expectSuccess "pathIsRegularFile /." "false"
expectSuccess "pathIsRegularFile $PWD/directory" "false"
expectSuccess "pathIsRegularFile $PWD/regular" "true"
expectSuccess "pathIsRegularFile $PWD/symlink" "false"
expectSuccess "pathIsRegularFile $PWD/fifo" "false"
expectSuccess "pathIsRegularFile $PWD/non-existent" "false"

echo >&2 tests ok
