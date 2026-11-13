#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl gnugrep gnused pup

set -euo pipefail

latestVersion=$(
  curl -sS https://builds.renode.io \
    | pup 'a text{}' \
    | grep -oE '^renode-[0-9.]+\+[0-9]{8}git[0-9a-f]+\.linux\.tar\.gz$' \
    | sed -E 's/^renode-(([0-9.]+)\+([0-9]{8})git[0-9a-f]+)\.linux\.tar\.gz$/\3 \1/' \
    | sort -k1,1n -k2,2V \
    | tail -n1 \
    | cut -d' ' -f2
)

if [[ -z "$latestVersion" ]]; then
  echo "error: could not find the latest nightly on https://builds.renode.io" >&2
  exit 1
fi

update-source-version renode-unstable-bin "$latestVersion" \
  --file=pkgs/by-name/re/renode-unstable-bin/package.nix \
  --system=x86_64-linux
