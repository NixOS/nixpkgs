#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell common-updater-scripts gnused

def main [--lts = false, --regex: string] {
  let attr = $"incus(if $lts {"-lts"})"
  let file = $"(pwd)/pkgs/by-name/in/incus/(if $lts { "lts" } else { "package" }).nix"

  let tags = list-git-tags --url=https://github.com/lxc/incus | lines | sort --natural | str replace v ''
  let latest_tag = if $regex == null { $tags } else { $tags | find --regex $regex } | last
  let current_version = nix eval --raw -f default.nix $"($attr).version" | str trim

  if $latest_tag != $current_version {
    print $"Updating: new ($latest_tag) != old ($current_version)"
    update-source-version $attr $latest_tag $"--file=($file)"

    let oldVendorHash = nix-instantiate . --eval --strict -A $"($attr).goModules.drvAttrs.outputHash" --json | from json
    let checkBuild = do { nix-build -A $"($attr).goModules" } | complete
    let vendorHash = $checkBuild.stderr | lines | str trim | find --regex 'got:[[:space:]]*sha256' | split row ' ' | last

    if $vendorHash != null {
      open $file | str replace $oldVendorHash $vendorHash | save --force $file
    } else {
      print $checkBuild.stderr
      exit 1
    }
  }

  {"lts?": $lts, before: $current_version, after: $latest_tag}
}
