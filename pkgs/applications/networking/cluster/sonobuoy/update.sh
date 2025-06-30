#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl jq gnused

set -euo pipefail

# Do the actual update.
nix-update "${UPDATE_NIX_ATTR_PATH}"

# Get the src metadata.
src=$(
    nix-instantiate --json --eval --strict --expr '
        with import ./. {};
        {
            owner = '"${UPDATE_NIX_ATTR_PATH}"'.src.owner;
            repo = '"${UPDATE_NIX_ATTR_PATH}"'.src.repo;
            tag = '"${UPDATE_NIX_ATTR_PATH}"'.src.rev;
        }'
)
owner=$(jq -r '.owner' <<< "${src}")
repo=$(jq -r '.repo' <<< "${src}")
tag=$(jq -r '.tag' <<< "${src}")

# Curl the release to get the commit sha.
curlFlags=("-fsSL")
curlFlags+=(${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"})

read -r type tag_sha < <(
    curl "${curlFlags[@]}" "https://api.github.com/repos/${owner}/${repo}/git/ref/tags/${tag}" |
    jq -j '.object.type, " ", .object.sha, "\n"'
)

if [[ "${type}" == "commit" ]]; then
    sha="${tag_sha}"
else
    sha=$(
        curl "${curlFlags[@]}" "https://api.github.com/repos/${owner}/${repo}/git/tags/${tag_sha}" |
        jq '.object.sha'
    )
fi

if [[ -z "${sha}" ]]; then
    echo "failed to get commit sha of ${owner}/${repo} @ ${tag}" >&2
    exit 1
fi

echo "updating commit hash of ${owner}/${repo} @ ${tag} to ${sha}" >&2

cd "$(dirname "$(readlink -f "$0")")"

sed -i "s|\".*\"; # update-commit-sha|${sha}; # update-commit-sha|" default.nix
