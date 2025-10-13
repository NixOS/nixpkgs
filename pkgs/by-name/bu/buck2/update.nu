#!/usr/bin/env nix-shell
#! nix-shell -I ./.
#! nix-shell -i nu
#! nix-shell -p nushell nix

const ARCHES = [
  { name: "x86_64-linux", target: "x86_64-unknown-linux-gnu" },
  { name: "x86_64-darwin", target: "x86_64-apple-darwin" },
  { name: "aarch64-linux", target: "aarch64-unknown-linux-gnu" },
  { name: "aarch64-darwin", target: "aarch64-apple-darwin" },
];

const MANIFEST = "pkgs/by-name/bu/buck2/hashes.json"

def main [] {
  let version = http get "https://api.github.com/repos/facebook/buck2/releases"
    | sort-by -r created_at
    | where prerelease == true and name != "latest"
    | first
    | get name

  let preludeHash = http get $"https://github.com/facebook/buck2/releases/download/($version)/prelude_hash" | decode | str trim
  let preludeFod = run-external "nix" "--extra-experimental-features" "nix-command" "store" "prefetch-file" "--json" $"https://github.com/facebook/buck2-prelude/archive/($preludeHash).tar.gz" | from json | get hash

  print $"Newest version: ($version)"
  print $"Newest prelude hash: ($preludeHash)"

  let hashes = $ARCHES | par-each {
    |arch|

    {
      $arch.name: {
        "buck2": (run-external "nix" "--extra-experimental-features" "nix-command" "store" "prefetch-file" "--json" $"https://github.com/facebook/buck2/releases/download/($version)/buck2-($arch.target).zst" | from json | get hash),
        "rust-project": (run-external "nix" "--extra-experimental-features" "nix-command" "store" "prefetch-file" "--json" $"https://github.com/facebook/buck2/releases/download/($version)/rust-project-($arch.target).zst" | from json | get hash),
      }
    }
  } | reduce { |val, accum| $accum | merge $val }

  let new_manifest = $hashes
    | insert "version" $version
    | insert "preludeGit" $preludeHash
    | insert "preludeFod" $preludeFod

  $new_manifest
  | to json
  | append "\n"
  | str join
  | save -f $MANIFEST
}
