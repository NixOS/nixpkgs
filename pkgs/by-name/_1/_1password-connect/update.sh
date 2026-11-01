#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-docker

set -euo pipefail

hashesFile="$(dirname "$(readlink -f "$0")")/hashes.json"

# grab latest version tag from docker releases
# new versions are released in parallel so we only need to fetch one
newVersion="$(curl -fsS 'https://hub.docker.com/v2/repositories/1password/connect-api/tags/?page_size=10' |
  jq -r '.results[].name' |
  grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' |
  sort -rV | head -n1)"
echo "updating 1password-connect to tag $newVersion"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

for image in connect-api connect-sync; do
  declare -A digests hashes
  for arch in amd64 arm64; do
    pin="$(nix-prefetch-docker \
      --image-name "1password/$image" \
      --image-tag "$newVersion" \
      --final-image-tag "$newVersion" \
      --arch "$arch" \
      --json)"
    digests[$arch]="$(jq -r '.imageDigest' <<<"$pin")"
    hashes[$arch]="$(jq -r '.hash' <<<"$pin")"
    echo "$image/$arch: ${digests[$arch]} ${hashes[$arch]}"
  done

  # the digest for both arches of the same image should be the same
  if test "${digests[amd64]}" != "${digests[arm64]}"; then
    echo "fatal: digests for $image differ between architectures" >&2
    exit 1
  fi

  jq -n \
    --arg image "$image" \
    --arg digest "${digests[amd64]}" \
    --arg amd64Hash "${hashes[amd64]}" \
    --arg arm64Hash "${hashes[arm64]}" \
    '{
      ($image): {
        digest: $digest,
        hashes: {
          amd64: $amd64Hash,
          arm64: $arm64Hash
        }
      }
    }' > "$tmpdir/$image.json"
done

jq -s --arg version "$newVersion" '{ version: $version } + add' "$tmpdir"/*.json > "$hashesFile.tmp"
mv -f "$hashesFile.tmp" "$hashesFile"
echo "hashes.json updated to 1password-connect $newVersion"
