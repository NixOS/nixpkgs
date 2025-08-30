#! /usr/bin/env nix-shell
#! nix-shell -i bash -p wget nodejs_22
version="v0.7.9-beta"

echo Selected filebrowser version: $version
echo "[1/4]: Cleaning up previous package*.json's..."
rm -f {package,package-lock}.json

echo "[2/4]: Fetching package.json from upstream repo..."
wget https://raw.githubusercontent.com/gtsteffaniak/filebrowser/refs/tags/${version}/frontend/package.json

echo "[3/4]: Generating package-lock.json..."
npm install --package-lock-only

echo "[4/4] Cleanup unneeded files..."
rm package.json

echo "Done!"
