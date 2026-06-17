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
PATCH_GIT_FILE="$PACKAGE_DIR/hardcode-git-paths.patch"
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
git diff --no-index --no-prefix a/deps.edn b/deps.edn >"$PATCH_CLJ_FILE" || true

rm -rf a b

# patches a dependency to be prefetched by nix
# clojure otherwise tries to fetch it at buildtime

# extract sha from clean deps.edn
clj_sha=$(grep -A 2 "clj-kdtree/clj-kdtree" deps.edn | grep -oP ':sha "\K[^"]+')

if [[ -z "$clj_sha" ]]; then
  echo "Error: Could not extract clj-kdtree SHA from deps.edn" >&2
  exit 1
fi

clj_hash=$(nix-prefetch-url --unpack "https://github.com/abscondment/clj-kdtree/archive/$clj_sha.tar.gz" --type sha256)
clj_hash=$(nix hash convert --hash-algo sha256 --from nix32 "$clj_hash")

sed -i "/owner = \"abscondment\"/,/hash =/ s/rev = \".*\"/rev = \"$clj_sha\"/" "$PACKAGE_FILE"
sed -i "/owner = \"abscondment\"/,/hash =/ s|hash = \".*\"|hash = \"$clj_hash\"|" "$PACKAGE_FILE"

mkdir -p a b
cp deps.edn a/deps.edn
cp deps.edn b/deps.edn

sed -i '/clj-kdtree\/clj-kdtree/,/:sha/c\        clj-kdtree/clj-kdtree {:local/root "@clj-kdtree_src@"' b/deps.edn
git diff --no-index --no-prefix a/deps.edn b/deps.edn >"$PATCH_GIT_FILE" || true

rm -rf a b
popd

# maven deps

dummy_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
sed -i "s|outputHash = \".*\";|outputHash = \"$dummy_hash\";|" "$PACKAGE_FILE"

# expect failure to get new hash
set +e
new_mvn_hash="$(
  nix-build --no-link -A repath-studio.passthru.mavenRepo "$NIXPKGS_PATH" 2>&1 >/dev/null |
    grep "got:" | cut -d':' -f2 | sed 's| ||g'
)"
set -e

if [[ -z "$new_mvn_hash" ]]; then
  echo "Failed to get new maven hash." >&2
  exit 1
fi

sed -i "s|\"$dummy_hash\"|\"$new_mvn_hash\"|g" "$PACKAGE_FILE"

echo "Update to $version complete."
