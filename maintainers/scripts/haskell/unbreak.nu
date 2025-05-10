#! /usr/bin/env nix-shell
#! nix-shell -i nu -p nushell flock gnused -I nixpkgs=.

# This script tests to build all packages listed in broken.yaml, expecting a build failure.
# It will remove all packages that build fine from the list.

# Attention: For unknown reasons, the script can't be easily cancelled and needs to be killed manually if it shouldn't run to completion.

use std log

let broken_config = "pkgs/development/haskell-modules/configuration-hackage2nix/broken.yaml"

def is-broken [package : string]: nothing -> bool {
    let res = with-env { NIXPKGS_ALLOW_BROKEN: "1" } {
        # rather high timeout of half an hour, just to prevent never-ending builds
        ^nix-build --no-out-link -j 1 --cores 1 --timeout 1800 -A $"haskellPackages.($package)" | complete
    }
    if $res.exit_code == 0 {
      log warning $"($package) is not broken anymore!"
      return false
    } else {
      log info $"($package) is still broken."
      log debug $"($package) build log:\n($res.stderr)"
      return true
    }
}

def main [] {
    $broken_config | open | get broken-packages
      | par-each {|package| if not (is-broken $package) { ^flock -x $broken_config -c $"sed -i -e '/^  - ($package) /d' ($broken_config)" }}
}
