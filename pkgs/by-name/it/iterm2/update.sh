#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl coreutils common-updater-scripts
set -eu -o pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; iterm2.version or (lib.getVersion iterm2)" | tr -d '"')

downloadUrl=$(
  curl -sL "https://iterm2.com/downloads.html" |
  grep -o -E 'href="[^"]*iTerm2[^"]*\.zip"' |
  sed 's/href="//;s/"//' |
  head -1
)

if [[ -z "$downloadUrl" ]]; then
  echo >&2 "Failed to extract download url from iTerm2 downloads page"
  exit 1
fi

version=$(echo "$downloadUrl" | sed -E '
  s/.*iTerm2-?//    # Remove iTerm2 link prefix from download url
  s/[vV]//          # Remove version "v" prefix
  s/\.zip$//        # Remove .zip extension
  s/_/./g           # Convert underscores to dots
')

# iterm2 is already up to date
if [[ "$version" == "$currentVersion" ]]; then
  exit 0
fi

# Update package version
#
source=$(nix-prefetch-url "$downloadUrl" --unpack --name "iterm2-$version")
hash=$(nix-hash --to-sri --type sha256 "$source")

update-source-version iterm2 $version $hash --ignore-same-version --ignore-same-hash
