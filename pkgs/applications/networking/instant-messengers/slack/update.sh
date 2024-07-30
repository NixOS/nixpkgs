#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl gnused

set -eou pipefail

latest_linux_version=$(curl -L --silent https://slack.com/downloads/linux | sed -n 's/.*Version \([0-9\.]\+\).*/\1/p')
latest_mac_version=$(curl -L --silent https://slack.com/downloads/mac | sed -n 's/.*Version \([0-9\.]\+\).*/\1/p')

nixpkgs="$(git rev-parse --show-toplevel)"
slack_nix="$nixpkgs/pkgs/applications/networking/instant-messengers/slack/default.nix"
nixpkgs_linux_version=$(cat "$slack_nix" | sed -n 's/.*x86_64-linux-version = \"\([0-9\.]\+\)\";.*/\1/p')
nixpkgs_mac_version=$(cat "$slack_nix" | sed -n 's/.*x86_64-darwin-version = \"\([0-9\.]\+\)\";.*/\1/p')
nixpkgs_mac_arm_version=$(cat "$slack_nix" | sed -n 's/.*aarch64-darwin-version = \"\([0-9\.]\+\)\";.*/\1/p')

if [[ "$nixpkgs_linux_version" == "$latest_linux_version" && \
      "$nixpkgs_mac_version" == "$latest_mac_version" && \
      "$nixpkgs_mac_arm_version" == "$latest_mac_version" ]]; then
  echo "nixpkgs versions are all up to date!"
  exit 0
fi

linux_url="https://downloads.slack-edge.com/desktop-releases/linux/x64/${latest_linux_version}/slack-desktop-${latest_linux_version}-amd64.deb"
mac_url="https://downloads.slack-edge.com/desktop-releases/mac/universal/${latest_mac_version}/Slack-${latest_mac_version}-macOS.dmg"
mac_arm_url="https://downloads.slack-edge.com/desktop-releases/mac/arm64/${latest_mac_version}/Slack-${latest_mac_version}-macOS.dmg"
linux_sha256=$(nix-prefetch-url ${linux_url})
mac_sha256=$(nix-prefetch-url ${mac_url})
mac_arm_sha256=$(nix-prefetch-url ${mac_arm_url})

sed -i "s/x86_64-linux-version = \".*\"/x86_64-linux-version = \"${latest_linux_version}\"/" "$slack_nix"
sed -i "s/x86_64-darwin-version = \".*\"/x86_64-darwin-version = \"${latest_mac_version}\"/" "$slack_nix"
sed -i "s/aarch64-darwin-version = \".*\"/aarch64-darwin-version = \"${latest_mac_version}\"/" "$slack_nix"
sed -i "s/x86_64-linux-sha256 = \".*\"/x86_64-linux-sha256 = \"${linux_sha256}\"/" "$slack_nix"
sed -i "s/x86_64-darwin-sha256 = \".*\"/x86_64-darwin-sha256 = \"${mac_sha256}\"/" "$slack_nix"
sed -i "s/aarch64-darwin-sha256 = \".*\"/aarch64-darwin-sha256 = \"${mac_arm_sha256}\"/" "$slack_nix"

if ! nix-build -A slack "$nixpkgs" --arg config '{ allowUnfree = true; }'; then
  echo "The updated slack failed to build."
  exit 1
fi

echo "Successfully updated"
echo "slack: $nixpkgs_linux_version -> $latest_linux_version"
