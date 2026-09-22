#!/usr/bin/env bash

# Tests lib/strings.nix
# Run:
# [nixpkgs]$ lib/tests/strings.sh
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
  nixpkgs="$(dirname "$TEST_LIB")"
else
  nixpkgs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
fi
export NIX_PATH=nixpkgs=$nixpkgs

work="$(mktemp -d)"
clean_up() {
  rm -rf "$work"
}
trap clean_up EXIT
cd "$work"

expectSuccess() {
    local expr=$1
    local expectedResultRegex=$2
    if ! result=$(nix-instantiate --eval --strict --json \
        --expr "with (import <nixpkgs/lib>).strings; $expr" 2>/dev/null); then
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
        --expr "with (import <nixpkgs/lib>).strings; $expr"); then
        die "$expr evaluated successfully to $result, but it was expected to fail"
    fi
    if [[ ! "$(<"$work/stderr")" =~ $expectedErrorRegex ]]; then
        die "Error was $(<"$work/stderr"), but $expectedErrorRegex was expected"
    fi
}

expectFailure 'escapeShellArg /does-not-exist' "error: path '/does-not-exist' does not exist"

# Without this, there would be no need to escape the path.
export NIX_STORE_DIR="$work/store with spaces"
mkdir -p $NIX_STORE_DIR

# Check that escaping happens even with paths.
expectSuccess "escapeShellArg $nixpkgs/lib/tests/strings.sh" "'$NIX_STORE_DIR/.*'"
# Check that store paths are not recopied into the store.
expectSuccess "escapeShellArg (/. + replaceString \"'\" \"\" $result)" "$result"

export -n NIX_STORE_DIR

echo >&2 tests ok
