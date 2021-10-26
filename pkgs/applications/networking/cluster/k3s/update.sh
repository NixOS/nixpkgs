#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq

set -x -eu -o pipefail

WORKDIR=$(mktemp -d)
trap "rm -rf ${WORKDIR}" EXIT

cd $(dirname "${BASH_SOURCE[0]}")

LATEST_TAG_RAWFILE=${WORKDIR}/latest_tag.json
curl --silent ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
    https://api.github.com/repos/k3s-io/k3s/releases > ${LATEST_TAG_RAWFILE}

LATEST_TAG_NAME=$(jq 'map(.tag_name)' ${LATEST_TAG_RAWFILE} | \
    grep -v -e rc -e engine | tail -n +2 | head -n -1 | sed 's|[", ]||g' | sort -rV | head -n1)

K3S_VERSION=$(echo ${LATEST_TAG_NAME} | sed 's/^v//')

K3S_COMMIT=$(curl --silent ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
    https://api.github.com/repos/k3s-io/k3s/tags \
    | jq -r "map(select(.name == \"${LATEST_TAG_NAME}\")) | .[0] | .commit.sha")

K3S_REPO_SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/k3s-io/k3s/archive/refs/tags/${LATEST_TAG_NAME}.tar.gz)

FILE_SCRIPTS_DOWNLOAD=${WORKDIR}/scripts-download
curl --silent https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/scripts/download > $FILE_SCRIPTS_DOWNLOAD

FILE_SCRIPTS_VERSION=${WORKDIR}/scripts-version.sh
curl --silent https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/scripts/version.sh > $FILE_SCRIPTS_VERSION

FILE_MANIFESTS_TRAEFIK=${WORKDIR}/manifests-traefik.yaml
curl --silent https://raw.githubusercontent.com/k3s-io/k3s/${K3S_COMMIT}/manifests/traefik.yaml > $FILE_MANIFESTS_TRAEFIK

TRAEFIK_CHART_VERSION=$(awk -F/ '/traefik-([[:digit:]]+\.)/ {sub(/traefik-/, "", $6) ; sub(/\.tgz/, "", $6); print $6}' $FILE_MANIFESTS_TRAEFIK)

TRAEFIK_CHART_SHA256=$(nix-prefetch-url --quiet "https://helm.traefik.io/traefik/traefik-${TRAEFIK_CHART_VERSION}.tgz")

K3S_ROOT_VERSION=$(grep 'ROOT_VERSION=' ${FILE_SCRIPTS_DOWNLOAD} \
    | cut -d'=' -f2 | cut -d' ' -f1 | sed 's/^v//')
K3S_ROOT_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/k3s-io/k3s-root/releases/download/v${K3S_ROOT_VERSION}/k3s-root-amd64.tar")

CNIPLUGINS_VERSION=$(grep 'VERSION_CNIPLUGINS=' ${FILE_SCRIPTS_VERSION} \
    | cut -d'=' -f2 | cut -d' ' -f1 | sed -e 's/"//g' -e 's/^v//')
CNIPLUGINS_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/rancher/plugins/archive/refs/tags/v${CNIPLUGINS_VERSION}.tar.gz")

setKV () {
    sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" ./default.nix
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
