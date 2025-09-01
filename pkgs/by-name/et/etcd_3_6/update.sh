#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq nurl

set -x -eu -o pipefail

MAJOR_VERSION=3
MINOR_VERSION=6

ETCD_PATH="$(dirname "$0")"
ETCD_VERSION_MAJOR_MINOR=${MAJOR_VERSION}.${MINOR_VERSION}
ETCD_PKG_NAME=etcd_${MAJOR_VERSION}_${MINOR_VERSION}
NIXPKGS_PATH="$(git rev-parse --show-toplevel)"

LATEST_TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} \
    --silent https://api.github.com/repos/etcd-io/etcd/releases \
    | jq -r 'map(select(.prerelease == false))' \
    | jq -r 'map(.tag_name)' \
    | grep "v${ETCD_VERSION_MAJOR_MINOR}." \
    | sed 's|[", ]||g' \
    | sort -rV | head -n1 )

LATEST_VERSION=$(echo ${LATEST_TAG} | sed 's/^v//')

OLD_VERSION="$(nix-instantiate --eval -E "with import $NIXPKGS_PATH {}; \
    $ETCD_PKG_NAME.version or (builtins.parseDrvName $ETCD_PKG_NAME.name).version" | tr -d '"')"

if [ ! "$OLD_VERSION" = "$LATEST_VERSION" ]; then
    echo "Attempting to update etcd from $OLD_VERSION to $LATEST_VERSION"
    ETCD_SRC_HASH=$(nix-prefetch-url --quiet --unpack https://github.com/etcd-io/etcd/archive/refs/tags/${LATEST_TAG}.tar.gz)
    ETCD_SRC_HASH=$(nix hash to-sri --type sha256 $ETCD_SRC_HASH)

    setKV () {
        sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" "$ETCD_PATH/default.nix"
    }

    setKV version $LATEST_VERSION
    setKV etcdSrcHash $ETCD_SRC_HASH

    getAndSetVendorHash () {
        local EMPTY_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" # Hash from lib.fakeHash
        local VENDOR_HASH=$EMPTY_HASH
        local PKG_KEY=$1
        local INNER_PKG=$2

        setKV $PKG_KEY $EMPTY_HASH

        set +e
        VENDOR_HASH=$(nurl -e "(import ${NIXPKGS_PATH}/. {}).$ETCD_PKG_NAME.passthru.deps.$INNER_PKG.goModules")
        set -e

        if [ -n "${VENDOR_HASH:-}" ]; then
            setKV $PKG_KEY $VENDOR_HASH
        else
            echo "Update failed. $PKG_KEY is empty."
            exit 1
        fi
    }

    getAndSetVendorHash etcdServerVendorHash etcdserver
    getAndSetVendorHash etcdUtlVendorHash etcdutl
    getAndSetVendorHash etcdCtlVendorHash etcdctl

    # `git` flag here is to be used by local maintainers to speed up the bump process
    if [ $# -eq 1 ] && [ "$1" = "git" ]; then
        git switch -c "package-$ETCD_PKG_NAME-$LATEST_VERSION"
        git add "$ETCD_PATH"/default.nix
        git commit -m "$ETCD_PKG_NAME: $OLD_VERSION -> $LATEST_VERSION

Release: https://github.com/etcd-io/etcd/releases/tag/$LATEST_TAG"
    fi

else
    echo "etcd is already up-to-date at $OLD_VERSION"
fi
