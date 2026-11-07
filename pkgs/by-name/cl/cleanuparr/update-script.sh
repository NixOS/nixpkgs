#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash cacert curl jq gnused git common-updater-scripts nix-update
# shellcheck shell=bash

# The Cleanuparr forks of the qBittorrent/Transmission clients are untagged. Their `version` must equal the PackageReference version in Cleanuparr's csproj (it becomes the nupkg version via -p:Version), while `rev` tracks the fork's default branch. Forks are updated first so the main package's fetch-deps can restore against the new local nupkgs.

set -euo pipefail

attr=${UPDATE_NIX_ATTR_PATH:?run via maintainers/scripts/update.nix}

tag=$(curl -sfL ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
  https://api.github.com/repos/Cleanuparr/Cleanuparr/releases/latest | jq -r .tag_name)
[[ -n "$tag" && "$tag" != null ]] || { echo "failed to fetch latest Cleanuparr tag" >&2; exit 1; }

csproj=$(curl -sfL "https://raw.githubusercontent.com/Cleanuparr/Cleanuparr/$tag/code/backend/Cleanuparr.Infrastructure/Cleanuparr.Infrastructure.csproj")

update_fork() { # passthru-attr packageId repo
  local sub=$1 pkgId=$2 repo=$3 ver rev
  ver=$(sed -nE "s/.*Include=\"${pkgId//./\\.}\" Version=\"([^\"]+)\".*/\1/p" <<<"$csproj")
  [[ -n "$ver" ]] || { echo "no $pkgId PackageReference found in Cleanuparr $tag" >&2; exit 1; }
  rev=$(git ls-remote "https://github.com/Cleanuparr/$repo" HEAD | cut -f1)

  if [[ "$ver" == "$(nix-instantiate --eval --raw -A "$attr.$sub.version")" &&
        "$rev" == "$(nix-instantiate --eval --raw -A "$attr.$sub.src.rev")" ]]; then
    echo "$attr.$sub is up to date ($ver @ $rev)"
    return
  fi

  update-source-version "$attr.$sub" "$ver" --rev="$rev" --ignore-same-version
  "$(nix-build -A "$attr.$sub.fetch-deps" --no-out-link)"
}

update_fork qbittorrent-net-client FLM.QBittorrent qbittorrent-net-client
update_fork transmission-api-rpc FLM.Transmission Transmission.API.RPC

# Updates src, npmDeps hash and cleanuparr-deps.json.
nix-update "$attr" --version="${tag#v}"

