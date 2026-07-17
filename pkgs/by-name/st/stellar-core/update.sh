#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts coreutils curl jq nix perl

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
nixpkgs="$(cd "$script_dir/../../../.." >/dev/null 2>&1 && pwd)"
nix_file="$script_dir/package.nix"
attr="stellar-core"
github_repo="stellar/stellar-core"

cd "$nixpkgs"

old_version="$(nix-instantiate --eval --raw -A "$attr.version")"
latest_tag="$(curl -fsS ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/$github_repo/releases/latest" | jq -r '.tag_name')"
latest_version="${latest_tag#v}"
fake_hash="$(nix-instantiate --eval --raw -A lib.fakeHash)"

soroban_revs() {
  local version_tag="$1"

  curl -fsS ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/$github_repo/git/trees/$version_tag?recursive=1" \
    | jq '
        reduce (
          .tree[]
          | select(.mode == "160000" and (.path | test("^src/rust/soroban/p[0-9]+$")))
        ) as $submodule ({};
          .[$submodule.path | sub("^src/rust/soroban/"; "")] = $submodule.sha
        )
      '
}

current_soroban_hashes="$(nix-instantiate --eval --json -A "$attr.cargoDeps.sorobanProtocolHashes")"
old_soroban_revs="{}"
new_soroban_revs="$(soroban_revs "$latest_tag")"

if [[ "$(jq length <<< "$new_soroban_revs")" -eq 0 ]]; then
  echo "Could not find Soroban protocol submodules in $latest_tag" >&2
  exit 1
fi

if [[ "$old_version" != "$latest_version" ]]; then
  old_soroban_revs="$(soroban_revs "v$old_version")"
fi

protocols="$(
  jq --compact-output \
    --arg fake_hash "$fake_hash" \
    --argjson hashes "$current_soroban_hashes" \
    --argjson old "$old_soroban_revs" \
    '
      . as $new
      | keys
      | sort_by(ltrimstr("p") | tonumber)
      | map({
          protocol: .,
          hash: ($hashes[.] // $fake_hash),
          needsUpdate: ($hashes[.] == null or ($old[.] != null and $old[.] != $new[.]))
        })
    ' <<< "$new_soroban_revs"
)"
soroban_hash_lines="$(jq -r '.[] | "        \(.protocol) = \"\(.hash)\";"' <<< "$protocols")"
mapfile -t soroban_protocols_to_update < <(jq -r '.[] | select(.needsUpdate).protocol' <<< "$protocols")

update-source-version "$attr" "$latest_version"

SOROBAN_HASH_LINES="$soroban_hash_lines" \
perl -0pi -e '
  s/(sorobanProtocolHashes = \{\n).*?(\n[[:space:]]+\};)/$1$ENV{SOROBAN_HASH_LINES}$2/s;
' "$nix_file"

update-source-version "$attr" \
  --ignore-same-version \
  --source-key=cargoDeps.mainCargoDeps.vendorStaging

for protocol in "${soroban_protocols_to_update[@]}"; do
  update-source-version "$attr" \
    --ignore-same-version \
    --source-key="cargoDeps.sorobanCargoDeps.$protocol.vendorStaging"
done
