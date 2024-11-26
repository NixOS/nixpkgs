#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts jq

# shellcheck disable=SC1008

set -eu -o pipefail

latestVersion=$(curl https://api.github.com/repos/ProtonMail/inbox-desktop/releases/latest | jq -r '.tag_name')

declare -A platforms
platforms[x86_64-linux]="amd64"
platforms[x86_64-darwin]="universal"

for platform in "${!platforms[@]}"
do
  arch=${platforms[$platform]}
  os=$(echo "$platform" | cut -d "-" -f2)

  if [[ "$os" == "linux" ]]; then
    downloadUrl="https://github.com/ProtonMail/inbox-desktop/releases/download/${latestVersion}/proton-mail_${latestVersion}_${arch}.deb"
  else
    downloadUrl="https://github.com/ProtonMail/inbox-desktop/releases/download/${latestVersion}/Proton.Mail-${os}-${arch}-${latestVersion}.zip"
  fi
  echo "$downloadUrl"

  latestSha=$(nix store prefetch-file "$downloadUrl" --json | jq -r '.hash')

  update-source-version "protonmail-desktop" "$latestVersion" "$latestSha" --system="$platform" --ignore-same-version --file=./pkgs/by-name/pr/protonmail-desktop/package.nix
done
