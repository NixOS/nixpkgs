#!/usr/bin/env nix-shell
#! nix-shell -I ./.
#! nix-shell -i nu
#! nix-shell -p nushell nix

const PACKAGE = './pkgs/by-name/id/idris2/package.nix'

def main [] {
  let tag = http get "https://api.github.com/repos/idris-lang/Idris2/releases"
    | sort-by -r created_at
    | first
    | get tag_name

  print $"Newest version: ($tag)"

  let hash = run-external "nix" "flake" "prefetch" "--json" $"github:idris-lang/Idris2/($tag)"
    | from json
    | get hash

  let current_hash = nix eval -f ./. idris2.unwrapped.src.outputHash --json | from json
  let current_version = nix eval -f ./. idris2.version --json | from json

  $PACKAGE
    | open
    | str replace $current_version ($tag | str trim -c 'v')
    | str replace $current_hash $hash
    | save -f $PACKAGE
}
