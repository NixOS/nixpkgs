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
    nix-instantiate --timeout 1 -E "$script" -A "$attr" --eval-only --show-trace
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

# Check mkForce without submodules.
set -- config.enable ./declare-enable.nix ./define-enable.nix
checkConfigOutput "true" "$@"
checkConfigOutput "false" "$@" ./define-force-enable.nix
checkConfigOutput "false" "$@" ./define-enable-force.nix

# Check mkForce with option and submodules.
checkConfigError 'attribute .*foo.* .* not found' config.loaOfSub.foo.enable ./declare-loaOfSub-any-enable.nix
checkConfigOutput 'false' config.loaOfSub.foo.enable ./declare-loaOfSub-any-enable.nix ./define-loaOfSub-foo.nix
set -- config.loaOfSub.foo.enable ./declare-loaOfSub-any-enable.nix ./define-loaOfSub-foo-enable.nix
checkConfigOutput 'true' "$@"
checkConfigOutput 'false' "$@" ./define-force-loaOfSub-foo-enable.nix
checkConfigOutput 'false' "$@" ./define-loaOfSub-force-foo-enable.nix
checkConfigOutput 'false' "$@" ./define-loaOfSub-foo-force-enable.nix
checkConfigOutput 'false' "$@" ./define-loaOfSub-foo-enable-force.nix

# Check overriding effect of mkForce on submodule definitions.
checkConfigError 'attribute .*bar.* .* not found' config.loaOfSub.bar.enable ./declare-loaOfSub-any-enable.nix ./define-loaOfSub-foo.nix
checkConfigOutput 'false' config.loaOfSub.bar.enable ./declare-loaOfSub-any-enable.nix ./define-loaOfSub-foo.nix ./define-loaOfSub-bar.nix
set -- config.loaOfSub.bar.enable ./declare-loaOfSub-any-enable.nix ./define-loaOfSub-foo.nix ./define-loaOfSub-bar-enable.nix
checkConfigOutput 'true' "$@"
checkConfigError 'attribute .*bar.* .* not found' "$@" ./define-force-loaOfSub-foo-enable.nix
checkConfigError 'attribute .*bar.* .* not found' "$@" ./define-loaOfSub-force-foo-enable.nix
checkConfigOutput 'true' "$@" ./define-loaOfSub-foo-force-enable.nix
checkConfigOutput 'true' "$@" ./define-loaOfSub-foo-enable-force.nix

# Check mkIf with submodules.
checkConfigError 'attribute .*foo.* .* not found' config.loaOfSub.foo.enable ./declare-enable.nix ./declare-loaOfSub-any-enable.nix
set -- config.loaOfSub.foo.enable ./declare-enable.nix ./declare-loaOfSub-any-enable.nix
checkConfigError 'attribute .*foo.* .* not found' "$@" ./define-if-loaOfSub-foo-enable.nix
checkConfigError 'attribute .*foo.* .* not found' "$@" ./define-loaOfSub-if-foo-enable.nix
checkConfigError 'attribute .*foo.* .* not found' "$@" ./define-loaOfSub-foo-if-enable.nix
checkConfigOutput 'false' "$@" ./define-loaOfSub-foo-enable-if.nix
checkConfigOutput 'true' "$@" ./define-enable.nix ./define-if-loaOfSub-foo-enable.nix
checkConfigOutput 'true' "$@" ./define-enable.nix ./define-loaOfSub-if-foo-enable.nix
checkConfigOutput 'true' "$@" ./define-enable.nix ./define-loaOfSub-foo-if-enable.nix
checkConfigOutput 'true' "$@" ./define-enable.nix ./define-loaOfSub-foo-enable-if.nix

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
set -- config.enable ./declare-enable.nix ./define-enable.nix ./define-loaOfSub-foo.nix
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

# Check loaOf with long list.
checkConfigOutput "1 2 3 4 5 6 7 8 9 10" config.result ./loaOf-with-long-list.nix

# Check loaOf with many merges of lists.
checkConfigOutput "1 2 3 4 5 6 7 8 9 10" config.result ./loaOf-with-many-list-merges.nix

# Check mkAliasOptionModuleWithPriority.
checkConfigOutput "true" config.enable ./alias-with-priority.nix
checkConfigOutput "true" config.enableAlias ./alias-with-priority.nix
checkConfigOutput "false" config.enable ./alias-with-priority-can-override.nix
checkConfigOutput "false" config.enableAlias ./alias-with-priority-can-override.nix

cat <<EOF
====== module tests ======
$pass Pass
$fail Fail
EOF

if test $fail -ne 0; then
    exit 1
fi
exit 0
