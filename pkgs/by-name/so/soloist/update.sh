#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl git gnugrep gnused gnutar nix
set -euo pipefail

# Refreshes pkgs/by-name/so/soloist/package.nix from upstream.
#
# Spotify publishes every Soloist build under stable archive URLs (the same
# URL always serves the newest build), so there is nothing versioned to poll:
# this script downloads each architecture's archive and updates `version`
# plus the per-architecture hashes via update-source-version.
#
# The version is the topmost `## Release vX.Y[.Z]` heading of the CHANGELOG.md
# bundled in each archive. Downloaded binaries cannot be executed here (NixOS
# has no stub dynamic linker, and never cross-architecture), so `soloist
# --version` is not an option; the changelog release is a prefix of the full
# `--version` string, which is all versionCheckHook needs. Architectures must
# agree, otherwise the script aborts; pass the version explicitly to override:
# ./update.sh <version>
#
# Soloist builds expire 90 days after their build date, so run this regularly.
# https://developer.spotify.com/documentation/soloist/reference/downloads-and-updates

cd "$(git rev-parse --show-toplevel)"

declare -A archives=(
  [x86_64-linux]=soloist_release_x86_64.tar.gz
  [aarch64-linux]=soloist_release_arm64.tar.gz
)

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

declare -A hashes=()
declare -A releases=()

for system in "${!archives[@]}"; do
  archive="${archives[$system]}"
  tarball="$workdir/$archive"
  echo "Downloading $archive..." >&2
  curl --fail --silent --show-error --location \
    --output "$tarball" "https://soloist-builds.spotifycdn.com/$archive"
  hashes[$system]="$(nix hash file --type sha256 --sri "$tarball")"

  dir="$workdir/$system"
  mkdir -p "$dir"
  tar -xzf "$tarball" -C "$dir"

  changelog="$dir/CHANGELOG.md"
  if [[ ! -f "$changelog" ]]; then
    echo "update.sh: $archive does not contain CHANGELOG.md; refusing to update" >&2
    exit 1
  fi
  releases[$system]="$(sed -nE 's/^## Release v([0-9.]+).*/\1/p' "$changelog" | head -n 1)"
  if [[ -z "${releases[$system]}" ]]; then
    echo "update.sh: could not parse a release version from $archive's CHANGELOG.md" >&2
    exit 1
  fi
done

if [[ $# -gt 0 ]]; then
  if [[ ! "$1" =~ ^[0-9.]+$ ]]; then
    echo "update.sh: '$1' does not look like a Soloist release version" >&2
    exit 1
  fi
  version="$1"
else
  version=""
  for system in "${!archives[@]}"; do
    if [[ -z "$version" ]]; then
      version="${releases[$system]}"
    elif [[ "$version" != "${releases[$system]}" ]]; then
      echo "update.sh: architectures disagree on the release version (${releases[$system]} on $system vs $version); pass one explicitly: ./update.sh <version>" >&2
      exit 1
    fi
  done
fi
echo "Upstream release: $version" >&2

for system in "${!archives[@]}"; do
  update-source-version soloist "$version" "${hashes[$system]}" --system="$system" --ignore-same-version
done

echo "Soloist updated to $version"
