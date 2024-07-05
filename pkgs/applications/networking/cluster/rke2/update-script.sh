#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git gnugrep gnused yq-go nix-prefetch

set -x -eu -o pipefail

CHANNEL_NAME="${1:?Must provide a release channel, like 'stable', as the only argument}"

mkdir --parents --verbose ./${CHANNEL_NAME}

LATEST_TAG_NAME=$(curl --silent --fail https://update.rke2.io/v1-release/channels | \
    yq eval ".data[] | select(.id == \"${CHANNEL_NAME}\").latest" - | \
    sort -rV | grep --extended-regexp "^v[0-9]+\.[0-9]+\.[0-9]+" | head -n1)

RKE2_VERSION=$(echo ${LATEST_TAG_NAME} | sed 's/^v//')

RKE2_REPO_SHA256=$(nix-prefetch-url --quiet --unpack \
        https://github.com/rancher/rke2/archive/refs/tags/${LATEST_TAG_NAME}.tar.gz)

RKE2_COMMIT=$(curl --silent --fail ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} \
        https://api.github.com/repos/rancher/rke2/git/refs/tags | \
    yq eval ".[] | select(.ref == \"refs/tags/${LATEST_TAG_NAME}\").object.sha" -)

VERSIONS_SCRIPT=$(mktemp --suffix ".${RKE2_COMMIT:0:6}.sh")
trap "rm --force ${VERSIONS_SCRIPT}" EXIT

curl --silent --fail --output ${VERSIONS_SCRIPT} \
        https://raw.githubusercontent.com/rancher/rke2/${RKE2_COMMIT}/scripts/version.sh

set +eu
DRONE_TAG=${LATEST_TAG_NAME} source ${VERSIONS_SCRIPT}
set -eu

KUBERNETES_CYCLES=$(echo ${KUBERNETES_VERSION} | grep -Eo "[0-9]+\.[0-9]+")
KUBERNETES_EOL=$(curl --silent --fail \
        https://endoflife.date/api/kubernetes/${KUBERNETES_CYCLES}.json | \
    yq eval ".eol" -)

FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

cat > ./${CHANNEL_NAME}/versions.nix << EOF
{
  rke2Version = "${RKE2_VERSION}";
  rke2RepoSha256 = "${RKE2_REPO_SHA256}";
  rke2Commit = "${RKE2_COMMIT}";
  rke2VendorHash = "${FAKE_HASH}";
  k8sVersion = "${KUBERNETES_VERSION}";
  k8sImageTag = "${KUBERNETES_IMAGE_TAG}";
  etcdVersion = "${ETCD_VERSION}";
  pauseVersion = "${PAUSE_VERSION}";
  ccmVersion = "${CCM_VERSION}";
  dockerizedVersion = "${DOCKERIZED_VERSION}";
  golangVersion = "${VERSION_GOLANG}";
  eol = "${KUBERNETES_EOL}";
}
EOF

NIXPKGS_ROOT=$(git rev-parse --show-toplevel)

set +e
RKE2_VENDOR_HASH=$(nix-prefetch -I nixpkgs=${NIXPKGS_ROOT} \
        "{ sha256 }: (import ${NIXPKGS_ROOT}/. {}).rke2_${CHANNEL_NAME}.goModules.overrideAttrs (_: { vendorHash = sha256; })")
set -e

if [ -n "${RKE2_VENDOR_HASH:-}" ]; then
    sed -i "s#${FAKE_HASH}#${RKE2_VENDOR_HASH}#g" ./${CHANNEL_NAME}/versions.nix
else
    echo "Update failed. 'RKE2_VENDOR_HASH' is empty."
    exit 1
fi

# Implement commit
# See: https://nixos.org/manual/nixpkgs/stable/#var-passthru-updateScript-commit
OLD_VERSION=$(nix-instantiate --eval -E \
        "with import ${NIXPKGS_ROOT}/. {}; rke2.version or (builtins.parseDrvName rke2.name).version" | \
    tr -d '"')

cat << EOF
[{
  "attrPath": "rke2_${CHANNEL_NAME}",
  "oldVersion": "${OLD_VERSION}",
  "newVersion": "${RKE2_VERSION}",
  "files": [
    "${PWD}/${CHANNEL_NAME}/versions.nix"
  ]
}]
EOF
