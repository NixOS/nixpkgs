#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils common-updater-scripts
set -eu -o pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; code-cursor.version or (lib.getVersion code-cursor)" | tr -d '"')

declare -A platforms=( [x86_64-linux]='linux-x64' [aarch64-linux]='linux-arm64' [x86_64-darwin]='darwin-x64' [aarch64-darwin]='darwin-arm64' )
declare -A updates=( )
first_version=""

for platform in ${!platforms[@]}; do
    api_platform=${platforms[$platform]}
    result=$(curl -s "https://api2.cursor.sh/updates/api/download/stable/$api_platform/cursor")
    version=$(echo $result | jq -r '.version')
    if [[ "$version" == "$currentVersion" ]]; then
      exit 0
    fi
    if [[ -z "$first_version" ]]; then
      first_version=$version
      first_platform=$platform
    elif [[ "$version" != "$first_version" ]]; then
      >&2 echo "Multiple versions found: $first_version ($first_platform) and $version ($platform)"
      exit 1
    fi
    url=$(echo $result | jq -r '.downloadUrl')
    # Exits with code 22 if not downloadable
    curl --output /dev/null --silent --head --fail "$url"
    updates+=( [$platform]="$result" )
done

# Install updates
for platform in ${!updates[@]}; do
  result=${updates[$platform]}
  version=$(echo $result | jq -r '.version')
  url=$(echo $result | jq -r '.downloadUrl')
  source=$(nix-prefetch-url "$url" --name "cursor-$version")
  hash=$(nix-hash --to-sri --type sha256 "$source")
  update-source-version code-cursor $version $hash "$url" --system=$platform --ignore-same-version --source-key="sources.$platform"
done
