#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts coreutils curl git gnused jq nix nix-prefetch-github python3 ripgrep yq-go

set -euo pipefail

packageDir="$(realpath "$(dirname "$0")")"
nixpkgsDir="$(git -C "$packageDir" rev-parse --show-toplevel)"
cd "$nixpkgsDir"

curlGitHub() {
  curl --fail --location --silent \
    ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} \
    "$@"
}

currentVersion="$(nix eval --raw .#cake-wallet.version)"
latestTag="$(
  curlGitHub https://api.github.com/repos/cake-tech/cake_wallet/releases/latest |
    jq --raw-output .tag_name
)"
version="${latestTag#v}"

if [[ "$currentVersion" != "$version" ]]; then
  update-source-version cake-wallet "$version" --source-key=upstreamSrc
elif ! nix build --no-link .#cake-wallet.upstreamSrc; then
  update-source-version cake-wallet "$version" \
    --source-key=upstreamSrc \
    --ignore-same-version
fi

workDir="$(mktemp -d)"
export HOME="$(mktemp -d)"
trap 'rm -rf "$workDir" "$HOME"' EXIT

sourcePath() {
  nix build --no-link --print-out-paths ".#cake-wallet.$1"
}

upstreamSource="$(sourcePath upstreamSrc)"

torchDartRev="$(
  rg '^HASH=([0-9a-f]{40})$' "$upstreamSource/scripts/prepare_torch.sh" -r '$1'
)"
reownFlutterRev="$(
  rg '^HASH=([0-9a-f]{40})$' "$upstreamSource/scripts/prepare_reown.sh" -r '$1'
)"
bitboxFlutterRev="$(
  rg 'git checkout ([0-9a-f]{40})$' "$upstreamSource/scripts/build_bitbox_flutter.sh" -r '$1'
)"
zcashLibRev="$(
  rg '^HASH=([0-9a-f]{40})$' "$upstreamSource/scripts/prepare_zcash.sh" -r '$1'
)"
secp256k1Version="$(
  rg '^\s*github\.com/ltcmweb/secp256k1 v(\S+).*$' \
    "$upstreamSource/cw_mweb/go/go.mod" -r '$1'
)"

updateGitHubSource() {
  local file="$1"
  local name="$2"
  local attr="$3"
  local owner="$4"
  local repo="$5"
  local expectedRev="$6"
  shift 6
  local currentRev
  currentRev="$(nix eval --raw ".#$attr.rev")"

  if [[ "$currentRev" != "$expectedRev" ]]; then
    local hash
    hash="$(
      nix-prefetch-github "$owner" "$repo" --rev "$expectedRev" --json "$@" |
        jq --raw-output .hash
    )"
    python3 - "$file" "$name" "$expectedRev" "$hash" <<'PY'
import pathlib
import re
import sys

path, name, revision, source_hash = sys.argv[1:]
lines = pathlib.Path(path).read_text().splitlines(keepends=True)
in_source = False
updated_revision = False
updated_hash = False

for index, line in enumerate(lines):
    if line == f"  {name} = fetchFromGitHub {{\n":
        in_source = True
    elif in_source and re.match(r'    (?:rev|tag) = ".*";$', line.rstrip()):
        lines[index] = f'    rev = "{revision}";\n'
        updated_revision = True
    elif in_source and re.match(r'    hash = ".*";$', line.rstrip()):
        lines[index] = f'    hash = "{source_hash}";\n'
        updated_hash = True
    elif in_source and line == "  };\n":
        break

if not (updated_revision and updated_hash):
    raise SystemExit(f"failed to update {name} in {path}")

pathlib.Path(path).write_text("".join(lines))
PY
  fi
}

updateGitHubSource \
  "$packageDir/package.nix" torchDart cake-wallet.torchDart \
  MrCyjaneK torch_dart "$torchDartRev"
updateGitHubSource \
  "$packageDir/package.nix" reownFlutter cake-wallet.reownFlutter \
  cake-tech reown_flutter "$reownFlutterRev"
updateGitHubSource \
  "$packageDir/package.nix" bitboxFlutter cake-wallet.bitboxFlutter \
  konstantinullrich bitbox_flutter "$bitboxFlutterRev"
updateGitHubSource \
  "$packageDir/warp-api-ffi.nix" src cake-wallet.zcashLib \
  MrCyjaneK zwallet "$zcashLibRev" --fetch-submodules
updateGitHubSource \
  "$packageDir/mweb.nix" secp256k1 cake-wallet.mweb.secp256k1 \
  ltcmweb secp256k1 "v$secp256k1Version"

flutterSdk="$(sourcePath flutterSdk)"
cp --recursive --no-preserve=mode "$upstreamSource"/. "$workDir"
mkdir -p "$workDir/scripts"
cp --recursive --no-preserve=mode "$(sourcePath torchDart)" "$workDir/scripts/torch_dart"
cp --recursive --no-preserve=mode "$(sourcePath reownFlutter)" "$workDir/scripts/reown_flutter"
cp --recursive --no-preserve=mode "$(sourcePath bitboxFlutter)" "$workDir/scripts/bitbox_flutter"
cp --recursive --no-preserve=mode "$(sourcePath zcashLib)" "$workDir/scripts/zcash_lib"

(
  cd "$workDir"

  if ! rg --quiet '^  flutter_lints:' pubspec_base.yaml; then
    sed --in-place '/^dev_dependencies:$/a\  flutter_lints: ^2.0.0' pubspec_base.yaml
  fi

  "$flutterSdk/bin/dart" tool/generate_pubspec.dart
  "$flutterSdk/bin/dart" tool/configure.dart \
    --monero \
    --bitcoin \
    --ethereum \
    --polygon \
    --nano \
    --bitcoinCash \
    --solana \
    --tron \
    --wownero \
    --zcash \
    --dogecoin \
    --base \
    --arbitrum \
    --bsc
  sed --in-place "s/version: 0.0.0/version: $version/" pubspec.yaml

  "$flutterSdk/bin/flutter" pub get
  yq eval --output-format=json --prettyPrint pubspec.lock > "$packageDir/pubspec.lock.json"
)

fetchGitHashesScript="$(
  nix eval --raw --file "$nixpkgsDir" dart.fetchGitHashesScript
)"
"$fetchGitHashesScript" \
  --input "$packageDir/pubspec.lock.json" \
  --output "$packageDir/git-hashes.json"
