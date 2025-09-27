#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused gawk

set -e

dirname="$(dirname "$0")"
currentVersion=$(nix eval --raw -f . floorp-bin-unwrapped.version)

owner=Floorp-Projects
repo=Floorp

release=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/latest")

latestTag=$(jq -r ".tag_name" <<<"$release")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Floorp is up-to-date: ${currentVersion}"
    exit 0
fi

jq '
  {
    version: .tag_name[1:],
    sources: (
      .assets
      | map(
          select(.name | (endswith(".tar.xz") or endswith(".dmg")))
            | {url: .browser_download_url, sha256: (.digest | split(":").[1])}
        )
      | map(
          if .url | contains("linux-aarch64") then
            {key: "aarch64-linux", value: .}
          elif .url | contains("linux-amd64") then
            {key: "x86_64-linux", value: .}
          elif .url | contains("macOS-universal") then
            [{key: "aarch64-darwin", value: .}, {key: "x86_64-darwin", value: .}]
          else null end
        )
      | flatten
      | from_entries
    )
  }
' <<<"$release" > "$dirname/sources.json"
