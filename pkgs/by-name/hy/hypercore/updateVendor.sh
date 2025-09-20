export UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-hypercore}"

oldversion="${UPDATE_NIX_OLD_VERSION-}"
newversion="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.version" | cut -d'"' -f2)"

if [ "$oldversion" == "$newversion" ]; then
  echo "No new version."
  exit 0
fi

# For NPM to behave nice
HOME="$(mktemp -d)"

oldhash="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.npmDepsHash" | cut -d'"' -f2)"

# Get new lockfile & npmDepsHash
newsource="$(nix-build -A "$UPDATE_NIX_ATTR_PATH".src)"
cp "$newsource"/package.json "$HOME"/
pushd "$HOME"
npm i --package-lock-only --ignore-scripts
newhash="$(prefetch-npm-deps package-lock.json)"
popd

if [ "$oldhash" == "$newhash" ]; then
  echo "No new npmDepsHash."
  exit 0
fi

# File to replace stuff in
fname="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

# Replace hash & lockfile
sed -i "$fname" \
  -e "s|$oldhash|$newhash|g"
mv "$HOME"/package-lock.json "$(dirname "$fname")"/package-lock.json
