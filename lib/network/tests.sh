#!/usr/bin/env bash

# Tests lib.network
# Run:
# [nixpkgs]$ lib/network/tests.sh

set -euo pipefail


die() {
    # The second to last entry contains the line number of the top-level caller
    lineIndex=$(( ${#BASH_LINENO[@]} - 2 ))
    echo >&2 -e "test case at ${BASH_SOURCE[0]}:${BASH_LINENO[$lineIndex]} failed:" "$@"
    exit 1
}


if test -n "${TEST_LIB:-}"; then
    NIX_PATH=nixpkgs="$(dirname "$TEST_LIB")"
else
    NIX_PATH=nixpkgs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
fi
export NIX_PATH


tmp="$(mktemp -d)"
clean_up() {
    rm -rf "$tmp"
}
trap clean_up EXIT SIGINT SIGTERM
work="$tmp/work"
mkdir "$work"
cd "$work"

prefixExpression='
  let
    lib = import <nixpkgs/lib>;
    internal = import <nixpkgs/lib/network/internal.nix> {
      inherit lib;
    };
  in
  with lib;
  with lib.network;
'

# Check that two nix expression successfully evaluate to the same value.
# The expressions have `lib.fileset` in scope.
# Usage: expectEqual NIX NIX
expectEqual() {
    local actualExpr=$1
    local expectedExpr=$2
    if actualResult=$(nix-instantiate --eval --strict --show-trace 2>"$tmp"/actualStderr \
        --expr "$prefixExpression ($actualExpr)"); then
        actualExitCode=$?
    else
        actualExitCode=$?
    fi
    actualStderr=$(< "$tmp"/actualStderr)

    if expectedResult=$(nix-instantiate --eval --strict --show-trace 2>"$tmp"/expectedStderr \
        --expr "$prefixExpression ($expectedExpr)"); then
        expectedExitCode=$?
    else
        expectedExitCode=$?
    fi
    expectedStderr=$(< "$tmp"/expectedStderr)

    if [[ "$actualExitCode" != "$expectedExitCode" ]]; then
        echo "$actualStderr" >&2
        echo "$actualResult" >&2
        die "$actualExpr should have exited with $expectedExitCode, but it exited with $actualExitCode"
    fi

    if [[ "$actualResult" != "$expectedResult" ]]; then
        die "$actualExpr should have evaluated to $expectedExpr:\n$expectedResult\n\nbut it evaluated to\n$actualResult"
    fi

    if [[ "$actualStderr" != "$expectedStderr" ]]; then
        die "$actualExpr should have had this on stderr:\n$expectedStderr\n\nbut it was\n$actualStderr"
    fi
}


# Check that a nix expression fails to evaluate (strictly, read-write-mode).
# And check the received stderr against a regex
# The expression has `lib.network` in scope.
# Usage: expectFailure NIX REGEX
expectFailure() {
    local expr=$1
    local expectedErrorRegex=$2
    if result=$(nix-instantiate --eval --strict --read-write-mode --show-trace 2>"$tmp/stderr" \
        --expr "$prefixExpression $expr"); then
        die "$expr evaluated successfully to $result, but it was expected to fail"
    fi
    stderr=$(<"$tmp/stderr")
    if [[ ! "$stderr" =~ $expectedErrorRegex ]]; then
        die "$expr should have errored with this regex pattern:\n\n$expectedErrorRegex\n\nbut this was the actual error:\n\n$stderr"
    fi
}


# Test basic cases for ingesting a CIDR string.
expectEqual '(ipv4.fromCidrString "192.168.0.1/24").cidr' '"192.168.0.1/24"'
expectEqual '(ipv4.fromCidrString "192.168.0.1/24").address' '"192.168.0.1"'
expectEqual '(ipv4.fromCidrString "192.168.0.1/24").prefixLength' '"24"'

expectEqual '(ipv4.fromCidrString "192.168.0.1").prefixLength' '"32"'

# Test cases for bad IP addresses
expectFailure 'ipv4.fromCidrString "192.168.0./24"' 'lib.network.ipv4: CIDR 192.168.0./24 has an empty octet.'
expectFailure 'ipv4.fromCidrString "192.168.0/24"' 'lib.network.ipv4: CIDR 192.168.0/24 is not of the correct form.'
expectFailure 'ipv4.fromCidrString "192.168.0.256/24"' 'lib.network.ipv4: CIDR 192.168.0.256/24 has an out of bounds octet.'
expectFailure 'ipv4.fromCidrString "192.168.0.-1/24"' 'lib.network.ipv4: CIDR 192.168.0.-1/24 has an out of bounds octet.'

# Test basic cases for verifying a prefix length.
expectFailure 'ipv4.fromCidrString "192.168.0.1/"' 'lib.network.ipv4: CIDR 192.168.0.1/ has no prefix length.'
expectFailure 'ipv4.fromCidrString "192.168.0.1/33"' 'lib.network.ipv4: CIDR 192.168.0.1/33 has an out of bounds prefix length, 33.'
expectFailure 'ipv4.fromCidrString "192.168.0.1/-1"' 'lib.network.ipv4: CIDR 192.168.0.1/-1 has an out of bounds prefix length, -1.'
expectFailure 'ipv4.fromCidrString "192.168.0.1/24/bad"' 'lib.network.ipv4: Could not verify prefix length for CIDR 192.168.0.1/24/bad'

# Test pow function
expectEqual 'internal.common.pow 2 0' '1'
expectEqual 'internal.common.pow 2 3' '8'
expectFailure 'internal.common.pow 2 (-1)' 'lib.network.pow: Exponent cannot be negative.'
