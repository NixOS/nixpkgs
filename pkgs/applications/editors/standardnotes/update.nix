{ writeScript
, lib, curl, runtimeShell, jq, coreutils, moreutils, nix, gnused }:

writeScript "update-standardnotes" ''
  #!${runtimeShell}
  PATH=${lib.makeBinPath [ jq curl nix coreutils moreutils gnused ]}

  set -euo pipefail
  set -x

  tmpDir=$(mktemp -d)
  srcJson=pkgs/applications/editors/standardnotes/src.json
  jsonPath="$tmpDir"/latest

  oldVersion=$(jq -r .version < "$srcJson")

  curl https://api.github.com/repos/standardnotes/app/releases/latest > "$jsonPath"

  tagName=$(jq -r .tag_name < "$jsonPath")

  if [[ ! "$tagName" =~ "desktop" ]]; then
    echo "latest release '$tagName' not a desktop release"
    exit 1
  fi

  newVersion=$(jq -r .tag_name < "$jsonPath" | sed s,@standardnotes/desktop@,,g)

  if [[ "$oldVersion" == "$newVersion" ]]; then
    echo "version did not change"
    exit 0
  fi

  function getDownloadUrl() {
    jq -r ".assets[] | select(.name==\"standard-notes-$newVersion-$1.AppImage\") | .browser_download_url" < "$jsonPath"
  }

  function setJsonKey() {
    jq "$1 = \"$2\"" "$srcJson" | sponge "$srcJson"
  }

  function updatePlatform() {
    nixPlatform="$1"
    upstreamPlatform="$2"
    url=$(getDownloadUrl "$upstreamPlatform")
    hash=$(nix-prefetch-url "$url" --type sha512)
    sriHash=$(nix hash to-sri --type sha512 $hash)
    setJsonKey .appimage[\""$nixPlatform"\"].url "$url"
    setJsonKey .appimage[\""$nixPlatform"\"].hash "$sriHash"
  }

  updatePlatform x86_64-linux linux-x86_64
  updatePlatform aarch64-linux linux-arm64
  setJsonKey .version "$newVersion"
''
