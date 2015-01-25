#!/bin/sh

manifestXML=$(nix-build -E 'with (import ../../.. {}); autonix.writeManifestXML ./manifest.nix')

autonixDepsKf5=""
if [[ -z $1 ]]; then
    autonixDepsKF5=$(nix-build ../../.. -A haskellngPackages.autonix-deps-kf5)/bin
else
    autonixDepsKF5="$1/dist/build/kf5-deps"
fi

exec ${autonixDepsKF5}/kf5-deps "${manifestXML}"
