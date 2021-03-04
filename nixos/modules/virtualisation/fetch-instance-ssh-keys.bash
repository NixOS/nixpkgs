#!/usr/bin/env bash

set -euo pipefail

WGET() {
    wget --retry-connrefused -t 15 --waitretry=10 --header='Metadata-Flavor: Google' "$@"
}

# When dealing with cryptographic keys, we want to keep things private.
umask 077
mkdir -p /root/.ssh

echo "Fetching authorized keys..."
WGET -O /tmp/auth_keys http://metadata.google.internal/computeMetadata/v1/instance/attributes/sshKeys

# Read keys one by one, split in case Google decided
# to append metadata (it does sometimes) and add to
# authorized_keys if not already present.
touch /root/.ssh/authorized_keys
while IFS='' read -r line || [[ -n "$line" ]]; do
    keyLine=$(echo -n "$line" | cut -d ':' -f2)
    IFS=' ' read -r -a array <<<"$keyLine"
    if [[ ${#array[@]} -ge 3 ]]; then
        echo "${array[@]:0:3}" >>/tmp/new_keys
        echo "Added ${array[*]:2} to authorized_keys"
    fi
done </tmp/auth_keys
mv /tmp/new_keys /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "Fetching host keys..."
WGET -O /tmp/ssh_host_ed25519_key http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssh_host_ed25519_key
WGET -O /tmp/ssh_host_ed25519_key.pub http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssh_host_ed25519_key_pub
mv -f /tmp/ssh_host_ed25519_key* /etc/ssh/
chmod 600 /etc/ssh/ssh_host_ed25519_key
chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
