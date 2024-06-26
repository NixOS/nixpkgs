#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq yq-go nix-prefetch

set -x -eu -o pipefail

MINOR_VERSION="${1:?Must provide a minor version number, like '26', as the only argument}"

WORKDIR=$(mktemp -d)
trap "rm -rf ${WORKDIR}" EXIT

NIXPKGS_ROOT="$(git rev-parse --show-toplevel)"/
NIXPKGS_K3S_PATH=$(cd $(dirname ${BASH_SOURCE[0]}); pwd -P)/
cd ${NIXPKGS_K3S_PATH}

cd 1_${MINOR_VERSION}


LATEST_TAG_RAWFILE=${WORKDIR}/latest_tag.json
curl --silent -f ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/k3s-io/k3s/releases > ${LATEST_TAG_RAWFILE}

LATEST_TAG_NAME=$(cat ${LATEST_TAG_RAWFILE} | \
    jq -r 'map(select(.prerelease == false))' | \
    jq 'map(.tag_name)' | \
    grep -v -e rc -e engine | tail -n +2 | head -n -1 | sed 's|[", ]||g' | sort -rV | grep -E "^v1\.${MINOR_VERSION}\." | head -n1)

K3S_VERSION=$(echo ${LATEST_TAG_NAME} | sed 's/^v//')

K3S_COMMIT=$(curl --silent -f ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/k3s-io/k3s/git/refs/tags \
    | jq -r "map(select(.ref == \"refs/tags/${LATEST_TAG_NAME}\")) | .[0] | .object.sha")

K3S_REPO_SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/k3s-io/k3s/archive/refs/tags/${LATEST_TAG_NAME}.tar.gz)

FILE_SCRIPTS_DOWNLOAD=${WORKDIR}/scripts-download
curl --silent -f https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/scripts/download > $FILE_SCRIPTS_DOWNLOAD

FILE_SCRIPTS_VERSION=${WORKDIR}/scripts-version.sh
curl --silent -f https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/scripts/version.sh > $FILE_SCRIPTS_VERSION

FILE_TRAEFIK_MANIFEST=${WORKDIR}/traefik.yml
curl --silent -f -o "$FILE_TRAEFIK_MANIFEST" https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/manifests/traefik.yaml

CHART_FILES=( $(yq eval --no-doc .spec.chart "$FILE_TRAEFIK_MANIFEST" | xargs -n1 basename) )
# These files are:
#   1. traefik-crd-20.3.1+up20.3.0.tgz
#   2. traefik-20.3.1+up20.3.0.tgz
# at the time of writing

if [[ "${#CHART_FILES[@]}" != "2" ]]; then
    echo "New manifest charts added, the packaging scripts will need to be updated: ${CHART_FILES}"
    exit 1
fi

CHARTS_URL=https://k3s.io/k3s-charts/assets
# Get metadata for both files
rm -f chart-versions.nix.update
cat > chart-versions.nix.update <<EOF
{
  traefik-crd = {
    url = "${CHARTS_URL}/traefik-crd/${CHART_FILES[0]}";
    sha256 = "$(nix-prefetch-url --quiet "${CHARTS_URL}/traefik-crd/${CHART_FILES[0]}")";
  };
  traefik = {
    url = "${CHARTS_URL}/traefik/${CHART_FILES[1]}";
    sha256 = "$(nix-prefetch-url --quiet "${CHARTS_URL}/traefik/${CHART_FILES[1]}")";
  };
}
EOF
mv chart-versions.nix.update chart-versions.nix

FILE_GO_MOD=${WORKDIR}/go.mod
curl --silent https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/go.mod > $FILE_GO_MOD


K3S_ROOT_VERSION=$(grep 'VERSION_ROOT=' ${FILE_SCRIPTS_VERSION} \
    | cut -d'=' -f2 | sed -e 's/"//g' -e 's/^v//')
K3S_ROOT_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/k3s-io/k3s-root/releases/download/v${K3S_ROOT_VERSION}/k3s-root-amd64.tar")

CNIPLUGINS_VERSION=$(grep 'VERSION_CNIPLUGINS=' ${FILE_SCRIPTS_VERSION} \
    | cut -d'=' -f2 | sed -e 's/"//g' -e 's/^v//')
CNIPLUGINS_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/rancher/plugins/archive/refs/tags/v${CNIPLUGINS_VERSION}.tar.gz")

# mimics https://github.com/k3s-io/k3s/blob/v1.26.5%2Bk3s1/scripts/version.sh#L25
CONTAINERD_VERSION=$(grep github.com/containerd/containerd ${FILE_GO_MOD} \
    | head -n1 | awk '{print $4}' | sed -e 's/^v//')
CONTAINERD_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/k3s-io/containerd/archive/refs/tags/v${CONTAINERD_VERSION}.tar.gz")

CRI_CTL_VERSION=$(grep github.com/kubernetes-sigs/cri-tools ${FILE_GO_MOD} \
    | head -n1 | awk '{print $4}' | sed -e 's/"//g' -e 's/^v//')

setKV () {
    sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" ${NIXPKGS_K3S_PATH}default.nix
}

FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

cat >versions.nix <<EOF
{
  k3sVersion = "${K3S_VERSION}";
  k3sCommit = "${K3S_COMMIT}";
  k3sRepoSha256 = "${K3S_REPO_SHA256}";
  k3sVendorHash = "${FAKE_HASH}";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "${K3S_ROOT_VERSION}";
  k3sRootSha256 = "${K3S_ROOT_SHA256}";
  k3sCNIVersion = "${CNIPLUGINS_VERSION}";
  k3sCNISha256 = "${CNIPLUGINS_SHA256}";
  containerdVersion = "${CONTAINERD_VERSION}";
  containerdSha256 = "${CONTAINERD_SHA256}";
  criCtlVersion = "${CRI_CTL_VERSION}";
}
EOF

set +e
K3S_VENDOR_HASH=$(nix-prefetch -I nixpkgs=${NIXPKGS_ROOT} "{ sha256 }: (import ${NIXPKGS_ROOT}. {}).k3s_1_${MINOR_VERSION}.goModules.overrideAttrs (_: { vendorHash = sha256; })")
set -e

if [ -n "${K3S_VENDOR_HASH:-}" ]; then
    sed -i "s|${FAKE_HASH}|${K3S_VENDOR_HASH}|g" ./versions.nix
else
    echo "Update failed. K3S_VENDOR_HASH is empty."
    exit 1
fi

# Implement commit
# See https://nixos.org/manual/nixpkgs/stable/#var-passthru-updateScript-commit
OLD_VERSION="$(nix-instantiate --eval -E "with import $NIXPKGS_ROOT. {}; k3s.version or (builtins.parseDrvName k3s.name).version" | tr -d '"')"
cat <<EOF
[{
    "attrPath": "k3s_1_${MINOR_VERSION}",
    "oldVersion": "$OLD_VERSION",
    "newVersion": "$K3S_VERSION",
    "files": ["$PWD/versions.nix","$PWD/chart-versions.nix"]
}]
EOF
