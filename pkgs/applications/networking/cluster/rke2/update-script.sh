#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git gnugrep gnused yq-go nix-prefetch

set -x -eu -o pipefail

CHANNEL_NAME="${1:?Must provide a release channel, like 'stable', as the only argument}"

WORKDIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd -P)

mkdir --parents --verbose "${WORKDIR}/${CHANNEL_NAME}"

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

FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

cat << EOF > "${WORKDIR}/${CHANNEL_NAME}/versions.nix"
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

set +e
RKE2_VENDOR_HASH=$(nix-prefetch -I nixpkgs=$(git rev-parse --show-toplevel) \
        "{ sha256 }: rke2_${CHANNEL_NAME}.goModules.overrideAttrs (_: { vendorHash = sha256; })")
set -e

if [ -n "${RKE2_VENDOR_HASH:-}" ]; then
    sed -i "s#${FAKE_HASH}#${RKE2_VENDOR_HASH}#g" ${WORKDIR}/${CHANNEL_NAME}/versions.nix
else
    echo "Update failed. 'RKE2_VENDOR_HASH' is empty."
    exit 1
fi

# Implement commit
# See: https://nixos.org/manual/nixpkgs/stable/#var-passthru-updateScript-commit
cat << EOF
[
  {
    "attrPath": "rke2_${CHANNEL_NAME}",
    "oldVersion": "${UPDATE_NIX_OLD_VERSION}",
    "newVersion": "${RKE2_VERSION}",
    "files": [
      "${WORKDIR}/${CHANNEL_NAME}/versions.nix"
    ]
  }
]
EOF
