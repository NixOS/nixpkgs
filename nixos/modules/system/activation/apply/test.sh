#!/usr/bin/env bash
# shellcheck disable=SC2317 disable=SC2031
# False positives:
# SC2317: Unreachable code: TEST_*
# SC2031: <variable> was modified in a subshell. That change might be lost.
#         We have a lot of that, and that's expected.

# This is a unit test script for the NixOS apply script.
# It can be run quickly with the following command:
#
#     ./test.sh
#
# Alternatively, run the following to run all tests and checks
#
#     TODO
#

set -euo pipefail
# set -x

apply="${BASH_SOURCE[0]%/*}/apply.sh"
# source_apply() {

run_parse_args() {
  bash -c "source $apply;"' parse_args "$@"' -- "$@"
}

TEST_parse_args_none() {
  if errout="$(run_parse_args 2>&1)"; then
    test_fail "apply without arguments should fail"
  elif [[ $? -ne 1 ]]; then
    test_fail "apply without arguments should exit with code 1"
  fi
  grep -F "no subcommand specified" <<<"$errout" >/dev/null
}

TEST_parse_args_switch() {
  (
    # shellcheck source=nixos/modules/system/activation/apply/apply.sh
    source "$apply";
    parse_args switch;
    [[ $subcommand == switch ]]
    [[ $specialisation == "" ]]
    [[ $profile == "" ]]
  )
}

TEST_parse_args_boot() {
  (
    # shellcheck source=nixos/modules/system/activation/apply/apply.sh
    source "$apply";
    parse_args boot;
    [[ $subcommand == boot ]]
    [[ $specialisation == "" ]]
    [[ $profile == "" ]]
  )
}

TEST_parse_args_test() {
  (
    # shellcheck source=nixos/modules/system/activation/apply/apply.sh
    source "$apply";
    parse_args test;
    [[ $subcommand == test ]]
    [[ $specialisation == "" ]]
    [[ $profile == "" ]]
  )
}

TEST_parse_args_dry_activate() {
  (
    # shellcheck source=nixos/modules/system/activation/apply/apply.sh
    source "$apply";
    parse_args dry-activate;
    [[ $subcommand == dry-activate ]]
    [[ $specialisation == "" ]]
    [[ $profile == "" ]]
  )
}

TEST_parse_args_unknown() {
  if errout="$(run_parse_args foo 2>&1)"; then
    test_fail "apply with unknown subcommand should fail"
  fi
  grep -F "unexpected argument or flag: foo" <<<"$errout" >/dev/null
}

TEST_parse_args_switch_specialisation_no_arg() {
  if errout="$(run_parse_args switch --specialisation 2>&1)"; then
    test_fail "apply with --specialisation without argument should fail"
  fi
  grep -F "missing argument for --specialisation" <<<"$errout" >/dev/null
}

TEST_parse_args_switch_specialisation() {
  (
    # shellcheck source=nixos/modules/system/activation/apply/apply.sh
    source "$apply";
    parse_args switch --specialisation low-power;
    [[ $subcommand == switch ]]
    [[ $specialisation == low-power ]]
    [[ $profile == "" ]]
  )
}

TEST_parse_args_switch_profile() {
  (
    # shellcheck source=nixos/modules/system/activation/apply/apply.sh
    source "$apply";
    parse_args switch --profile /nix/var/nix/profiles/system;
    [[ $subcommand == switch ]]
    [[ $specialisation == "" ]]
    [[ $profile == /nix/var/nix/profiles/system ]]
  )
}



# Support code

test_fail() {
  echo "TEST FAILURE: $*" >&2
  exit 1
}

test_print_trace() {
  local frame=${1:0}
  local caller
  # shellcheck disable=SC2207 disable=SC2086
  while caller=( $(caller $frame) ); do
    echo "  in ${caller[1]} at ${caller[2]}:${caller[0]}"
    frame=$((frame+1));
  done
}
test_on_err() {
  echo "ERROR running: ${BASH_COMMAND}" >&2
  test_print_trace 1 >&2
}

test_init() {
  trap 'test_on_err' ERR
}

test_find() {
  declare -F | grep -o 'TEST_.*' | sort
}

test_run_tests() {
  local status=0
  for test in $(test_find); do
    set +e
    (
      set -eEuo pipefail
      trap 'test_on_err' ERR
      $test
    )
    r=$?
    set -e
    if [[ $r == 0 ]]; then
      echo "ok: $test"
    else
      echo "TEST FAIL: $test"; status=1;
    fi
  done
  if [[ $status == 0 ]]; then
    echo "All good"
  else
    echo
    echo "TEST SUITE FAILED"
  fi
  exit $status
}

# Main
test_init
test_run_tests
