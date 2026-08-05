#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell

# Mirrors the public Supabase credentials that upstream keeps out of the source
# tree and injects at build time from an unversioned URL. `passthru.updateScript`
# runs this after `nix-update`, so that a rotated key is picked up on the next
# update run instead of surfacing as runtime authentication failures.
const url = 'https://storage.kunkun.sh/env.json'

let out = $env.FILE_PWD | path dirname | path join generated-data env.json

let body = http get --max-time 30sec --raw $url | into binary

let env_json = $body | decode utf-8 | from json
for key in [SUPABASE_URL SUPABASE_ANON_KEY] {
  if ($env_json | get --optional $key | is-empty) {
    error make {msg: $"($url) no longer carries ($key)"}
  }
}

$body | save --force --raw $out

print -e $"Updated ($out)"
