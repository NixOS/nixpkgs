#! /usr/bin/env nix-shell
#! nix-shell -i nu -p nushell flock gnused -I nixpkgs=.

# This script will add all packages that match the following criteria to the exclusion list:
#   - Is either marked directly or transitively broken.
#   - Has not been updated on hackage in the last 5 years.
#   - Is not listed in the Stackage snapshot.
# hackage2nix will not create expressions for excluded packages.

use std log

let broken_config = "pkgs/development/haskell-modules/configuration-hackage2nix/broken.yaml"
let transitive_broken_config = "pkgs/development/haskell-modules/configuration-hackage2nix/transitive-broken.yaml"
let stackage_config = "pkgs/development/haskell-modules/configuration-hackage2nix/stackage.yaml"
let excluded_config = "pkgs/development/haskell-modules/configuration-hackage2nix/excluded.json"

def main [] {
    let broken = $broken_config | open | get broken-packages
    let transitive_broken = $transitive_broken_config | open | get dont-distribute-packages
    let stackage = $stackage_config | open | get default-package-overrides | parse "{name} {constraint}"

    $broken ++ $transitive_broken
    | where ($it not-in $stackage.name)
    | par-each {|package|
        try {
            let updated = http get $"https://hackage.haskell.org/package/($package)/upload-time" | into datetime
            if $updated < ("5 years ago" | date from-human) {
                log info $"($package): last updated at ($updated)"
                # This is not efficient at all, but will:
                #   - keep comments in broken.yaml
                #   - allow to cancel the script at any time without losing progress
                ^flock -x $broken_config -c $"sed -i -e '/^  - ($package) /d' ($broken_config)"
                ^flock -x $transitive_broken_config -c $"sed -i -e '/^ - ($package)$/d' ($transitive_broken_config)"
                ^flock -x $excluded_config -c $"sed -i -e '/"__insert-target-for-script__"/a\\    "($package)",' ($excluded_config)"
            }
        } catch {|err|
            # "Network failure" happens for 404 responses, for example for versioned attributes like aeson_1_5_6_0
            log warning $"($package): ($err.msg)"
        }
    }

    ^treefmt $excluded_config
}
