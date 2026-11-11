#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts jq nix xh

set -eu -o pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nixpkgs_root="$(cd "$script_dir/../../../../" && pwd)"
cd "$nixpkgs_root"

get_download_info() {
  platform="$1"
  os="${platform#*-}"
  arch="${platform%%-*}"

  case "$arch" in
    i686)
      arch="386"
      ;;
    x86_64)
      arch="amd64"
      ;;
    aarch64)
      arch="arm64"
      ;;
    *)
      echo "unsupported architecture in platform: $platform" >&2
      exit 1
      ;;
  esac

  xh --json \
    --ignore-stdin \
    https://update.ngrok-agent.com/check \
    'Accept:application/json; q=1; version=1; charset=utf-8' \
    'Content-Type:application/json; charset=utf-8' \
    app_id=app_c3U4eZcDbjV \
    channel=stable \
    os="$os" \
    goarm= \
    arch="$arch" | jq --raw-output '.release.version + " " + .download_url + " " + .checksum'
}

latest_version=

while read -r platform; do
  read -r version url checksum < <(get_download_info "$platform")

  hash="$(nix hash convert --hash-algo sha256 --to sri "$checksum")"

  if [[ -z "$latest_version" ]]; then
    latest_version="$version"
  elif [[ "$latest_version" != "$version" ]]; then
    echo "mismatched versions detected: $latest_version and $version" >&2
    exit 1
  fi

  update-source-version ngrok "$version" "$hash" "$url" --version-key="version" --ignore-same-version --ignore-same-hash --system="$platform" --source-key="sources.$platform" --file="pkgs/by-name/ng/ngrok/package.nix"
done < <(
  nix eval --json .#ngrok.passthru.platforms | jq --raw-output '.[]'
)

if [[ -z "$latest_version" ]]; then
  echo "failed to determine latest version" >&2
  exit 1
fi

echo "latest  version: $latest_version"
