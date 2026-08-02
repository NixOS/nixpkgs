
# ccsm, simple-ccsm, emerald, emerald-themes are 0.8.18
for repo in ccsm simple-ccsm emerald emerald-themes; do
  URL="https://gitlab.com/compiz/$repo/-/archive/v$VERSION/$repo-v$VERSION.tar.gz"
  HASH=$(nix store prefetch-file --extra-experimental-features "nix-command" --json --unpack "$URL" | jq -r '.hash')
  echo "," >> compiz-manifest.json
  echo "  \"$repo\": {" >> compiz-manifest.json
  echo "    \"url\": \"$URL\"," >> compiz-manifest.json
  echo "    \"hash\": \"$HASH\"" >> compiz-manifest.json
  echo "  }" >> compiz-manifest.json
  echo "Prefetched $repo: $HASH"
done

# fusion-icon is v0.2.4
URL="https://gitlab.com/compiz/fusion-icon/-/archive/v0.2.4/fusion-icon-v0.2.4.tar.gz"
HASH=$(nix store prefetch-file --extra-experimental-features "nix-command" --json --unpack "$URL" | jq -r '.hash')
echo "," >> compiz-manifest.json
echo "  \"fusion-icon\": {" >> compiz-manifest.json
echo "    \"url\": \"$URL\"," >> compiz-manifest.json
echo "    \"hash\": \"$HASH\"" >> compiz-manifest.json
echo "  }" >> compiz-manifest.json
echo "Prefetched fusion-icon: $HASH"

# compiz-manager is v0.7.0
URL="https://gitlab.com/compiz/compiz-manager/-/archive/v0.7.0/compiz-manager-v0.7.0.tar.gz"
HASH=$(nix store prefetch-file --extra-experimental-features "nix-command" --json --unpack "$URL" | jq -r '.hash')
echo "," >> compiz-manifest.json
echo "  \"compiz-manager\": {" >> compiz-manifest.json
echo "    \"url\": \"$URL\"," >> compiz-manifest.json
echo "    \"hash\": \"$HASH\"" >> compiz-manifest.json
echo "  }" >> compiz-manifest.json
echo "Prefetched compiz-manager: $HASH"

# Fix JSON structure manually later since we appended.
