#!/usr/bin/env bash
set -eu

[ "$(hostname)" = "vm-gitlab-runner" ] || {
    echo "error: you do not seem to be logged in on the vm."
    exit 1
}

NIX_STORE_VOLUME_ID=$(podman container inspect -f "{{ json .Mounts }}" nix-daemon-container |
    jq -r '.[] | select(.Type == "volume" and .Destination == "/nix/store") | .Name')

NIX_DB_VOLUME_ID=$(podman container inspect -f "{{ json .Mounts }}" nix-daemon-container |
    jq -r '.[] | select(.Type == "volume" and .Destination == "/nix/var/nix/db") | .Name')

[ -n "$NIX_STORE_VOLUME_ID" ] || {
    echo "Could not determine podman volume with nix store in 'nix-daemon-container'." >&2
    exit 1
}

echo "NIX_STORE_VOLUME_ID: $NIX_STORE_VOLUME_ID"
echo "NIX_DB_VOLUME_ID: $NIX_DB_VOLUME_ID"

if [ "${1:-}" = "--force" ]; then
    just podman-remove-containers
fi
echo "Stopping gitlab runner ..."
systemctl stop gitlab-runner.service

echo "Remove podman-nix-daemon-container..."
systemctl stop podman-nix-daemon-container.service
podman container stop nix-daemon-container || true

echo "Delete nix-daemon-store and nix-daemon-db..."
podman volume rm --force "$NIX_STORE_VOLUME_ID" || true
podman volume rm --force "$NIX_DB_VOLUME_ID" || true

echo "Recreate empty volumes ..."
podman volume create "$NIX_STORE_VOLUME_ID" --label="no-prune=true"
podman volume create "$NIX_DB_VOLUME_ID" --label="no-prune=true"

systemctl start podman-nix-daemon-container.service
systemctl start gitlab-runner.service
