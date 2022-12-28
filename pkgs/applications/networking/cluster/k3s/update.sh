#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq yq-go nix-prefetch

set -x -eu -o pipefail

WORKDIR=$(mktemp -d)
trap "rm -rf ${WORKDIR}" EXIT

NIXPKGS_ROOT="$(git rev-parse --show-toplevel)"/
NIXPKGS_K3S_PATH=$(cd $(dirname ${BASH_SOURCE[0]}); pwd -P)/
cd ${NIXPKGS_K3S_PATH}

LATEST_TAG_RAWFILE=${WORKDIR}/latest_tag.json
curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/k3s-io/k3s/releases > ${LATEST_TAG_RAWFILE}

LATEST_TAG_NAME=$(jq 'map(.tag_name)' ${LATEST_TAG_RAWFILE} | \
    grep -v -e rc -e engine | tail -n +2 | head -n -1 | sed 's|[", ]||g' | sort -rV | head -n1)

K3S_VERSION=$(echo ${LATEST_TAG_NAME} | sed 's/^v//')

K3S_COMMIT=$(curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/k3s-io/k3s/tags \
    | jq -r "map(select(.name == \"${LATEST_TAG_NAME}\")) | .[0] | .commit.sha")

K3S_REPO_SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/k3s-io/k3s/archive/refs/tags/${LATEST_TAG_NAME}.tar.gz)

FILE_SCRIPTS_DOWNLOAD=${WORKDIR}/scripts-download
curl --silent https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/scripts/download > $FILE_SCRIPTS_DOWNLOAD

FILE_SCRIPTS_VERSION=${WORKDIR}/scripts-version.sh
curl --silent https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/scripts/version.sh > $FILE_SCRIPTS_VERSION

FILE_MANIFESTS_TRAEFIK=${WORKDIR}/manifests-traefik.yaml
curl --silent https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/manifests/traefik.yaml > $FILE_MANIFESTS_TRAEFIK

FILE_GO_MOD=${WORKDIR}/go.mod
curl --silent https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/go.mod > $FILE_GO_MOD

TRAEFIK_CHART_VERSION=$(yq e '.spec.chart' $FILE_MANIFESTS_TRAEFIK | awk 'match($0, /([0-9.]+)([0-9]{2})/,
m) { print m[1]; exit; }')
TRAEFIK_CHART_SHA256=$(nix-prefetch-url --quiet "https://helm.traefik.io/traefik/traefik-${TRAEFIK_CHART_VERSION}.tgz")

K3S_ROOT_VERSION=$(grep 'VERSION_ROOT=' ${FILE_SCRIPTS_VERSION} \
    | cut -d'=' -f2 | sed -e 's/"//g' -e 's/^v//')
K3S_ROOT_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/k3s-io/k3s-root/releases/download/v${K3S_ROOT_VERSION}/k3s-root-amd64.tar")

CNIPLUGINS_VERSION=$(grep 'VERSION_CNIPLUGINS=' ${FILE_SCRIPTS_VERSION} \
    | cut -d'=' -f2 | sed -e 's/"//g' -e 's/^v//')
CNIPLUGINS_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/rancher/plugins/archive/refs/tags/v${CNIPLUGINS_VERSION}.tar.gz")

CONTAINERD_VERSION=$(grep github.com/containerd/containerd ${FILE_GO_MOD} \
    | head -n1 | awk '{print $4}' | sed -e 's/"//g' -e 's/^v//')
CONTAINERD_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/k3s-io/containerd/archive/refs/tags/v${CONTAINERD_VERSION}.tar.gz")

CRI_CTL_VERSION=$(grep github.com/kubernetes-sigs/cri-tools ${FILE_GO_MOD} \
    | head -n1 | awk '{print $4}' | sed -e 's/"//g' -e 's/^v//')

setKV () {
    sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" ${NIXPKGS_K3S_PATH}default.nix
}

setKV k3sVersion ${K3S_VERSION}
setKV k3sCommit ${K3S_COMMIT}
setKV k3sRepoSha256 ${K3S_REPO_SHA256}

setKV traefikChartVersion ${TRAEFIK_CHART_VERSION}
setKV traefikChartSha256 ${TRAEFIK_CHART_SHA256}

setKV k3sRootVersion ${K3S_ROOT_VERSION}
setKV k3sRootSha256 ${K3S_ROOT_SHA256}

setKV k3sCNIVersion ${CNIPLUGINS_VERSION}
setKV k3sCNISha256 ${CNIPLUGINS_SHA256}

setKV containerdVersion ${CONTAINERD_VERSION}
setKV containerdSha256 ${CONTAINERD_SHA256}

setKV criCtlVersion ${CRI_CTL_VERSION}

set +e
K3S_VENDOR_SHA256=$(nix-prefetch -I nixpkgs=${NIXPKGS_ROOT} "{ sha256 }: (import ${NIXPKGS_ROOT}. {}).k3s.go-modules.overrideAttrs (_: { vendorSha256 = sha256; })")
set -e

if [ -n "${K3S_VENDOR_SHA256:-}" ]; then
    setKV k3sVendorSha256 ${K3S_VENDOR_SHA256}
else
    echo "Update failed. K3S_VENDOR_SHA256 is empty."
    exit 1
fi

# `git` flag here is to be used by local maintainers to speed up the bump process
if [ $# -eq 1 ] && [ "$1" = "git" ]; then
    OLD_VERSION="$(nix-instantiate --eval -E "with import $NIXPKGS_ROOT. {}; k3s.version or (builtins.parseDrvName k3s.name).version" | tr -d '"')"
    git switch -c "package-k3s-${K3S_VERSION}"
    git add "$NIXPKGS_K3S_PATH"/default.nix
    git commit -m "k3s: ${OLD_VERSION} -> ${K3S_VERSION}"
fi
