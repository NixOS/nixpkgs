#! /usr/bin/env bash
set -e

export NIX_CURL_FLAGS=-sS

# Install Nix
echo "=== Installing Nix..."
bash <(curl -sS https://nixos.org/nix/install) >/dev/null 2>&1
source $HOME/.nix-profile/etc/profile.d/nix.sh

# Make sure we can use hydra's binary cache
sudo mkdir /etc/nix
sudo tee /etc/nix/nix.conf <<EOF >/dev/null
binary-caches = http://cache.nixos.org http://hydra.nixos.org
trusted-binary-caches = http://hydra.nixos.org
build-max-jobs = 4
EOF

echo "=== Checking evaluation, including meta"
nix-env -f. -qa --json >/dev/null

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    echo "===> Not a pull request, checking evaluation"
    nix-build pkgs/top-level/release.nix -A tarball
    exit 0
fi

echo "=== Installing nox"
git clone https://github.com/madjar/nox >/dev/null
pip --quiet install -e nox

echo "=== Reviewing PR"
# The current HEAD is the PR merged into origin/master, so we compare
# against origin/master
nox-review wip --against origin/master
