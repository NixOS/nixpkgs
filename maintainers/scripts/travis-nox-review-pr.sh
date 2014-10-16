#! /usr/bin/env bash
set -e

export NIX_CURL_FLAGS=-sS

if [[ $1 == nix ]]; then
    echo "=== Installing Nix..."
    # Install Nix
    bash <(curl -sS https://nixos.org/nix/install)
    source $HOME/.nix-profile/etc/profile.d/nix.sh

    # Make sure we can use hydra's binary cache
    sudo mkdir /etc/nix
    sudo tee /etc/nix/nix.conf <<EOF >/dev/null
binary-caches = http://cache.nixos.org http://hydra.nixos.org
trusted-binary-caches = http://hydra.nixos.org
build-max-jobs = 4
EOF

    # Verify evaluation
    echo "=== Verifying that nixpkgs evaluates..."
    nix-env -f. -qa --json >/dev/null
elif [[ $1 == nox ]]; then
    echo "=== Installing nox..."
    git clone -q https://github.com/madjar/nox
    pip --quiet install -e nox
elif [[ $1 == build ]]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh

    if [[ $TRAVIS_PULL_REQUEST == false ]]; then
        echo "===> Not a pull request, checking evaluation"
        nix-build pkgs/top-level/release.nix -A tarball
    else
        echo "=== Checking PR"
        # The current HEAD is the PR merged into origin/master, so we compare
        # against origin/master
        nox-review wip --against origin/master
    fi
else
    echo "$0: Unknown option $1" >&2
    false
fi
