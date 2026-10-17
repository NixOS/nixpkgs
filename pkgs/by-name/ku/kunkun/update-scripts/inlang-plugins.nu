#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell nix

# Resolves the inlang modules referenced by
# `apps/desktop/project.inlang/settings.json` and records a concrete URL and
# hash for each one in `inlang-plugins.json`.
#
# The module list is read from the source, so additions and removals made
# upstream are picked up automatically.

# Captures:
#   pkg:  package name, either @scope/name or name
#   ver:  version, tag, or range, such as latest or 4
#   path: optional package subpath, such as /dist/index.js
const jsdelivr = '^https://cdn\.jsdelivr\.net/npm/(?<pkg>@[^/]+/[^@/]+|[^@/]+)@(?<ver>[^/]+)(?<path>/.*)?$'

let out = $env.FILE_PWD | path dirname | path join generated-data inlang-plugins.json

let src = ^nix-build -A $"($env.UPDATE_NIX_ATTR_PATH).src" --no-out-link | str trim

let plugins = (
  open $"($src)/apps/desktop/project.inlang/settings.json"
  | get modules
  | each {|remote|
      let parsed = $remote | parse --regex $jsdelivr

      # This script can only resolve jsDelivr npm URLs to a concrete version.
      # For anything else it has to be updated, so stop rather than record a
      # hash for a possible unstable URL.
      let url = if ($parsed | is-empty) {
        error make {msg: $"cannot pin ($remote): not a jsdelivr npm URL"}
      } else {
        let module = $parsed | first
        let version = http get --max-time 30sec $"https://cdn.jsdelivr.net/npm/($module.pkg)@($module.ver)/package.json" | get version
        let subpath = $module.path | default ""
        $"https://cdn.jsdelivr.net/npm/($module.pkg)@($version)($subpath)"
      }

      print -e $"($remote)\n  pinned to ($url)"
      let hash = ^nix store prefetch-file --hash-type sha256 --json $url | from json | get hash

      {$remote: {url: $url, hash: $hash}}
    }
  | into record
)

$plugins
| to json
| $"($in)\n"
| save --force $out

print -e $"Updated ($out)"
