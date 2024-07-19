#!/usr/bin/env bash

# Tests lib/network.nix
# Run:
# [nixpkgs]$ lib/tests/network.sh
# or:
# [nixpkgs]$ nix-build lib/tests/release.nix

set -euo pipefail
shopt -s inherit_errexit

if [[ -n "${TEST_LIB:-}" ]]; then
  NIX_PATH=nixpkgs="$(dirname "$TEST_LIB")"
else
  NIX_PATH=nixpkgs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
fi
export NIX_PATH

die() {
  echo >&2 "test case failed: " "$@"
  exit 1
}

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

expectSuccess() {
    local expr=$1
    local expectedResult=$2
    if ! result=$(nix-instantiate --eval --strict --json --show-trace \
        --expr "$prefixExpression ($expr)"); then
        die "$expr failed to evaluate, but it was expected to succeed"
    fi
    if [[ ! "$result" == "$expectedResult" ]]; then
        die "$expr == $result, but $expectedResult was expected"
    fi
}

expectSuccessRegex() {
    local expr=$1
    local expectedResultRegex=$2
    if ! result=$(nix-instantiate --eval --strict --json --show-trace \
        --expr "$prefixExpression ($expr)"); then
        die "$expr failed to evaluate, but it was expected to succeed"
    fi
    if [[ ! "$result" =~ $expectedResultRegex ]]; then
        die "$expr == $result, but $expectedResultRegex was expected"
    fi
}

expectFailure() {
    local expr=$1
    local expectedErrorRegex=$2
    if result=$(nix-instantiate --eval --strict --json --show-trace 2>"$work/stderr" \
        --expr "$prefixExpression ($expr)"); then
        die "$expr evaluated successfully to $result, but it was expected to fail"
    fi
    if [[ ! "$(<"$work/stderr")" =~ $expectedErrorRegex ]]; then
        die "Error was $(<"$work/stderr"), but $expectedErrorRegex was expected"
    fi
}

# Internal functions
expectSuccess '(internal._ipv6.split "0:0:0:0:0:0:0:0").address'                         '[0,0,0,0,0,0,0,0]'
expectSuccess '(internal._ipv6.split "000a:000b:000c:000d:000e:000f:ffff:aaaa").address' '[10,11,12,13,14,15,65535,43690]'
expectSuccess '(internal._ipv6.split "::").address'                                      '[0,0,0,0,0,0,0,0]'
expectSuccess '(internal._ipv6.split "::0000").address'                                  '[0,0,0,0,0,0,0,0]'
expectSuccess '(internal._ipv6.split "::1").address'                                     '[0,0,0,0,0,0,0,1]'
expectSuccess '(internal._ipv6.split "::ffff").address'                                  '[0,0,0,0,0,0,0,65535]'
expectSuccess '(internal._ipv6.split "::000f").address'                                  '[0,0,0,0,0,0,0,15]'
expectSuccess '(internal._ipv6.split "::1:1:1:1:1:1:1").address'                         '[0,1,1,1,1,1,1,1]'
expectSuccess '(internal._ipv6.split "1::").address'                                     '[1,0,0,0,0,0,0,0]'
expectSuccess '(internal._ipv6.split "1:1:1:1:1:1:1::").address'                         '[1,1,1,1,1,1,1,0]'
expectSuccess '(internal._ipv6.split "1:1:1:1::1:1:1").address'                          '[1,1,1,1,0,1,1,1]'
expectSuccess '(internal._ipv6.split "1::1").address'                                    '[1,0,0,0,0,0,0,1]'

expectFailure 'internal._ipv6.split "0:0:0:0:0:0:0:-1"' "contains malformed characters for IPv6 address"
expectFailure 'internal._ipv6.split "::0:"'              "is not a valid IPv6 address"
expectFailure 'internal._ipv6.split ":0::"'              "is not a valid IPv6 address"
expectFailure 'internal._ipv6.split "0::0:"'             "is not a valid IPv6 address"
expectFailure 'internal._ipv6.split "0:0:"'              "is not a valid IPv6 address"
expectFailure 'internal._ipv6.split "0:0:0:0:0:0:0:0:0"' "is not a valid IPv6 address"
expectFailure 'internal._ipv6.split "0:0:0:0:0:0:0:0:"'  "is not a valid IPv6 address"
expectFailure 'internal._ipv6.split "::0:0:0:0:0:0:0:0"' "is not a valid IPv6 address"
expectFailure 'internal._ipv6.split "0::0:0:0:0:0:0:0"'  "is not a valid IPv6 address"
expectFailure 'internal._ipv6.split "::10000"'           "0x10000 is not a valid u16 integer"

expectSuccess '(internal._ipv6.split "::").prefixLength'     '128'
expectSuccess '(internal._ipv6.split "::/1").prefixLength'   '1'
expectSuccess '(internal._ipv6.split "::/128").prefixLength' '128'

expectFailure '(internal._ipv6.split "::/0").prefixLength'   "IPv6 subnet should be in range \[1;128\], got 0"
expectFailure '(internal._ipv6.split "::/129").prefixLength' "IPv6 subnet should be in range \[1;128\], got 129"
expectFailure '(internal._ipv6.split "/::/").prefixLength'   "is not a valid IPv6 address in CIDR notation"

# Library API
expectSuccess 'lib.network.ipv6.fromString "2001:DB8::ffff/64"' '{"address":"2001:db8:0:0:0:0:0:ffff","prefixLength":64}'
expectSuccess 'lib.network.ipv6.fromString "1234:5678:90ab:cdef:fedc:ba09:8765:4321/44"' '{"address":"1234:5678:90ab:cdef:fedc:ba09:8765:4321","prefixLength":44}'

echo >&2 tests ok
