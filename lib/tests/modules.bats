#!/usr/bin/env nix-shell
#!nix-shell -i bats -p "bats.withLibraries (p: [ p.bats-support p.bats-assert p.file ])" -I nixpkgs=../..
# vim: filetype=sh

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file

  bats_require_minimum_version 1.5.0

  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  cd "$DIR"/modules
}

evalConfig() {
  local attr=$1
  shift
  local script="import ./default.nix { modules = [ $* ];}"
  nix-instantiate --timeout 1 -E "$script" -A "$attr" --eval-only --show-trace --read-write-mode
}

# Check boolean option.
@test boolean_1 {
  run -0 evalConfig config.enable ./declare-enable.nix
  assert_output 'false'
}

@test boolean_2 {
  run ! evalConfig config.enable ./define-enable.nix
  assert_line --index 0 --regexp 'The option .* does not exist. Definition values:'
  assert_line --index 1 --regexp '\s*- In .*: true'
}

@test submodule_1 {
  run -0 evalConfig config.bare-submodule.nested ./declare-bare-submodule.nix ./declare-bare-submodule-nested-option.nix
  assert_output 1
}

@test submodule_2 {
  run -0 evalConfig config.bare-submodule.deep ./declare-bare-submodule.nix ./declare-bare-submodule-deep-option.nix
  assert_output 2
}

@test submodule_3 {
  run -0 evalConfig config.bare-submodule.nested ./declare-bare-submodule.nix ./declare-bare-submodule-nested-option.nix ./declare-bare-submodule-deep-option.nix ./define-bare-submodule-values.nix
  assert_output 42
}

@test submodule_4 {
  run -0 evalConfig config.bare-submodule.deep ./declare-bare-submodule.nix ./declare-bare-submodule-nested-option.nix ./declare-bare-submodule-deep-option.nix ./define-bare-submodule-values.nix
  assert_output 420
}

@test submodule_5 {
  run -0 evalConfig config.bare-submodule.deep ./declare-bare-submodule.nix ./declare-bare-submodule-deep-option.nix ./define-shorthandOnlyDefinesConfig-true.nix
  assert_output 2
}

@test submodule_6 {
  run ! evalConfig config.bare-submodule.deep ./declare-bare-submodule.nix ./declare-bare-submodule-deep-option.nix  ./declare-bare-submodule-deep-option-duplicate.nix
  assert_output --regexp 'The option .bare-submodule.deep. in .*/declare-bare-submodule-deep-option.nix. is already declared in .*/declare-bare-submodule-deep-option-duplicate.nix'
}

# Check integer types.
# unsigned
@test integer_1 {
  run -0 evalConfig config.value ./declare-int-unsigned-value.nix ./define-value-int-positive.nix
  assert_output 42
}

@test integer_2 {
  run ! evalConfig config.value ./declare-int-unsigned-value.nix ./define-value-int-negative.nix
  assert_line --index 0 --regexp 'A definition for option .* is not of type.*unsigned integer.*. Definition values:'
  assert_line --index 1 --regexp '\s*- In .*: -23'
}

# positive
@test integer_3 {
  run ! evalConfig config.value ./declare-int-positive-value.nix ./define-value-int-zero.nix
  assert_line --index 0 --regexp 'A definition for option .* is not of type.*positive integer.*. Definition values:'
  assert_line --index 1 --regexp '\s*- In .*: 0'
}

# between
@test integer_4 {
  run -0 evalConfig config.value ./declare-int-between-value.nix ./define-value-int-positive.nix
  assert_output 42
}

@test integer_5 {
  run ! evalConfig config.value ./declare-int-between-value.nix ./define-value-int-negative.nix
  assert_line --index 0 --regexp 'A definition for option .* is not of type.*between.*-21 and 43.*inclusive.*. Definition values:'
  assert_line --index 1 --regexp '\s*- In .*: -23'
}

# Check either types
# types.either
@test either_1 {
  run -0 evalConfig config.value ./declare-either.nix ./define-value-int-positive.nix
  assert_output 42
}

@test either_2 {
  run -0 evalConfig config.value ./declare-either.nix ./define-value-string.nix
  assert_output '"24"'
}

# types.oneOf
@test oneOf_1 {
  run -0 evalConfig config.value ./declare-oneOf.nix ./define-value-int-positive.nix
  assert_output 42
}

@test oneOf_2 {
  run -0 evalConfig config.value ./declare-oneOf.nix ./define-value-list.nix
  assert_output '[ ]'
}

@test oneOf_3 {
  run -0 evalConfig config.value ./declare-oneOf.nix ./define-value-string.nix
  assert_output '"24"'
}

# Check mkForce without submodules.
@test mkForce_1 {
  run -0 evalConfig config.enable ./declare-enable.nix ./define-enable.nix
  assert_output true
}

@test mkForce_2 {
  run -0 evalConfig config.enable ./declare-enable.nix ./define-enable.nix ./define-force-enable.nix
  assert_output false
}

@test mkForce_3 {
  run -0 evalConfig config.enable ./declare-enable.nix ./define-enable.nix ./define-enable-force.nix
  assert_output false
}

# Check mkForce with option and submodules.
@test mkForce_4 {
  run ! evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix
  assert_output --regexp 'attribute .*foo.* .* not found'
}

@test mkForce_5 {
  run -0 evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo.nix
  assert_output false
}

@test mkForce_6 {
  run -0 evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo-enable.nix
  assert_output true
}

@test mkForce_7 {
  run -0 evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo-enable.nix ./define-force-attrsOfSub-foo-enable.nix
  assert_output false
}

@test mkForce_8 {
  run -0 evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo-enable.nix
  assert_output true
}

@test mkForce_9 {
  run -0 evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo-enable.nix ./define-force-attrsOfSub-foo-enable.nix
  assert_output false
}

@test mkForce_10 {
  run -0 evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo-enable.nix ./define-attrsOfSub-force-foo-enable.nix
  assert_output false
}

@test mkForce_11 {
  run -0 evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo-enable.nix ./define-attrsOfSub-foo-force-enable.nix
  assert_output false
}

@test mkForce_12 {
  run -0 evalConfig config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo-enable.nix ./define-attrsOfSub-foo-enable-force.nix
  assert_output false
}
