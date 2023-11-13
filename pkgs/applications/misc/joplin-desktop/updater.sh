#!/usr/bin/env nix-shell
#!nix-shell -i bash -p wget jq common-updater-scripts
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

new_version="$(wget -qO - "https://api.github.com/repos/laurent22/joplin/releases/latest" | grep -Po '"tag_name": ?"v\K.*?(?=")')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  exit 0
fi

x64linux=("AppImage" "x86_64-linux")
x64darwin=("dmg" "x86_64-darwin")
aarch64darwin=("arm64" "aarch64-darwin")
suffix=("x64linux" "x64darwin" "aarch64darwin")

for platform in "${suffix[@]}"; do
  declare -n array="$platform"
  arch=$(echo ${array[1]} | cut -d '-' -f1)
  dlUrl="$(wget -qO - 'https://api.github.com/repos/laurent22/joplin/releases/latest' | jq -r '.assets[] | select (.name|test("${array[0]}")) | .browser_download_url')"
  latestSha="$(nix-prefetch-url $dlUrl)"
  update-source-version joplin-desktop "${new_version//v}" "$latestSha" --system=${array[1]}
done
