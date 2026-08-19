#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl yq

old_version="$(nix-instantiate --raw --eval -A deno.version)"

nix-update deno

new_version="$(nix-instantiate --raw --eval -A deno.version)"

if [ "$old_version" = "$new_version" ]; then
  echo "No deno update, nothing to do"
  exit 0
fi

new_v8_version="$(curl -sL "https://raw.githubusercontent.com/denoland/deno/refs/tags/v$new_version/Cargo.lock" | \
  tomlq -r ".package[] | select(.name == \"v8\") | .version")"

nix-update deno.librusty_v8 "--version=$new_v8_version"
