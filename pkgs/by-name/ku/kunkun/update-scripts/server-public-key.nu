#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell

# Mirrors the key that `packages/tauri-plugins/jarvis/build.rs` embeds with
# `include_bytes!`, which upstream downloads in its `setup.ts`. The object is
# unversioned, so nothing in the tree would change if they rotated it, and
# re-fetching on every update run makes a rotation show up as a diff instead.
const url = 'https://qzehioyfmxlgkeuujwlh.supabase.co/storage/v1/object/public/pub/server_public_key.pem'

let out = $env.FILE_PWD | path dirname | path join generated-data server_public_key.pem

let body = http get --max-time 30sec --raw $url | into binary

let key = $body | decode utf-8 | str trim
let framed = (
  ($key | str starts-with '-----BEGIN PUBLIC KEY-----') and
  ($key | str ends-with '-----END PUBLIC KEY-----')
)
if not $framed {
  error make {msg: $"($url) did not serve a PEM public key"}
}

$body | save --force --raw $out

print -e $"Updated ($out)"
