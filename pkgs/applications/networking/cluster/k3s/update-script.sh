#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git gnugrep gnused go jq nurl yq-go

set -x -eu -o pipefail

MINOR_VERSION="${1:?Must provide a minor version number, like '26', as the only argument}"

WORKDIR=$(mktemp -d)
trap "rm -rf ${WORKDIR}" EXIT

NIXPKGS_ROOT="$(git rev-parse --show-toplevel)"/
NIXPKGS_K3S_PATH=$(cd $(dirname ${BASH_SOURCE[0]}); pwd -P)/
OLD_VERSION="$(nix-instantiate --eval -E "with import $NIXPKGS_ROOT. {}; k3s_1_${MINOR_VERSION}.version or (builtins.parseDrvName k3s_1_${MINOR_VERSION}.name).version" | tr -d '"')"

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

PREFETCH_META=$(nix-prefetch-url --unpack --print-path https://github.com/k3s-io/k3s/archive/refs/tags/${LATEST_TAG_NAME}.tar.gz)
K3S_STORE_PATH=${PREFETCH_META#*$'\n'}
K3S_REPO_SHA256=${PREFETCH_META%$'\n'*}

cd "$K3S_STORE_PATH"
# Set the DRONE variables as they are expected to be set in version.sh
DRONE_TAG="$LATEST_TAG_NAME"
DRONE_COMMIT="$K3S_COMMIT"
NO_DAPPER=1 # Skips git_version.sh execution in scripts/version.sh#L8
source "${K3S_STORE_PATH}/scripts/git_version.sh"
source "${K3S_STORE_PATH}/scripts/version.sh"

K3S_ROOT_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/k3s-io/k3s-root/releases/download/${VERSION_ROOT}/k3s-root-amd64.tar")
CNIPLUGINS_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/rancher/plugins/archive/refs/tags/${VERSION_CNIPLUGINS}.tar.gz")
CONTAINERD_SHA256=$(nix-prefetch-url --quiet --unpack \
    "https://github.com/k3s-io/containerd/archive/refs/tags/${VERSION_CONTAINERD}.tar.gz")

CHART_FILES=( $(yq eval --no-doc .spec.chart "${K3S_STORE_PATH}/manifests/traefik.yaml" | xargs -n1 basename) )
# These files are:
#   1. traefik-crd-20.3.1+up20.3.0.tgz
#   2. traefik-20.3.1+up20.3.0.tgz
# at the time of writing

if [[ "${#CHART_FILES[@]}" != "2" ]]; then
    echo "New manifest charts added, the packaging scripts will need to be updated: ${CHART_FILES}"
    exit 1
fi

cd "${NIXPKGS_K3S_PATH}/1_${MINOR_VERSION}"

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

# Concatenate all sha256sums, one entry per line
SHA256_HASHES="$(curl -L "https://github.com/k3s-io/k3s/releases/download/v${K3S_VERSION}/sha256sum-amd64.txt")
    \n$(curl -L "https://github.com/k3s-io/k3s/releases/download/v${K3S_VERSION}/sha256sum-arm64.txt")
    \n$(curl -L "https://github.com/k3s-io/k3s/releases/download/v${K3S_VERSION}/sha256sum-arm.txt")"

# Get all airgap images files associated with this release
IMAGES_ARCHIVES=$(curl "https://api.github.com/repos/k3s-io/k3s/releases/tags/v${K3S_VERSION}" | \
    # Filter the assets so that only zstd archives and text files that have "images" in their name remain
    jq -r '.assets[] | select(.name | contains("images")) |
        select(.content_type == "application/zstd" or .content_type == "text/plain; charset=utf-8") |
        "\(.name) \(.browser_download_url)"')

# Create a JSON object for each airgap images file and prefetch all download URLs in the process
# Combine all JSON objects and write the result to images-versions.json
while read -r name url; do
    # Pick the right hash based on the name
    sha256=$(grep "$name" <<< "$SHA256_HASHES" | cut -d ' ' -f 1)
    # Remove the k3s- prefix and file endings
    clean_name=$(sed -e 's/^k3s-//' -e 's/\.tar\.zst//' -e 's/\.txt/-list/' <<< "$name")
    jq --null-input --arg name "$clean_name" \
            --arg url "$url" \
            --arg sha256 "$sha256" \
        '{$name: {"url": $url, "sha256": $sha256}}'
done <<<"${IMAGES_ARCHIVES}" | jq --slurp 'reduce .[] as $item ({}; . * $item)' > images-versions.json

FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

cat >versions.nix <<EOF
{
  k3sVersion = "${K3S_VERSION}";
  k3sCommit = "${K3S_COMMIT}";
  k3sRepoSha256 = "${K3S_REPO_SHA256}";
  k3sVendorHash = "${FAKE_HASH}";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "${VERSION_ROOT:1}";
  k3sRootSha256 = "${K3S_ROOT_SHA256}";
  k3sCNIVersion = "${VERSION_CNIPLUGINS:1}";
  k3sCNISha256 = "${CNIPLUGINS_SHA256}";
  containerdVersion = "${VERSION_CONTAINERD:1}";
  containerdSha256 = "${CONTAINERD_SHA256}";
  criCtlVersion = "${VERSION_CRICTL:1}";
}
EOF

set +e
K3S_VENDOR_HASH=$(nurl -e "(import ${NIXPKGS_ROOT}. {}).k3s_1_${MINOR_VERSION}.goModules")
set -e

if [ -n "${K3S_VENDOR_HASH:-}" ]; then
    sed -i "s|${FAKE_HASH}|${K3S_VENDOR_HASH}|g" ./versions.nix
else
    echo "Update failed. K3S_VENDOR_HASH is empty."
    exit 1
fi

# Implement commit
# See https://nixos.org/manual/nixpkgs/stable/#var-passthru-updateScript-commit
cat <<EOF
[{
    "attrPath": "k3s_1_${MINOR_VERSION}",
    "oldVersion": "$OLD_VERSION",
    "newVersion": "$K3S_VERSION",
    "files": ["$PWD/versions.nix","$PWD/chart-versions.nix","$PWD/images-versions.json"]
}]
EOF
