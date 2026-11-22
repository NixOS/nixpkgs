#!/usr/bin/env nix-shell
#! nix-shell -I ./.
#! nix-shell -i nu
#! nix-shell -p nushell nix

const ARCHES = [
  { name: "x86_64-linux", target: "x86_64-unknown-linux-gnu" },
  { name: "aarch64-linux", target: "aarch64-unknown-linux-gnu" },
  { name: "aarch64-darwin", target: "aarch64-apple-darwin" },
];
const BINARIES = ["buck2", "rust-project", "starlark_fmt"]

const MANIFEST = "pkgs/by-name/bu/buck2/hashes.json"

def main [] {
  let version = http get "https://api.github.com/repos/facebook/buck2/releases"
    | sort-by -r created_at
    | where prerelease == true and name != "latest"
    | first
    | get name

  let preludeHash = http get $"https://github.com/facebook/buck2/releases/download/($version)/prelude_hash" | decode | str trim
  let preludeFod = prefetch-hash $"https://github.com/facebook/buck2-prelude/archive/($preludeHash).tar.gz"

  print $"Newest version: ($version)"
  print $"Newest prelude hash: ($preludeHash)"

  let json = $ARCHES
    | par-each { |arch|
      {
        $arch.name: (
          $BINARIES | each { |binary|
            { $binary: (prefetch-hash $"https://github.com/facebook/buck2/releases/download/($version)/($binary)-($arch.target).zst") }
          } | into record
        )
      }
    }
    | into record
    | sort # keep diffs minimal
    | insert "version" $version
    | insert "preludeGit" $preludeHash
    | insert "preludeFod" $preludeFod
    | to json

  $json + "\n" | save -f $MANIFEST
}

def prefetch-hash [url: string]: nothing -> string {
  nix --extra-experimental-features nix-command store prefetch-file --json $url | from json | get hash
}
