#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq common-updater-scripts

set -eux

nixpkgs="$PWD"

attrPath="retrom"
file="pkgs/by-name/${attrPath:0:2}/$attrPath/package.nix"

retromReleaseUrl="https://api.github.com/repos/JMBeresford/retrom/releases/latest"
retromRelease=$(curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} $retromReleaseUrl)

latestVersion=$(echo "$retromRelease" | jq -r ".tag_name")
latestVersion="${latestVersion:1}" # remove first char 'v'

oldVersion=$(nix eval --raw -f "$nixpkgs" $attrPath.version)

if [[ "$oldVersion" == "$latestVersion" ]]; then
    echo "[]"
    exit 0
fi

update-source-version $attrPath "$latestVersion"

nix_get_hash() {
  (nix build --no-link -f "$nixpkgs" "$@" 2>&1 || true) | awk '/got:/{ print $2 }'
}

nix_eval() {
  nix eval --raw -f "$nixpkgs" "$@"
}

escape_sed() {
  printf '%s' "$1" | sed 's/\//\\\//g'
}

update_hash() {
  local attr="$1"
  local buildAttr="$2"

  local fakeHash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

  local oldHash
  oldHash=$(escape_sed "$(nix_eval "$attr")")

  sed -i "s/$oldHash/$fakeHash/" "$file"

  local newHash
  newHash=$(escape_sed "$(nix_get_hash "$buildAttr")")

  if [[ -z "$newHash" ]]; then
    echo "no $buildAttr found" >&2
    exit 1
  fi

  sed -i "s/$fakeHash/$newHash/" "$file"
}

update_hash $attrPath.pnpmDeps.outputHash $attrPath.pnpmDeps
update_hash $attrPath.cargoHash $attrPath.cargoDeps

jq -n \
  --arg attrPath "$attrPath" \
  --arg oldVersion "$oldVersion" \
  --arg newVersion "$latestVersion" \
  --arg file "$nixpkgs/$file" \
  '[{
    attrPath: $attrPath,
    oldVersion: $oldVersion,
    newVersion: $newVersion,
    files: [$file]
  }]'
