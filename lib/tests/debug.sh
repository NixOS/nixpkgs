#!/usr/bin/env bash

# Tests lib/debug.nix
# Run:
# [nixpkgs]$ lib/tests/debug.sh
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

expectSuccess() {
    local expr=$1
    local expectedResultRegex=$2
    if ! result=$(nix-instantiate --eval --strict --json \
        --expr "with (import <nixpkgs/lib>).debug; $expr" 2>/dev/null); then
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
        --expr "with (import <nixpkgs/lib>).debug; $expr"); then
        die "$expr evaluated successfully to $result, but it was expected to fail"
    fi
    if [[ ! "$(<"$work/stderr")" =~ $expectedErrorRegex ]]; then
        die "Error was $(<"$work/stderr"), but $expectedErrorRegex was expected"
    fi
}

# Test throwTestFailures with empty failures list
expectSuccess 'throwTestFailures { failures = [ ]; }' "null"

# Test throwTestFailures with actual failures
# This should throw with a specific error message format
expectFailure 'throwTestFailures {
  failures = [
    {
      name = "testDerivation";
      expected = builtins.derivation {
        name = "a";
        builder = "bash";
        system = "x86_64-linux";
      };
      result = builtins.derivation {
        name = "b";
        builder = "bash";
        system = "x86_64-linux";
      };
    }
  ];
}' "1 tests failed"

echo >&2 tests ok
