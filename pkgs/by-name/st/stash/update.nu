#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell prefetch-yarn-deps nix-prefetch-git nix-prefetch

enter ($env.FILE_PWD? | default $env.PWD)

const versionFile = "version.json"

let current = open $versionFile

let latestTag = http get https://api.github.com/repos/stashapp/stash/tags?per_page=1 | get 0
let latestVersion = $latestTag | get name | str substring 1..

if ($current.version == $latestVersion) {
  print --stderr "No new update available"
  exit 0
}

let src = nix-prefetch-git --no-deepClone --rev $"v($latestVersion)"  https://github.com/stashapp/stash | from json

let yarnHash = {
  let hash = prefetch-yarn-deps $"($src.path)/ui/v2.5/yarn.lock" | str trim --right
  nix hash convert --hash-algo sha256 $hash
}

{
  stamp: (date now | format date "%Y-%m-%d %H:%M:%S")
  version: $latestVersion
  gitHash: ($latestTag | get commit.sha | str substring ..7)
  srcHash: ($src | get hash)
  yarnHash: (do $yarnHash)
  vendorHash: (nix-prefetch --option extra-experimental-features flakes $"
    { sha256 }: \(callPackage \(import ./buildGoVendor.nix) {
      pname = "stash";
      src = ($src.path);
      version = "($latestVersion)";
      vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    }).goModules.overrideAttrs \(_: { modSha256 = sha256; })
  ")
}
| to json
| $in + "\n"
| save --force $versionFile

cp --force $"($src.path)/ui/v2.5/package.json" ./package.json

