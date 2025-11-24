#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused gawk

set -e

dirname="$(dirname "$0")"
currentVersion=$(nix-shell -p jq --run "jq -r '.version' '$dirname/sources.json'")

owner=Floorp-Projects
repo=Floorp

release=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/latest")

latestTag=$(jq -r ".tag_name" <<<"$release")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

# Check if version is the same but hashes might have changed
if [[ "$currentVersion" == "$latestVersion" ]]; then
    # Compare all platform hashes to detect asset updates
    currentSources=$(jq -c '.sources | to_entries | sort_by(.key) | map(.value.sha256)' "$dirname/sources.json")
    latestSources=$(jq -c '
      .assets
      | map(select(.name | (endswith(".tar.xz") or endswith(".dmg"))))
      | map({url: .browser_download_url, sha256: (.digest | split(":").[1])})
      | map(
          if .url | contains("linux-aarch64") then {key: "aarch64-linux", value: .sha256}
          elif .url | contains("linux-x86_64") then {key: "x86_64-linux", value: .sha256}
          elif .url | contains("macOS-universal") then [{key: "aarch64-darwin", value: .sha256}, {key: "x86_64-darwin", value: .sha256}]
          else null end
        )
      | flatten
      | map(select(. != null))
      | sort_by(.key)
      | map(.value)
    ' <<<"$release")

    if [[ "$currentSources" == "$latestSources" ]]; then
        echo "Floorp is up-to-date: ${currentVersion}"
        exit 0
    else
        echo "Floorp ${currentVersion} has updated assets"
    fi
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
          elif .url | contains("linux-x86_64") then
            {key: "x86_64-linux", value: .}
          elif .url | contains("macOS-universal") then
            [{key: "aarch64-darwin", value: .}, {key: "x86_64-darwin", value: .}]
          else null end
        )
      | flatten
      | map(select(. != null))
      | from_entries
    )
  }
' <<<"$release" > "$dirname/sources.json"
