#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell

# Mirrors the animation that `apps/desktop/setup.ts` downloads for
# `dance.svelte` to import. The endpoint is unversioned, so re-fetch on every
# update run rather than letting the copy drift silently out of date. It is
# saved verbatim, the derivation is what compresses it.
const url = 'https://dance.kunkun.sh/api/data'

let out = $env.FILE_PWD | path dirname | path join generated-data dance.json

let body = http get --max-time 30sec --raw $url | into binary

let animation = $body | decode utf-8 | from json
for key in [fps frames] {
  if ($animation | get --optional $key | is-empty) {
    error make {msg: $"($url) no longer carries ($key)"}
  }
}

$body | save --force --raw $out

print -e $"Updated ($out)"
