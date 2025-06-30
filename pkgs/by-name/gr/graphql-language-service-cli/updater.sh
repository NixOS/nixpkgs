#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq nix-update

set -euo pipefail

# this package is part of a monorepo with many tags; nix-update only seems to
# fetch the 10 most recent
# https://github.com/Mic92/nix-update/issues/231
owner="graphql"
repo="graphiql"
version=$(
    curl -s ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/graphql/graphiql/git/refs/tags/graphql-language-service-cli" |
        jq 'map(.ref | capture("refs/tags/graphql-language-service-cli@(?<version>[0-9.]+)").version) | .[]' -r |
        sort --reverse --version-sort | head -n1
)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

nix-update graphql-language-service-cli --version $version
