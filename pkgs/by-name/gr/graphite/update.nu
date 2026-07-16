#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell nix-update curl common-updater-scripts nix

^nix-update graphite --version=branch --version-regex '(0-unstable-.*)'

let pkg = "./pkgs/by-name/gr/graphite/package.nix"
let rev = open $pkg | lines | where ($it | str contains 'rev = "') | first | str trim | parse 'rev = "{rev}";' | get 0.rev

let shader_url = $"https://raw.githubusercontent.com/timon-schelling/graphite-artifacts/refs/heads/main/rev/($rev)/raster_nodes_shaders_entrypoint.wgsl"
let shader_hash = ^nix store prefetch-file --hash-type sha256 $shader_url --json | from json | get hash

let branding = http get $"https://raw.githubusercontent.com/GraphiteEditor/Graphite/($rev)/.branding" | lines
let branding_url = $branding | get 0
let branding_rev = $branding_url | path basename | str replace ".tar.gz" ""
let branding_hash = ^nix store prefetch-file --hash-type sha256 --unpack $branding_url --json | from json | get hash

open $pkg
| str replace --regex 'shaderHash = "[^"]*"' $'shaderHash = "($shader_hash)"'
| str replace --regex 'brandingRev = "[^"]*"' $'brandingRev = "($branding_rev)"'
| str replace --regex 'brandingHash = "[^"]*"' $'brandingHash = "($branding_hash)"'
| save --force $pkg
