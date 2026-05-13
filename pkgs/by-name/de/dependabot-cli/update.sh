#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq gh nix-prefetch-docker nix gitMinimal

set -x -eu -o pipefail

cd $(dirname "${BASH_SOURCE[0]}")

NIXPKGS_PATH="$(git rev-parse --show-toplevel)"

temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

gh api repos/dependabot/cli/releases/latest > "$temp_dir/latest.json"

VERSION="$(jq -r .tag_name "$temp_dir/latest.json" | sed 's/^v//')"
OLD_VERSION="$(grep -m1 'version = "' ./package.nix | cut -d'"' -f2)"

if [ "$OLD_VERSION" = "$VERSION" ]; then
  echo "dependabot is already up-to-date at $OLD_VERSION"
  exit 0
fi

SHA256="$(nix-prefetch-url --quiet --unpack https://github.com/dependabot/cli/archive/refs/tags/v${VERSION}.tar.gz)"
HASH="$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$SHA256")"

nix-prefetch-docker --json --quiet --final-image-name dependabot-update-job-proxy --final-image-tag "nixpkgs-dependabot-cli-$VERSION" ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy latest > "$temp_dir/dependabot-update-job-proxy.json"

nix-prefetch-docker --json --quiet --final-image-name dependabot-updater-github-actions --final-image-tag "nixpkgs-dependabot-cli-$VERSION" ghcr.io/dependabot/dependabot-updater-github-actions latest > "$temp_dir/dependabot-updater-github-actions.json"

setKV () {
    sed -i "s,$1 = \"[^v].*\",$1 = \"${2:-}\"," ./package.nix
}

setKV version "${VERSION}"
setKV hash "${HASH}"
setKV updateJobProxy.imageDigest "$(jq -r .imageDigest "$temp_dir/dependabot-update-job-proxy.json")"
setKV updateJobProxy.hash "$(jq -r .hash "$temp_dir/dependabot-update-job-proxy.json")"
setKV updaterGitHubActions.imageDigest "$(jq -r .imageDigest "$temp_dir/dependabot-updater-github-actions.json")"
setKV updaterGitHubActions.hash "$(jq -r .hash "$temp_dir/dependabot-updater-github-actions.json")"

# We need to figure out the vendorHash for this new version, so we initially set it to `lib.fakeHash`
FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
setKV vendorHash "$FAKE_HASH"

set +e
VENDOR_HASH="$(nix-build --no-out-link --log-format internal-json -A dependabot-cli "$NIXPKGS_PATH" 2>&1 >/dev/null | grep "$FAKE_HASH" | grep -o "sha256-[^\\]*" | tail -1)"
set -e
setKV vendorHash "$VENDOR_HASH"
