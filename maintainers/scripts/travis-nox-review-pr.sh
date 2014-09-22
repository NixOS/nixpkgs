#! /usr/bin/env bash
set -e

# Install Nix
bash <(curl https://nixos.org/nix/install)
source $HOME/.nix-profile/etc/profile.d/nix.sh

# Make sure we can use hydra's binary cache
sudo mkdir /etc/nix
echo "binary-caches = http://cache.nixos.org http://hydra.nixos.org" | sudo tee /etc/nix/nix.conf
echo "trusted-binary-caches = http://hydra.nixos.org" | sudo tee -a /etc/nix/nix.conf

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    echo "Not a pull request, checking evaluation"
    nix-env -f. -qaP --drv-path
    exit 0
fi

echo "Installing nox"
git clone https://github.com/madjar/nox
pip install -e nox

echo "Reviewing PR"
# The current HEAD is the PR merged into origin/master, so we compare
# against origin/master
nox-review wip --against origin/master
