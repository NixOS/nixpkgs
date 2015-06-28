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
    nix-instantiate --timeout 1 -E "$script" -A "$attr" --eval-only
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

# Check _module.args.
checkConfigOutput "true" config.enable ./declare-enable.nix ./custom-arg-define-enable.nix

# Check _module.check.
set -- config.enable ./declare-enable.nix ./define-enable.nix ./define-loaOfSub-foo.nix
checkConfigError 'The option .* defined in .* does not exist.' "$@"
checkConfigOutput "true" "$@" ./define-module-check.nix

cat <<EOF
====== module tests ======
$pass Pass
$fail Fail
EOF

if test $fail -ne 0; then
    exit 1
fi
exit 0
