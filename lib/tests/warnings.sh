#!/usr/bin/env bash

# Tests lib/warnings.nix
# Run:
# [nixpkgs]$ lib/tests/warnings.sh
# or:
# [nixpkgs]$ nix-build lib/tests/release.nix

set -euo pipefail
shopt -s inherit_errexit

die() {
  printf ' test case failed: %s\n' "$1" >&2
  printf '%s\n' "${@:2}" >&2
  exit 1
}

if test -n "${TEST_LIB:-}"; then
  NIX_PATH=nixpkgs="$(dirname "$TEST_LIB")"
else
  NIX_PATH=nixpkgs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
fi
export NIX_PATH

PREFIX_IMPORT="(import $NIX_PATH/lib/tests/warnings.nix { })"

firstLine() {
  echo "$1" | head -n 1
}

# Completely tests a type for warnAlias function
testAliasCase() {
  local attributeName=$1
  echo "Testing attribute '$attributeName'..."

  local eval_arg
  # --eval on derivations tries to evaluate all attributes recursively, which
  # always results in some kind of error, which is not what we want at all
  if [ "$attributeName" != "drv" ]; then
    eval_arg="1"
  fi

  # Evaluate attribute and checks for warning using regex
  echo " Evaluating for warning..."
  if result=$(
    NIX_ABORT_ON_WARN=1 \
      nix-instantiate ${eval_arg:+"--eval"} --strict \
        --expr "$PREFIX_IMPORT.$attributeName" \
        2>&1
  ); then
    die "'$attributeName' did not produce warning, but it was expected to:" "$result"
  fi

  local expectedWarningRegex="^trace: evaluation warning: $attributeName alias$"
  if [[ ! $(firstLine "$result") =~ $expectedWarningRegex ]]; then
    die "Result is '$(firstLine "$result")', but '$expectedWarningRegex' was expected" "$result"
  fi

  # Evaluate attribute for value, and check it with the value it is aliasing to
  # but do not error on warning
  echo " Evaluating for value..."
  if ! result_attr=$(
    nix-instantiate ${eval_arg:+"--eval"} --strict \
      --expr "$PREFIX_IMPORT.$attributeName" \
      2>/dev/null
  ); then
    die "'$attributeName' failed to evaluate for value, but it was expected to succeed" "$result"
  fi
  # Evaluating the original value to check it with alias
  echo " Getting expected value..."
  if ! expected_attr=$(
    NIX_ABORT_ON_WARN=1 \
      nix-instantiate ${eval_arg:+"--eval"} --strict \
        --expr "$PREFIX_IMPORT.${attributeName}Dest" \
        2>/dev/null
  ); then
    die "'${attributeName}Dest' failed to evaluate with message, but it was expected to succeed" "$result"
  fi

  if [[ "$result_attr" != "$expected_attr" ]]; then
    die "'$attributeName' expected to be '$expected_attr', but it is '$result_attr'"
  fi
  echo " Done testing $attributeName!"
}

expectSuccess() {
  local expr=$1
  local expectedResultRegex=$2
  echo "Testing '$expr'..."
  if ! result=$(
    NIX_ABORT_ON_WARN=1 \
      nix-instantiate --eval --strict \
        --expr "with (import <nixpkgs> { }); $expr" \
        2>&1
  ); then
    die "'$expr' failed to evaluate, but it was expected to succeed:" "$result"
  fi
  if [[ ! $(firstLine "$result") =~ $expectedResultRegex ]]; then
    die "Mismatched regex; expected '$expectedResultRegex' but result is:" "$result"
  fi
}

expectFailure() {
  local expr=$1
  local expectedErrorRegex=$2
  echo "Testing '$expr'..."
  if result=$(
    NIX_ABORT_ON_WARN=1 \
      nix-instantiate --eval --strict \
        --expr "with (import <nixpkgs> { }); $expr" \
        2>&1
  ); then
    die "'$expr' evaluated successfully, but it was expected to fail:" "$result"
  fi
  if [[ ! $(firstLine "$result") =~ $expectedErrorRegex ]]; then
    die "Mismatched regex; expected '$expectedErrorRegex' but result is:" "$result"
  fi
}

# tests for warnAlias
testAliasCase drv
testAliasCase attrs
testAliasCase func
testAliasCase list
testAliasCase arbitrary

# tests for warnOnInstantiate
expectFailure 'lib.warnOnInstantiate "error message" hello' '^trace: evaluation warning: error message$'
expectSuccess '(lib.warnOnInstantiate "error message" hello).meta' 'description = "Program that produces a familiar, friendly greeting";'
expectSuccess '(lib.warnOnInstantiate "error message" hello).name' '^"hello-2.12.2"$'
expectSuccess '(lib.warnOnInstantiate "error message" hello).type' '^"derivation"$'
expectSuccess '(lib.warnOnInstantiate "error message" hello).outputName' '^"out"$'
