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

# Test pow function
expectEqual 'internal.common.pow 2 0' '1'
expectEqual 'internal.common.pow 2 3' '8'
expectFailure 'internal.common.pow 2 (-1)' 'lib.network.pow: Exponent cannot be negative.'

# Test basic cases for encoding IPv4 address.
expectEqual 'internal.ipv4._encode 0' '"0.0.0.0"'
expectEqual 'internal.ipv4._encode 4294967295' '"255.255.255.255"'
expectEqual 'internal.ipv4._encode 3232235521' '"192.168.0.1"'
expectFailure 'internal.ipv4._encode 4294967296' 'lib.network.ipv4._encode: [[:digit:]]+ is too large to encode into an IPv4 address.'
expectFailure 'internal.ipv4._encode (-1)' 'lib.network.ipv4._encode: -[[:digit:]]+ cannot be encoded into an IPv4 address.'

# Test basic cases for verifying an address.
expectEqual 'internal.ipv4._verifyAddress "192.168.0.1/24"' '"192.168.0.1"'
expectFailure 'internal.ipv4._verifyAddress "192.168.0./24"' 'lib.network.ipv4: CIDR 192.168.0./24 has an empty octet.'
expectFailure 'internal.ipv4._verifyAddress "192.168.0/24"' 'lib.network.ipv4: CIDR 192.168.0/24 is not of the correct form.'
expectFailure 'internal.ipv4._verifyAddress "192.168.0.256/24"' 'lib.network.ipv4: CIDR 192.168.0.256/24 has an out of bounds octet.'
expectFailure 'internal.ipv4._verifyAddress "192.168.0.-1/24"' 'lib.network.ipv4: CIDR 192.168.0.-1/24 has an out of bounds octet.'

# Test basic cases for verifying a prefix length.
expectEqual 'internal.ipv4._verifyPrefixLength "192.168.0.1/24"' '"24"'
expectEqual 'internal.ipv4._verifyPrefixLength "192.168.0.1"' '"32"'
expectFailure 'internal.ipv4._verifyPrefixLength "192.168.0.1/"' 'lib.network.ipv4: CIDR 192.168.0.1/ has no prefix length.'
expectFailure 'internal.ipv4._verifyPrefixLength "192.168.0.1/33"' 'lib.network.ipv4: CIDR 192.168.0.1/33 has an out of bounds prefix length, 33.'
expectFailure 'internal.ipv4._verifyPrefixLength "192.168.0.1/-1"' 'lib.network.ipv4: CIDR 192.168.0.1/-1 has an out of bounds prefix length, -1.'
expectFailure 'internal.ipv4._verifyPrefixLength "192.168.0.1/24/bad"' 'lib.network.ipv4: Could not verify prefix length for CIDR 192.168.0.1/24/bad'
