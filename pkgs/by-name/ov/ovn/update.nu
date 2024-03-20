#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell common-updater-scripts

def main [--lts = false, --regex: string] {
  let tags = list-git-tags --url=https://github.com/ovn-org/ovn | lines | sort --natural | str replace v ''

  let latest_tag = if $regex == null { $tags } else { $tags | find --regex $regex } | last
  let current_version = nix eval --raw -f default.nix $"ovn(if $lts {"-lts"}).version" | str trim

  if $latest_tag != $current_version {
    if $lts {
      update-source-version ovn-lts $latest_tag $"--file=(pwd)/pkgs/by-name/ov/ovn/lts.nix"
    } else {
      update-source-version ovn $latest_tag $"--file=(pwd)/pkgs/by-name/ov/ovn/package.nix"
    }
  }

  {"lts?": $lts, before: $current_version, after: $latest_tag}
}
