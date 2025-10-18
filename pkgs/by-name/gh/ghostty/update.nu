#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell nixfmt common-updater-scripts

let latest = ^list-git-tags --url=https://github.com/ghostty-org/ghostty
  | lines
  | sort --natural
  | last
  | str trim --left --char "v"

let current = ^nix-instantiate --eval -A ghostty.version | str trim -c '"'

if $latest == $current {
  print "Up to date!"
  exit
}

print $"Updating Ghostty: ($current) -> ($latest)"

^update-source-version ghostty $latest --file=./pkgs/by-name/gh/ghostty-unwrapped/package.nix

# Update deps.nix
http get $"https://raw.githubusercontent.com/ghostty-org/ghostty/refs/tags/v($latest)/build.zig.zon.nix"
  | ^nixfmt
  | save -f ./pkgs/by-name/gh/ghostty-unwrapped/deps.nix

# In extraordinary cases the DMG might take a while to be notarized by Apple
# and so it's possible for a Git tag to have no corresponding notarized DMG download.
# Don't fail here if that happens.
try {
  ^update-source-version ghostty-bin $latest --file=./pkgs/by-name/gh/ghostty-bin/package.nix
} catch {
  print "Failed to update bin package (is the DMG file uploaded yet?)"
}

