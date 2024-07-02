#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell prefetch-yarn-deps nix-prefetch-git nix-prefetch

const versionFile = "version.json"

def main [] {
  enter ($env.FILE_PWD? | default $env.PWD)

  let current = open $versionFile

  let latest = http get https://api.github.com/repos/stashapp/stash/tags?per_page=1 | get 0
  let version = $latest | get name | str substring 1..

  if ($current.version == $version) {
    print "No new update available"
    exit 0
  }

  let src = nix-prefetch-git --no-deepClone --rev $"v($version)"  https://github.com/stashapp/stash | from json


  let yarnHash = {
    let hash = prefetch-yarn-deps $"($src.path)/ui/v2.5/yarn.lock" | str trim --right
    nix hash convert --hash-algo sha256 $hash
  }

  let new = {
    stamp: (date now | format date "%Y-%m-%d %H:%M:%S")
    version: $version
    gitHash: ($latest | get commit.sha | str substring ..7)
    srcHash: ($src | get hash)
    yarnHash: (do $yarnHash)
    vendorHash: $current.vendorHash
  }

  $new | save --force $versionFile

  cp --force $"($src.path)/ui/v2.5/package.json" ./package.json

  $new | merge {
    vendorHash: (nix-prefetch --option extra-experimental-features flakes $"
      { sha256 }: \(callPackage \(import ./buildGoVendor.nix) {
        pname = "stash";
        src = ($src.path);
      }).goModules.overrideAttrs \(_: { modSha256 = sha256; })
    ")
  } | if ($in.vendorHash | is-empty) { exit 1 } else { $in | save --force $versionFile }

  "\n" | save --append $versionFile
}
