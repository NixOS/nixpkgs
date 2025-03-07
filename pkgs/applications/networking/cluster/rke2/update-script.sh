#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git gnugrep gnused yq-go nurl go

SHELL_FLAGS=$(set +o)
set -x -eu -o pipefail

MINOR_VERSION="${1:?Must provide a minor version number, like '26', as the only argument}"

WORKDIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd -P)
mkdir --parents --verbose "${WORKDIR}/1_${MINOR_VERSION}"

NIXPKGS_ROOT="$(git rev-parse --show-toplevel)/"
OLD_VERSION="$(nix-instantiate --eval -E "(import $NIXPKGS_ROOT. {}).rke2_1_${MINOR_VERSION}.version or \"0\"" | tr -d '"')"

RELEASE_CHANNEL_DATA=$(curl -sS --fail https://update.rke2.io/v1-release/channels | yq ".data[]")
LATEST_TAG_NAME=$(yq -p=json "select(.id == \"v1.$MINOR_VERSION\") | .latest" <<< "$RELEASE_CHANNEL_DATA")
LATEST_RELEASE_VERSION=$(yq -p=json 'select(.id == "latest") | .latest' <<< "$RELEASE_CHANNEL_DATA")
STABLE_RELEASE_VERSION=$(yq -p=json 'select(.id == "stable") | .latest' <<< "$RELEASE_CHANNEL_DATA")

RKE2_VERSION=${LATEST_TAG_NAME/v/}
RKE2_COMMIT=$(curl -sS --fail "https://api.github.com/repos/rancher/rke2/git/refs/tags/${LATEST_TAG_NAME}" | yq '.object.sha')

PREFETCH_META=$(nix-prefetch-url --unpack --print-path "https://github.com/rancher/rke2/archive/refs/tags/${LATEST_TAG_NAME}.tar.gz")
STORE_HASH="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 ${PREFETCH_META%%$'\n'*})"
STORE_PATH="${PREFETCH_META##*$'\n'}"

cd ${STORE_PATH}
# Used in scripts/version.sh
GITHUB_ACTION_TAG=${LATEST_TAG_NAME}
DRONE_COMMIT=${RKE2_COMMIT}

set +u
source scripts/version.sh
set -u

ETCD_BUILD=$(grep "images.DefaultEtcdImage" scripts/build-binary | sed 's/.*-\(build[0-9]*\)$/\1/')
ETCD_VERSION="${ETCD_VERSION}-${ETCD_BUILD}"
cd ${WORKDIR}

FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

cat << EOF > "${WORKDIR}/1_${MINOR_VERSION}/versions.nix"
{
  rke2Version = "${RKE2_VERSION}";
  rke2Commit = "${RKE2_COMMIT}";
  rke2TarballHash = "${STORE_HASH}";
  rke2VendorHash = "${FAKE_HASH}";
  k8sImageTag = "${KUBERNETES_IMAGE_TAG}";
  etcdVersion = "${ETCD_VERSION}";
  pauseVersion = "${PAUSE_VERSION}";
  ccmVersion = "${CCM_VERSION}";
  dockerizedVersion = "${DOCKERIZED_VERSION}";
}
EOF

RKE2_VENDOR_HASH=$(nurl -e "(import $NIXPKGS_ROOT. {}).rke2_1_${MINOR_VERSION}.goModules")
if [ -n "${RKE2_VENDOR_HASH:-}" ]; then
    sed -i "s#${FAKE_HASH}#${RKE2_VENDOR_HASH}#g" ${WORKDIR}/1_${MINOR_VERSION}/versions.nix
else
    echo "Update failed. 'RKE2_VENDOR_HASH' is empty."
    exit 1
fi

FILES_CHANGED=("${WORKDIR}/1_${MINOR_VERSION}/versions.nix")
if [ "$LATEST_TAG_NAME" == "$LATEST_RELEASE_VERSION" ]; then
    sed -ri "s#^(\s*)rke2_latest = .*;\$#\1rke2_latest = rke2_1_${MINOR_VERSION};#" "${WORKDIR}/default.nix"
    FILES_CHANGED+=("${WORKDIR}/default.nix")
elif [ "$LATEST_TAG_NAME" == "$STABLE_RELEASE_VERSION" ]; then
    sed -ri "s#^(\s*)rke2_stable = .*;\$#\1rke2_stable = rke2_1_${MINOR_VERSION};#" "${WORKDIR}/default.nix"
    FILES_CHANGED+=("${WORKDIR}/default.nix")
fi

# Implement commit
# See: https://nixos.org/manual/nixpkgs/stable/#var-passthru-updateScript-commit
attr_path="rke2_1_${MINOR_VERSION}" \
    old_version="${OLD_VERSION}" \
    new_version="${RKE2_VERSION}" \
    files=[$(printf '"%s",' "${FILES_CHANGED[@]}")] \
    yq --null-input -o=json '[{"attrPath": strenv(attr_path), "oldVersion": strenv(old_version), "newVersion": strenv(new_version), "files": env(files)}]'

set +x
eval "$SHELL_FLAGS"
