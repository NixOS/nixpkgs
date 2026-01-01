#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p curl gnused jq yq-go nix bash nix-update

set -eou pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/intiface/intiface-central/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix eval --raw --file . intiface-central.version)
=======
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq yq nix bash coreutils nix-update

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/intiface/intiface-central/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; intiface-central.version or (lib.getVersion intiface-central)" | tr -d '"')
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update intiface-central --version $latestVersion

<<<<<<< HEAD
curl --fail --silent https://raw.githubusercontent.com/intiface/intiface-central/${latestTag}/pubspec.lock | yq eval --output-format=json --prettyPrint >$PACKAGE_DIR/pubspec.lock.json
=======
curl https://raw.githubusercontent.com/intiface/intiface-central/${latestTag}/pubspec.lock | yq . >$ROOT/pubspec.lock.json
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
