#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git wget jq common-updater-scripts yarn-berry_4 yarn-berry_4.yarn-berry-fetcher tomlq nix-prefetch-github

set -eu -o pipefail
set -x

TMPDIR=/tmp/anki-update-script

cleanup() {
  if [ -e $TMPDIR/.done ]; then
    rm -rf "$TMPDIR"
  else
    echo
    read -p "Script exited prematurely. Do you want to delete the temporary directory $TMPDIR ? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -rf "$TMPDIR"
    fi
  fi
}

trap cleanup EXIT

if [[ "$#" > 0 ]]; then
  tag="$1"
else
  tag="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s 'https://api.github.com/repos/ankitects/anki/releases' | jq -r  'map(select(.prerelease == false)) | .[0].tag_name')"
fi
tag_sha="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/ankitects/anki/git/ref/tags/$tag" | jq -r '.object.sha')"
rev="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/ankitects/anki/git/tags/$tag_sha" | jq -r '.object.sha')"

nixpkgs="$(git rev-parse --show-toplevel)"
scriptDir="$nixpkgs/pkgs/by-name/an/anki"

ver=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).anki.version" | tr -d '"')

if [[ "$tag" == "$ver" ]]; then
  echo "Latest version is $tag, already $ver, skipping update"
  exit 0
fi
echo "Updating from $ver to $tag"

mkdir -p $TMPDIR

curl -o $TMPDIR/yarn.lock "https://raw.githubusercontent.com/ankitects/anki/refs/tags/$tag/yarn.lock"

echo "Generating missing-hashes.json"
yarn-berry-fetcher missing-hashes $TMPDIR/yarn.lock > $TMPDIR/missing-hashes.json
yarnHash=$(yarn-berry-fetcher prefetch $TMPDIR/yarn.lock $TMPDIR/missing-hashes.json)

echo "Copying missing-hashes.json back into nixpkgs"
cp $TMPDIR/missing-hashes.json "$scriptDir/missing-hashes.json"

sed -i -E "s|yarnHash = \".*\"|yarnHash = \"$yarnHash\"|" "$scriptDir/package.nix"

echo "yarnHash updated"
echo "Regenerating uv-deps.json"

curl -o $TMPDIR/uv.lock "https://raw.githubusercontent.com/ankitects/anki/refs/tags/$tag/uv.lock"

# Extract all urls to pre-compute hashes so we can download whatever uv needs for its cache.
# We skip pyqt because the derivation uses the nixos packaged ones for
# native-library compatibility.
tq -f $TMPDIR/uv.lock --output json '.' | jq '.. | objects | .url | select(. != null)' -cr | \
  grep -Ev "PyQt|pyqt" \
  > $TMPDIR/uv.urls

echo '[' > $TMPDIR/uv-deps.json
for url in $(cat $TMPDIR/uv.urls); do
  urlHash="$(nix-prefetch-url --type sha256 "$url")"
  echo '{"url": "'$url'", "hash": "'$(nix-hash --type sha256 --to-sri $urlHash)'"},' >> $TMPDIR/uv-deps.json
done
# strip final trailing comma
sed '$s/,$//' -i $TMPDIR/uv-deps.json
echo ']' >> $TMPDIR/uv-deps.json

# and jq format it on the way into nixpkgs too
jq '.' $TMPDIR/uv-deps.json > "$scriptDir/uv-deps.json"
echo "Wrote uv-deps.json"

# github as well

srcHash="$(nix-prefetch-github ankitects anki --fetch-submodules --rev "$tag" --json | jq -r '.hash')"

sed -i "s|version = \".*\";|version = \"$tag\";|" "$scriptDir/package.nix"
sed -i "s|rev = \".*\";|rev = \"$rev\";|" "$scriptDir/package.nix"
sed -i "s|srcHash = \".*\";|srcHash = \"$srcHash\";|" "$scriptDir/package.nix"

touch $TMPDIR/.done
