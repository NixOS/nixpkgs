export UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-galene}"

oldhash="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.goModules.drvAttrs.outputHash" | cut -d'"' -f2)"
newhash="$(nix-build -A "$UPDATE_NIX_ATTR_PATH.goModules" --no-out-link 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"

if [ "$newhash" == "" ]; then
  echo "No new vendorHash."
  exit 0
fi

fname="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

sed -i "$fname" \
  -e "s|$oldhash|$newhash|g"
