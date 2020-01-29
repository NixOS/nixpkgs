#!/bin/sh
#
# This script is used to test that the module system is working as expected.
# By default it test the version of nixpkgs which is defined in the NIX_PATH.

cd ./modules

pass=0
fail=0

evalConfig() {
    local attr=$1
    shift;
    local script="import ./default.nix { modules = [ $@ ];}"
    nix-instantiate --timeout 1 -E "$script" -A "$attr" --eval-only --show-trace --read-write-mode
}

reportFailure() {
    local attr=$1
    shift;
    local script="import ./default.nix { modules = [ $@ ];}"
    echo 2>&1 "$ nix-instantiate -E '$script' -A '$attr' --eval-only"
    evalConfig "$attr" "$@"
    fail=$((fail + 1))
}

checkConfigOutput() {
    local outputContains=$1
    shift;
    if evalConfig "$@" 2>/dev/null | grep --silent "$outputContains" ; then
        pass=$((pass + 1))
        return 0;
    else
        echo 2>&1 "error: Expected result matching '$outputContains', while evaluating"
        reportFailure "$@"
        return 1
    fi
}

checkConfigError() {
    local errorContains=$1
    local err=""
    shift;
    if err==$(evalConfig "$@" 2>&1 >/dev/null); then
        echo 2>&1 "error: Expected error code, got exit code 0, while evaluating"
        reportFailure "$@"
        return 1
    else
        if echo "$err" | grep --silent "$errorContains" ; then
            pass=$((pass + 1))
            return 0;
        else
            echo 2>&1 "error: Expected error matching '$errorContains', while evaluating"
            reportFailure "$@"
            return 1
        fi
    fi
}

# Check boolean option.
checkConfigOutput "false" config.enable ./declare-enable.nix
checkConfigError 'The option .* defined in .* does not exist.' config.enable ./define-enable.nix

# Check integer types.
# unsigned
checkConfigOutput "42" config.value ./declare-int-unsigned-value.nix ./define-value-int-positive.nix
checkConfigError 'The option value .* in .* is not of type.*unsigned integer.*' config.value ./declare-int-unsigned-value.nix ./define-value-int-negative.nix
# positive
checkConfigError 'The option value .* in .* is not of type.*positive integer.*' config.value ./declare-int-positive-value.nix ./define-value-int-zero.nix
# between
checkConfigOutput "42" config.value ./declare-int-between-value.nix ./define-value-int-positive.nix
checkConfigError 'The option value .* in .* is not of type.*between.*-21 and 43.*inclusive.*' config.value ./declare-int-between-value.nix ./define-value-int-negative.nix

# Check either types
# types.either
checkConfigOutput "42" config.value ./declare-either.nix ./define-value-int-positive.nix
checkConfigOutput "\"24\"" config.value ./declare-either.nix ./define-value-string.nix
# types.oneOf
checkConfigOutput "42" config.value ./declare-oneOf.nix ./define-value-int-positive.nix
checkConfigOutput "[ ]" config.value ./declare-oneOf.nix ./define-value-list.nix
checkConfigOutput "\"24\"" config.value ./declare-oneOf.nix ./define-value-string.nix

# Check mkForce without submodules.
set -- config.enable ./declare-enable.nix ./define-enable.nix
checkConfigOutput "true" "$@"
checkConfigOutput "false" "$@" ./define-force-enable.nix
checkConfigOutput "false" "$@" ./define-enable-force.nix

# Check mkForce with option and submodules.
checkConfigError 'attribute .*foo.* .* not found' config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix
checkConfigOutput 'false' config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo.nix
set -- config.attrsOfSub.foo.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo-enable.nix
checkConfigOutput 'true' "$@"
checkConfigOutput 'false' "$@" ./define-force-attrsOfSub-foo-enable.nix
checkConfigOutput 'false' "$@" ./define-attrsOfSub-force-foo-enable.nix
checkConfigOutput 'false' "$@" ./define-attrsOfSub-foo-force-enable.nix
checkConfigOutput 'false' "$@" ./define-attrsOfSub-foo-enable-force.nix

