#! /usr/bin/env bash
set -e

export NIX_CURL_FLAGS=-sS

if [[ $1 == nix ]]; then
    # Install Nix
    bash <(curl -sS https://nixos.org/nix/install) >/dev/null 2>&1
    source $HOME/.nix-profile/etc/profile.d/nix.sh

    # Make sure we can use hydra's binary cache
    sudo mkdir /etc/nix
    sudo tee /etc/nix/nix.conf <<EOF >/dev/null
binary-caches = http://cache.nixos.org http://hydra.nixos.org
trusted-binary-caches = http://hydra.nixos.org
build-max-jobs = 4
EOF

    # Verify evaluation
    nix-env -f. -qa --json >/dev/null
elif [[ $1 == nox ]]; then
    git clone -q https://github.com/madjar/nox
    pip --quiet install -e nox
elif [[ $1 == build ]]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh

    if [[ $TRAVIS_PULL_REQUEST == false ]]; then
        echo "===> Not a pull request, checking evaluation"
        nix-build pkgs/top-level/release.nix -A tarball
    else
        # The current HEAD is the PR merged into origin/master, so we compare
        # against origin/master
        # However, since we want to optimize build time, we compare against
        # the last commit Hydra compiled
        built_rev=$(ls -l $HOME/.nix-defexpr/channels/nixpkgs | sed 's/.*\.\(.*\)\/nixpkgs/\1/')
        nox-review wip --against $built_rev
    fi
else
    echo "$0: Unknown option $1" >&2
    false
fi
