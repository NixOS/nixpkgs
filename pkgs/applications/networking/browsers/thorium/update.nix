{ lib, writeScript, common-updater-scripts, bash, coreutils, curl, gnused, jq }:

let
  src = ./src.json;
in writeScript "update-thorium" ''
  #!${bash}/bin/bash
  set -eu -o pipefail
  
  PATH=${lib.makeBinPath [ common-updater-scripts coreutils curl gnused jq ]}
  
  latest_tag=$(curl -s https://api.github.com/repos/Alex313031/thorium/releases/latest | jq -r '.tag_name')
  version=$(echo $latest_tag | sed 's/^M//')  # Remove leading 'M' if present
  
  # Check if we already have the latest version
  current_version=$(jq -r '.version' < ${src})
  if [[ "$version" == "$current_version" ]]; then
    echo "Thorium is already at the latest version: $version"
    exit 0
  fi
  
  asset_url="https://github.com/Alex313031/thorium/releases/download/M$version/thorium-browser_$'''{version}_AVX.deb"
  
  # Download the file and compute its hash
  tmp_file=$(mktemp)
  curl -L -o "$tmp_file" "$asset_url"
  sha
''