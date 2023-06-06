#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq git

# This script is adapted from https://github.com/NixOS/nix/blob/27f82ef4a8fc589738ef06040dad5c0e214f97aa/maintainers/upload-release.pl#L202-L218

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"

if [[ "$#" -lt 1 ]]; then
    echo "Usage: $0 EVAL_ID"
fi
evalId=$1

evalUrl="https://hydra.nixos.org/eval/$evalId"
buildInfo=$(curl -sSfL "$evalUrl/job/build.x86_64-linux" --header "Accept: application/json")
releaseName=$(jq -r .nixname <<< "$buildInfo")
version=${releaseName#nix-}

expectedVersion=$(nix-instantiate --eval --strict --json -A nix.version | jq -r .)

if [[ "$version" != "$expectedVersion" ]]; then
    echo "Expected Nix version is $expectedVersion, but the given Nix Hydra evaluation is for version $version"
    exit 1
fi

getStorePath() {
    local jobName=$1
    local buildInfo=$(curl -sSfL "$evalUrl/job/$jobName" --header "Accept: application/json")
    jq -r .buildoutputs.out.path <<< "$buildInfo"
}

generateEntry() {
    local platform=$1
    jobName="build.$platform"
    echo "  # $evalUrl/job/$jobName"
    echo "  $platform = \"$(getStorePath "$jobName")\";"
}

{
    echo "# Generated from $evalUrl"
    echo "{"
    generateEntry "x86_64-linux"
    generateEntry "i686-linux"
    generateEntry "aarch64-linux"
    generateEntry "x86_64-darwin"
    generateEntry "aarch64-darwin"
    echo "}"
} >"$SCRIPT_DIR/nix-fallback-paths.nix"

echo "Successfully updated nix-fallback-paths.nix to Nix version $version"
