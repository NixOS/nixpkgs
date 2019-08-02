#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq

set -eu -o pipefail

oldVersion="$(nix-instantiate --eval -E "with import ./. {}; slack-theme-black.version or (builtins.parseDrvName slack-theme-black.name).version" | tr -d '"')"
latestSha="$(curl -L -s https://api.github.com/repos/laCour/slack-night-mode/commits\?sha\=master\&since\=${oldVersion} | jq -r '.[0].sha')"

if [ ! "null" = "${latestSha}" ]; then
  latestDate="$(curl -L -s https://api.github.com/repos/laCour/slack-night-mode/commits/${latestSha} | jq '.commit.author.date' | sed 's|"\(.*\)T.*|\1|g')"
  update-source-version slack-theme-black "${latestSha}" --version-key=rev
  update-source-version slack-theme-black "${latestDate}" --ignore-same-hash
  nixpkgs="$(git rev-parse --show-toplevel)"
  default_nix="$nixpkgs/pkgs/applications/networking/instant-messengers/slack/dark-theme.nix"
  git add "${default_nix}"
  git commit -m "slack-theme-black: ${oldVersion} -> ${latestDate}"
else
  echo "slack-theme-black is already up-to-date"
fi
