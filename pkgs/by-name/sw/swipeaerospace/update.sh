#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. --pure -i bash -p bash cacert coreutils git gnused nix nix-update swift swiftpm
# shellcheck shell=bash
set -euo pipefail

if [[ $# -gt 1 ]]; then
  echo "Expected at most one version argument." >&2
  exit 2
fi
if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  echo "Usage: $0 [version] (default: latest stable release; run from the nixpkgs root)"
  exit 0
fi

packageDir="$PWD/pkgs/by-name/sw/swipeaerospace"
packageFile="$packageDir/package.nix"
for file in package.nix Package.swift Package.resolved; do
  test -f "$packageDir/$file"
done
# Failed updates leave partial changes for review with git diff.
workDir=$(mktemp -d)
trap 'rm -rf "$workDir"' EXIT

# Update the source first; the dependency hash needs the new lock file.
nix-update swipeaerospace --src-only --version "${1:-stable}"
sourcePath=$(nix-build --no-out-link -A swipeaerospace.src)
# SwiftPM needs a writable source tree outside the Nix store.
cp -R "$sourcePath" "$workDir/source"
chmod -R u+w "$workDir/source"

# Use upstream's lock file as the starting point, with our application manifest.
cp "$packageDir/Package.swift" "$workDir/source/Package.swift"
# Use the compiler provided by this Nix shell.
export SWIFT_EXEC
SWIFT_EXEC=$(command -v swiftc)
swift package --package-path "$workDir/source" resolve
cp "$workDir/source/Package.resolved" "$packageDir/Package.resolved"

# Debug and Release must agree on the bundle build number.
buildNumber=$(sed -n 's/^[[:space:]]*CURRENT_PROJECT_VERSION = \(.*\);/\1/p' \
  "$sourcePath/SwipeAeroSpace.xcodeproj/project.pbxproj" | sort -u)
if [[ ! $buildNumber =~ ^[0-9]+$ ]]; then
  echo "Could not determine a unique bundle build number; check the Xcode project." >&2
  exit 1
fi
# Refuse a silent no-op or an ambiguous replacement after expression changes.
bundleVersion=$(sed -n 's/^[[:space:]]*CFBundleVersion = \(.*\);$/\1/p' "$packageFile")
if [[ ! $bundleVersion =~ ^\"[0-9]+\"$ ]]; then
  echo "Expected exactly one numeric CFBundleVersion in $packageFile." >&2
  exit 1
fi
sed -i "s/CFBundleVersion = \"[0-9]*\";/CFBundleVersion = \"$buildNumber\";/" "$packageFile"

# vendorStaging is the fixed-output dependency fetcher behind fetchSwiftPMDeps.
nix-update swipeaerospace.swiftpmDeps.vendorStaging --version skip --no-src \
  --override-filename "$packageFile"

echo "Updated. Review upstream build settings, then build and run nixpkgs-review."