# Check overriding effect of mkForce on submodule definitions.
checkConfigError 'attribute .*bar.* .* not found' config.attrsOfSub.bar.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo.nix
checkConfigOutput 'false' config.attrsOfSub.bar.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo.nix ./define-attrsOfSub-bar.nix
set -- config.attrsOfSub.bar.enable ./declare-attrsOfSub-any-enable.nix ./define-attrsOfSub-foo.nix ./define-attrsOfSub-bar-enable.nix
checkConfigOutput 'true' "$@"
checkConfigError 'attribute .*bar.* .* not found' "$@" ./define-force-attrsOfSub-foo-enable.nix
checkConfigError 'attribute .*bar.* .* not found' "$@" ./define-attrsOfSub-force-foo-enable.nix
checkConfigOutput 'true' "$@" ./define-attrsOfSub-foo-force-enable.nix
checkConfigOutput 'true' "$@" ./define-attrsOfSub-foo-enable-force.nix

# Check mkIf with submodules.
checkConfigError 'attribute .*foo.* .* not found' config.attrsOfSub.foo.enable ./declare-enable.nix ./declare-attrsOfSub-any-enable.nix
set -- config.attrsOfSub.foo.enable ./declare-enable.nix ./declare-attrsOfSub-any-enable.nix
checkConfigError 'attribute .*foo.* .* not found' "$@" ./define-if-attrsOfSub-foo-enable.nix
checkConfigError 'attribute .*foo.* .* not found' "$@" ./define-attrsOfSub-if-foo-enable.nix
checkConfigError 'attribute .*foo.* .* not found' "$@" ./define-attrsOfSub-foo-if-enable.nix
checkConfigOutput 'false' "$@" ./define-attrsOfSub-foo-enable-if.nix
checkConfigOutput 'true' "$@" ./define-enable.nix ./define-if-attrsOfSub-foo-enable.nix
checkConfigOutput 'true' "$@" ./define-enable.nix ./define-attrsOfSub-if-foo-enable.nix
checkConfigOutput 'true' "$@" ./define-enable.nix ./define-attrsOfSub-foo-if-enable.nix
checkConfigOutput 'true' "$@" ./define-enable.nix ./define-attrsOfSub-foo-enable-if.nix

# Check disabledModules with config definitions and option declarations.
set -- config.enable ./define-enable.nix ./declare-enable.nix
checkConfigOutput "true" "$@"
checkConfigOutput "false" "$@" ./disable-define-enable.nix
checkConfigError "The option .*enable.* defined in .* does not exist" "$@" ./disable-declare-enable.nix
checkConfigError "attribute .*enable.* in selection path .*config.enable.* not found" "$@" ./disable-define-enable.nix ./disable-declare-enable.nix
checkConfigError "attribute .*enable.* in selection path .*config.enable.* not found" "$@" ./disable-enable-modules.nix

# Check _module.args.
set -- config.enable ./declare-enable.nix ./define-enable-with-custom-arg.nix
checkConfigError 'while evaluating the module argument .*custom.* in .*define-enable-with-custom-arg.nix.*:' "$@"
checkConfigOutput "true" "$@" ./define-_module-args-custom.nix

# Check that using _module.args on imports cause infinite recursions, with
# the proper error context.
set -- "$@" ./define-_module-args-custom.nix ./import-custom-arg.nix
checkConfigError 'while evaluating the module argument .*custom.* in .*import-custom-arg.nix.*:' "$@"
checkConfigError 'infinite recursion encountered' "$@"

# Check _module.check.
set -- config.enable ./declare-enable.nix ./define-enable.nix ./define-attrsOfSub-foo.nix
checkConfigError 'The option .* defined in .* does not exist.' "$@"
checkConfigOutput "true" "$@" ./define-module-check.nix

