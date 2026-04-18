#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell semver-tool nurl nixfmt

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

let file_path = $env.PWD | path join "pkgs/by-name/lu/lute/package.nix"
let file_text = open $file_path --raw | decode utf-8

^git clone https://github.com/luau-lang/lute --branch $"v($latest_version_name)" --depth 1
cd lute/extern

# Fetch Lute itself first
let lute = do {
  let output = ^nurl "https://github.com/luau-lang/lute" $"v($latest_version_name)" --fetcher fetchFromGitHub --overwrite-str name "lute" --overwrite-str tag "v${finalAttrs.version}"
  $"\(($output)\)\n"
}

let dependencies = (ls | sort-by name) | each {|file|
  let tune = open $file.name | from toml | get "dependency"
  let attr_name = $file.name | path parse | get "stem"

  let output = ^nurl $tune.remote $tune.revision --fetcher fetchFromGitHub --overwrite-str name $attr_name
  $"\(($output)\)\n"
}

let new_sources = ($lute | str join) + ($dependencies | str join)
mut new_file = $file_text | str replace --regex "###_SOURCES_START_###(.|\n)+###_SOURCES_END_###" $"###_SOURCES_START_###\n($new_sources)###_SOURCES_END_###"
$new_file = $new_file | str replace --regex "version = (.+);" $"version = \"($latest_version_name)\";";

$new_file | ^nixfmt | save $file_path --force
