#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix curl gnused -I nixpkgs=.
# shellcheck shell=bash

# On Hackage every package description shows a category "Distributions" which
# lists a "NixOS" version.
# This script uploads a csv to hackage which will update the displayed versions
# based on the current versions in nixpkgs. This happens with a simple http
# request.

# For authorization you just need to have any valid hackage account. This
# script uses the `username` and `password-command` field from your
# ~/.cabal/config file.

# e.g. username: maralorn
#      password-command: pass hackage.haskell.org (this can be any command, but not an arbitrary shell expression. Like cabal we only read the first output line and ignore the rest.)
# Those fields are specified under `upload` on the `cabal` man page.

package_list="$(nix-build -A haskell.package-list)/nixos-hackage-packages.csv"
username=$(grep "^username:" ~/.cabal/config | sed "s/^username: //")
password_command=$(grep "^password-command:" ~/.cabal/config | sed "s/^password-command: //")
curl -u "$username:$($password_command | head -n1)" --digest -H "Content-type: text/csv" -T "$package_list" http://hackage.haskell.org/distro/NixOS/packages.csv
echo
