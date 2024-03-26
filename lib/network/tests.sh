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


# Test basic cases for ingesting a CIDR string.
expectEqual '(ipv4.fromCidr "192.168.0.1/24").cidr' '"192.168.0.1/24"'
expectEqual '(ipv4.fromCidr "192.168.0.1/24").address' '"192.168.0.1"'
expectEqual '(ipv4.fromCidr "192.168.0.1/24").prefixLength' '"24"'
expectEqual '(ipv4.fromCidr "192.168.0.1/24").subnetMask' '"255.255.255.0"'

# Test basic cases for encoding IPv4 address.
expectEqual 'internal.ipv4._encode 0' '"0.0.0.0"'
expectEqual 'internal.ipv4._encode 4294967295' '"255.255.255.255"'
expectEqual 'internal.ipv4._encode 3232235521' '"192.168.0.1"'
