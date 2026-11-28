#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl git gnused gnutar nix
set -euo pipefail

# Spotify only publishes rolling (unversioned) Soloist archives, so package.nix
# pins Wayback Machine snapshots of them. The upstream version is read from the
# live archive first, so runs with nothing to do make no archival requests;
# updating mints fresh snapshots and pins the snapshot bytes that were hashed.
# https://developer.spotify.com/documentation/soloist/reference/downloads-and-updates

cd "$(git rev-parse --show-toplevel)"

nixFile="pkgs/by-name/so/soloist/package.nix"

declare -A archives=(
  [x86_64-linux]=soloist_release_x86_64.tar.gz
  [aarch64-linux]=soloist_release_arm64.tar.gz
)

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

declare -A snapshots=()
declare -A hashes=()
declare -A releases=()

currentVersion="$(sed -nE 's/^[[:space:]]*version = "([0-9.]+)".*/\1/p' "$nixFile" | head -n 1)"
if [[ -z "$currentVersion" ]]; then
  echo "update.sh: could not parse the current version from $nixFile" >&2
  exit 1
fi

fetchArchive() {
  local system="$1" url="$2"
  local archive="${archives[$system]}"
  local tarball="$workdir/$archive"
  local dir="$workdir/$system"
  local release

  echo "Downloading $archive..." >&2
  curl --fail --silent --show-error --location \
    --output "$tarball" "$url"
  hashes[$system]="$(nix hash file --type sha256 --sri "$tarball")"

  mkdir -p "$dir"
  tar -xzf "$tarball" -C "$dir"

  release="$(sed -nE 's/^## Release v([0-9.]+).*/\1/p' "$dir/CHANGELOG.md" | head -n 1)"
  if [[ -z "$release" ]]; then
    echo "update.sh: could not parse a release version from $archive's CHANGELOG.md" >&2
    exit 1
  fi
  releases[$system]="$release"
}

snapshotArchive() {
  local rollingUrl="$1"
  local snapshotUrl

  echo "Archiving $rollingUrl into the Wayback Machine..." >&2
  snapshotUrl="$(curl --fail --silent --show-error --location \
    --retry 5 --retry-delay 30 --retry-all-errors --retry-max-time 600 \
    --max-time 600 --output /dev/null --write-out '%{url_effective}' \
    "https://web.archive.org/save/$rollingUrl")"
  case "$snapshotUrl" in
    https://web.archive.org/web/*) : ;;
    *)
      echo "update.sh: unexpected Wayback Machine response: '$snapshotUrl'" >&2
      exit 1
      ;;
  esac
  snapshotUrl="$(printf '%s' "$snapshotUrl" | sed -E 's|(https://web.archive.org/web/[0-9]+)/|\1id_/|')"
  echo "Snapshot: $snapshotUrl" >&2
  echo "$snapshotUrl"
}

snapshotExists() {
  local snapshotUrl="$1"
  local timestamp="${snapshotUrl#https://web.archive.org/web/}"
  local rollingUrl="${snapshotUrl#*id_/}"
  local response

  timestamp="${timestamp%%id_/*}"
  response="$(curl --fail --silent --show-error --location \
    --retry 3 --retry-delay 5 --retry-all-errors \
    "https://web.archive.org/cdx/search/cdx?url=${rollingUrl}&output=json&fl=timestamp,statuscode&from=${timestamp}&to=${timestamp}")"
  grep -q "\"${timestamp}\",\"200\"" <<<"$response"
}

waitForSnapshot() {
  local snapshotUrl="$1"
  local attempt

  for attempt in {1..20}; do
    if snapshotExists "$snapshotUrl"; then
      return 0
    fi
    echo "Waiting for the Wayback Machine to persist the snapshot (attempt $attempt/20)..." >&2
    sleep 30
  done

  return 1
}

fetchArchive x86_64-linux "https://soloist-builds.spotifycdn.com/${archives[x86_64-linux]}"

version="${releases[x86_64-linux]}"
if [[ "$version" == "$currentVersion" ]]; then
  echo "Soloist is already up to date at $version"
  exit 0
fi
echo "Upstream release: $version" >&2

for system in x86_64-linux aarch64-linux; do
  snapshots[$system]="$(snapshotArchive "https://soloist-builds.spotifycdn.com/${archives[$system]}")"
  if ! waitForSnapshot "${snapshots[$system]}"; then
    echo "update.sh: Wayback Machine did not persist the $system snapshot ${snapshots[$system]}; re-run to mint a new one" >&2
    exit 1
  fi
  fetchArchive "$system" "${snapshots[$system]}"
  if [[ "${releases[$system]}" != "$version" ]]; then
    echo "update.sh: $system snapshot is release ${releases[$system]}, expected $version; re-run once upstream is consistent" >&2
    exit 1
  fi
done

for system in x86_64-linux aarch64-linux; do
  update-source-version soloist "$version" "${hashes[$system]}" "${snapshots[$system]}" --system="$system" --ignore-same-version
done

echo "Soloist updated to $version"
