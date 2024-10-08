#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git gnugrep gnused yq-go nix-prefetch go

SHELL_FLAGS=$(set +o)
set -x -eu -o pipefail

CHANNEL_NAME="${1:?Must provide a release channel, like 'stable', as the only argument}"

WORKDIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd -P)
mkdir --parents --verbose "${WORKDIR}/${CHANNEL_NAME}"

LATEST_TAG_NAME=$(curl -sS --fail https://update.rke2.io/v1-release/channels | \
    yq ".data[] | select(.id == \"${CHANNEL_NAME}\") | .latest")

RKE2_VERSION=$(echo ${LATEST_TAG_NAME} | sed 's/^v//')
RKE2_COMMIT=$(curl -sS --fail "https://api.github.com/repos/rancher/rke2/git/refs/tags/${LATEST_TAG_NAME}" | yq '.object.sha')

PREFETCH_META=$(nix-prefetch-url --unpack --print-path "https://github.com/rancher/rke2/archive/refs/tags/${LATEST_TAG_NAME}.tar.gz")
STORE_HASH="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 ${PREFETCH_META%%$'\n'*})"
STORE_PATH="${PREFETCH_META##*$'\n'}"

cd ${STORE_PATH}
GITHUB_ACTION_TAG=${LATEST_TAG_NAME}
DRONE_COMMIT=${RKE2_COMMIT}

set +u
source scripts/version.sh
set -u

ETCD_BUILD=$(grep "images.DefaultEtcdImage" scripts/build-binary | sed 's/.*-\(build[0-9]*\)$/\1/')
ETCD_VERSION="${ETCD_VERSION}-${ETCD_BUILD}"
cd ${WORKDIR}

KUBERNETES_CYCLES=$(echo ${KUBERNETES_VERSION} | grep -Eo "[0-9]+\.[0-9]+")
KUBERNETES_EOL=$(curl -sS --fail https://endoflife.date/api/kubernetes/${KUBERNETES_CYCLES}.json | yq ".eol")

FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

cat << EOF > "${WORKDIR}/${CHANNEL_NAME}/versions.nix"
{
  rke2Version = "${RKE2_VERSION}";
  rke2Commit = "${RKE2_COMMIT}";
  rke2TarballHash = "${STORE_HASH}";
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
set +u
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

set +x
eval "$SHELL_FLAGS"
