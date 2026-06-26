#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update gitMinimal diffutils gnused

set -x
set -eou pipefail

# check for updates
token_args=""
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  token_args="-H \"Authorization: Bearer $GITHUB_TOKEN\""
fi

latest_tag=$(curl ${token_args} -sL "https://api.github.com/repos/repath-studio/repath-studio/releases/latest" | jq -r '.tag_name')
version="${latest_tag#v}"

set +ue
if [[ "${UPDATE_NIX_OLD_VERSION:-}" == "$version" ]]; then
  echo "Already up-to-date, version: $version"
  exit 0
fi
set -ue

NIXPKGS_PATH="$(git rev-parse --show-toplevel)"
PACKAGE_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

PACKAGE_FILE="$PACKAGE_DIR/package.nix"
PATCH_CLJ_FILE="$PACKAGE_DIR/pin-clojure.patch"

pushd $NIXPKGS_PATH
nix-update --version="$version" repath-studio
popd

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
pushd "$TMPDIR"

src="$(nix-build --no-link "$NIXPKGS_PATH" -A repath-studio.src)"
cp "$src/deps.edn" deps.edn

# pin clojure from the upstream's pinned version
workflow_file="$src/.github/workflows/desktop-app.yml"
clj_version="$(
  grep -A 10 "uses:.*setup-clojure" "$workflow_file" |
    grep "cli:" |
    head -n1 |
    sed -E 's/.*cli:\s+([0-9]+\.[0-9]+\.[0-9]+).*/\1/'
)"

if [[ -z "$clj_version" ]]; then
  echo "Error: Could not parse clojure version from $workflow_file" >&2
  exit 1
fi

mkdir -p a b
cp deps.edn a/deps.edn
cp deps.edn b/deps.edn

# insert clojure dep at start of :deps map
sed -i "0,/:deps {/s|:deps {|:deps {org.clojure/clojure {:mvn/version \"$clj_version\"}\n        |" b/deps.edn
git --no-pager diff --no-index --no-prefix a/deps.edn b/deps.edn >"$PATCH_CLJ_FILE" || true

rm -rf a b

# clojure home

dummy_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
sed -i "s|outputHash = \".*\";|outputHash = \"$dummy_hash\";|" "$PACKAGE_FILE"

# expect failure to get new hash
set +e
new_clj_home_hash="$(
  nix-build --no-link -A repath-studio.passthru.clojureHome "$NIXPKGS_PATH" 2>&1 >/dev/null |
    grep "got:" | cut -d':' -f2 | sed 's| ||g'
)"
set -e

if [[ -z "$new_clj_home_hash" ]]; then
  echo "Failed to get new clojure home hash." >&2
  exit 1
fi

sed -i "s|\"$dummy_hash\"|\"$new_clj_home_hash\"|g" "$PACKAGE_FILE"

echo "Update to $version complete."
