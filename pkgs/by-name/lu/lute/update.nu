#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell semver-tool nurl nixfmt common-updater-scripts

# MAINTENANCE NOTES:
# - keep the DEPENDENCIES list in sync with the derivation

let DEPENDENCIES = [
    "uSockets.tune"
    "uWebSockets.tune"
    "luau.tune"
]

let latest_version = http get https://api.github.com/repos/luau-lang/lute/releases
| where prerelease == false
| sort-by created_at
| last

let latest_version_name = $latest_version.tag_name | str trim --char "v" --left
let current_version_name = $env.UPDATE_NIX_OLD_VERSION

if (^semver compare $current_version_name $latest_version_name) != "-1" {
    # same or older version, exit early
    exit 0
}

let package_dir = $env.PWD | path join "pkgs/by-name/lu/lute"

# Update package.nix
^update-source-version lute $latest_version_name

# Update deps.nix
^git clone https://github.com/luau-lang/lute --branch $"v($latest_version_name)" --depth 1
cd lute/extern

let dependencies = (ls | sort-by name) | where $it.name in $DEPENDENCIES | each {|file|
  let tune = open $file.name | from toml | get "dependency"
  let attr_name = $file.name | path parse | get "stem"

  let output = ^nurl $tune.remote $tune.revision --fetcher fetchFromGitHub
  $"{name = \"($attr_name)\"; path = ($output);}"
}

let deps_file = $"{linkFarm, fetchFromGitHub}: linkFarm \"lute-deps\" [($dependencies | str join)]"

$deps_file | ^nixfmt | save $"($package_dir)/deps.nix" --force
