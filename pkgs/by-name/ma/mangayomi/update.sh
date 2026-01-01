#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p curl gnused jq yq-go nix bash nix-update
=======
#!nix-shell -i bash -p curl gnused jq yq nix bash nix-update
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

set -eou pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

<<<<<<< HEAD
latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/kodjodevf/mangayomi/releases/latest | jq --raw-output .tag_name)
=======
latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/kodjodevf/mangayomi/releases/latest | jq --raw-output .tag_name)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix eval --raw --file . mangayomi.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

<<<<<<< HEAD
nix-update --version $latestVersion --subpackage rustDep mangayomi

curl --fail --silent https://raw.githubusercontent.com/kodjodevf/mangayomi/${latestTag}/pubspec.lock | yq eval --output-format=json --prettyPrint >$PACKAGE_DIR/pubspec.lock.json
=======
nix-update --subpackage rustDep mangayomi

curl -sL https://raw.githubusercontent.com/kodjodevf/mangayomi/${latestTag}/pubspec.lock | yq . >$PACKAGE_DIR/pubspec.lock.json
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

$(nix eval --file . dart.fetchGitHashesScript) --input $PACKAGE_DIR/pubspec.lock.json --output $PACKAGE_DIR/git-hashes.json
