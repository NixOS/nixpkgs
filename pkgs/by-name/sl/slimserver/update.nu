#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell common-updater-scripts

# get latest tag, but drop versions 10.0 tags since they are 10+ years old
let latest_tag = list-git-tags --url=https://github.com/LMS-Community/slimserver | lines | find --invert 10.0 | sort --natural | last

let current_version = nix eval --raw -f default.nix slimserver | str trim

if $latest_tag != $current_version {
  update-source-version slimserver $latest_tag $"--file=(pwd)/pkgs/by-name/sl/slimserver/package.nix"
  {before: $current_version, after: $latest_tag}
} else {
  "No new version"
}
