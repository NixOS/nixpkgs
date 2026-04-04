#!/usr/bin/env nix-shell
#!nix-shell --pure -I nixpkgs=./. -i bash -p bash curl cacert jq nix nix-prefetch

launcherJson=$(curl -s https://launcher.hytale.com/version/release/launcher.json)

function launcherJq() {
  echo "$launcherJson" | jq --raw-output "$@"
}

latestVersion=$(launcherJq '.version')
if [[ $latestVersion == "$UPDATE_NIX_OLD_VERSION" ]]; then
  echo "package is up-to-date"
  exit 0
fi

function selectUrlAndHash() {
  local os="$1"
  local arch="$2"
  # shellcheck disable=SC2016
  launcherJq --arg os "$os" --arg arch "$arch" '[.download_url[$os][$arch].url, .download_url[$os][$arch].sha256] | join(" ")'
}

function prefetch() {
  nix store prefetch-file --json --hash-type sha256 "$@" | jq --raw-output '[.hash, .storePath] | join(" ")'
}

function fetchzipFile() {
  local file="$1"
  shift
  # keep a reference to the store path to keep it in the sandbox
  derivationArgs="{ src = builtins.storePath $(echo -n "$file" | jq -Rsa '.'); }"
  nix-prefetch -I nixpkgs=./. --quiet fetchzip --url "file://$file" --derivationArgs --expr "$derivationArgs" "$@"
}

function update() {
  local system="$1"
  shift
  read -r url expectedHash < <(selectUrlAndHash "$@")
  read -r _zipHash zipPath < <(prefetch --expected-hash "$expectedHash" "$url")
  hash=$(fetchzipFile "$zipPath" --no-stripRoot)

  currentPin="$(dirname "${BASH_SOURCE[0]}")/pin.json"
  newPin=$(mktemp)
  jq --arg ver "$latestVersion" --arg sys "$system" --arg hash "$hash" \
     '.version = $ver | .hashes[$sys] = $hash' \
     "$currentPin" > "$newPin"
  mv "$newPin" "$currentPin"
}

update "x86_64-linux" "linux" "amd64"
update "aarch64-darwin" "darwin" "arm64"
