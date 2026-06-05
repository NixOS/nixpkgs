#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell nix-update curl common-updater-scripts nix

^nix-update graphite --version=branch --version-regex '(0-unstable-.*)'

let pkg = "./pkgs/by-name/gr/graphite/package.nix"
let rev = (open $pkg | lines | where ($it | str contains 'rev = "') | first | str trim | parse 'rev = "{rev}";' | get 0.rev)
let meta = (http get $"https://raw.githubusercontent.com/GraphiteEditor/Graphite/($rev)/.branding" | lines)
let branding_rev = ($meta | get 0 | path basename | str replace ".tar.gz" "")
let branding_hash = (^nix hash convert --to sri --hash-algo sha256 ($meta | get 1) | str trim)
open $pkg
| str replace --regex 'brandingRev = "[^"]*"' $'brandingRev = "($branding_rev)"'
| str replace --regex 'brandingHash = "[^"]*"' $'brandingHash = "($branding_hash)"'
| save --force $pkg
