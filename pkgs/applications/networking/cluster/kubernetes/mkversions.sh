#!/usr/bin/env nix-shell
#!nix-shell -p httpie yq moreutils
#!nix-shell -i bash

set -eufxo pipefail

echo '[]' >versions.json

kops_recommended_versions() {
    http https://raw.githubusercontent.com/kubernetes/kops/master/channels/stable \
        | yq -r '.spec.kubernetesVersions[:5] | .[] | .recommendedVersion'
}

for version in $(kops_recommended_versions); do
    jq \
        --arg version "$version" \
        --arg sha256 "$(nix-prefetch-url --unpack "https://github.com/kubernetes/kubernetes/tarball/v${version}")" \
        '. + [{version: $version, sha256: $sha256}]' \
        versions.json \
        | sponge versions.json
done