# Check coerced value.
checkConfigOutput "\"42\"" config.value ./declare-coerced-value.nix
checkConfigOutput "\"24\"" config.value ./declare-coerced-value.nix ./define-value-string.nix
checkConfigError 'The option value .* in .* is not.*string or signed integer convertible to it' config.value ./declare-coerced-value.nix ./define-value-list.nix

# Check coerced value with unsound coercion
checkConfigOutput "12" config.value ./declare-coerced-value-unsound.nix
checkConfigError 'The option value .* in .* is not.*8 bit signed integer.* or string convertible to it' config.value ./declare-coerced-value-unsound.nix ./define-value-string-bigint.nix
checkConfigError 'unrecognised JSON value' config.value ./declare-coerced-value-unsound.nix ./define-value-string-arbitrary.nix

# Check mkAliasOptionModule.
checkConfigOutput "true" config.enable ./alias-with-priority.nix
checkConfigOutput "true" config.enableAlias ./alias-with-priority.nix
checkConfigOutput "false" config.enable ./alias-with-priority-can-override.nix
checkConfigOutput "false" config.enableAlias ./alias-with-priority-can-override.nix

# submoduleWith

## specialArgs should work
checkConfigOutput "foo" config.submodule.foo ./declare-submoduleWith-special.nix

## shorthandOnlyDefines config behaves as expected
checkConfigOutput "true" config.submodule.config ./declare-submoduleWith-shorthand.nix ./define-submoduleWith-shorthand.nix
checkConfigError 'is not of type `boolean' config.submodule.config ./declare-submoduleWith-shorthand.nix ./define-submoduleWith-noshorthand.nix
checkConfigError 'value is a boolean while a set was expected' config.submodule.config ./declare-submoduleWith-noshorthand.nix ./define-submoduleWith-shorthand.nix
checkConfigOutput "true" config.submodule.config ./declare-submoduleWith-noshorthand.nix ./define-submoduleWith-noshorthand.nix

## submoduleWith should merge all modules in one swoop
checkConfigOutput "true" config.submodule.inner ./declare-submoduleWith-modules.nix
checkConfigOutput "true" config.submodule.outer ./declare-submoduleWith-modules.nix

## Paths should be allowed as values and work as expected
checkConfigOutput "true" config.submodule.enable ./declare-submoduleWith-path.nix

# Check that disabledModules works recursively and correctly
checkConfigOutput "true" config.enable ./disable-recursive/main.nix
checkConfigOutput "true" config.enable ./disable-recursive/{main.nix,disable-foo.nix}
checkConfigOutput "true" config.enable ./disable-recursive/{main.nix,disable-bar.nix}
checkConfigError 'The option .* defined in .* does not exist' config.enable ./disable-recursive/{main.nix,disable-foo.nix,disable-bar.nix}

# Check that imports can depend on derivations
checkConfigOutput "true" config.enable ./import-from-store.nix

# Check attrsOf and lazyAttrsOf. Only lazyAttrsOf should be lazy, and only
# attrsOf should work with conditional definitions
# In addition, lazyAttrsOf should honor an options emptyValue
checkConfigError "is not lazy" config.isLazy ./declare-attrsOf.nix ./attrsOf-lazy-check.nix
checkConfigOutput "true" config.isLazy ./declare-lazyAttrsOf.nix ./attrsOf-lazy-check.nix
checkConfigOutput "true" config.conditionalWorks ./declare-attrsOf.nix ./attrsOf-conditional-check.nix
checkConfigOutput "false" config.conditionalWorks ./declare-lazyAttrsOf.nix ./attrsOf-conditional-check.nix
checkConfigOutput "empty" config.value.foo ./declare-lazyAttrsOf.nix ./attrsOf-conditional-check.nix

cat <<EOF
====== module tests ======
$pass Pass
$fail Fail
EOF

if test $fail -ne 0; then
    exit 1
fi
exit 0
