#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused coreutils jq nix git
# shellcheck shell=bash

# Scrapes the Oracle Instant Client download pages for the latest release on
# each platform and regenerates sources.json.

set -euo pipefail

sources="$(git rev-parse --show-toplevel)/pkgs/by-name/or/oracle-instantclient/sources.json"

components=(basic sdk sqlplus tools odbc)

# platform -> "<download page> <oracle arch> <suffix>"
declare -A platforms=(
  [x86_64-linux]="linux-x86-64-downloads linux.x64 zip"
  [aarch64-linux]="linux-arm-aarch64-downloads linux.arm64 zip"
  [aarch64-darwin]="macos-arm64-downloads macos.arm64 dmg"
)

result="{}"

for platform in $(printf '%s\n' "${!platforms[@]}" | sort); do
  read -r page arch suffix <<<"${platforms[$platform]}"

  html="$(curl -fsSL -A Mozilla/5.0 "https://www.oracle.com/database/technologies/instant-client/${page}.html")"

  # Pick the newest plain release, skipping the dbru/el9 variants of older series.
  # Sort on the version alone, as the directory names vary in length.
  url="$(
    { grep -oE "https://download\.oracle\.com/otn_software/[a-z]+/instantclient/[0-9]+/instantclient-basic-${arch//./\\.}-[0-9.]+\.${suffix}" <<<"$html" || true; } \
      | sed -E "s|^.*-([0-9.]+)\.${suffix}\$|\1 &|" \
      | sort -uV -k1,1 | tail -1 | cut -d' ' -f2
  )"

  if [[ -z "$url" ]]; then
    echo "No release found for $platform" >&2
    exit 1
  fi

  directory="$(basename "$(dirname "$url")")"
  version="$(basename "$url" ".${suffix}")"
  version="${version#"instantclient-basic-${arch}-"}"

  echo "Updating $platform to $version"

  hashes="{}"
  for component in "${components[@]}"; do
    componentUrl="$(dirname "$url")/instantclient-${component}-${arch}-${version}.${suffix}"
    hash="$(nix-prefetch-url --type sha256 "$componentUrl")"
    hash="$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$hash")"
    hashes="$(jq --arg c "$component" --arg h "$hash" '. + {($c): $h}' <<<"$hashes")"
  done

  result="$(
    jq \
      --arg p "$platform" \
      --arg v "$version" \
      --arg d "$directory" \
      --argjson h "$hashes" \
      '. + {($p): {version: $v, directory: $d, hashes: $h}}' <<<"$result"
  )"
done

echo "$result" >"$sources"
