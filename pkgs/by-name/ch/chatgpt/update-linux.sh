#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl coreutils common-updater-scripts
set -euo pipefail

packages_url='https://persistent.oaistatic.com/codex-app-prod/linux/deb/dists/stable/main/binary-amd64/Packages'
read -r version filename digest < <(
  curl --fail --silent --show-error --location "$packages_url" |
    awk '
      /^Package: / { matched = ($2 == "chatgpt") }
      matched && /^Version: / { version = $2 }
      matched && /^Filename: / { filename = $2 }
      matched && /^SHA256: / { digest = $2 }
      /^$/ {
        if (matched && version != "" && filename != "" && digest != "")
          print version, filename, digest
        matched = 0; version = ""; filename = ""; digest = ""
      }
      END {
        if (matched && version != "" && filename != "" && digest != "")
          print version, filename, digest
      }
    ' | sort -V -k1,1 | tail -1
)

[[ "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]] || exit 1
[[ "$filename" == "pool/main/c/chatgpt/chatgpt_${version}_amd64.deb" ]] || exit 1
[[ "$digest" =~ ^[[:xdigit:]]{64}$ ]] || exit 1

hash="$(nix hash convert --hash-algo sha256 --to sri "$digest")"
update-source-version chatgpt "$version" "$hash"
