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
    sudo sh -c 'echo "build-max-jobs = 4" > /etc/nix/nix.conf'

    # Verify evaluation
    echo "=== Verifying that nixpkgs evaluates..."
    nix-env -f. -qa --json >/dev/null
elif [[ $1 == nox ]]; then
    echo "=== Installing nox..."
    git clone -q https://github.com/madjar/nox
    pip --quiet install -e nox
elif [[ $1 == build ]]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh

    echo "=== Checking tarball creation"
    nix-build pkgs/top-level/release.nix -A tarball

    if [[ $TRAVIS_PULL_REQUEST == false ]]; then
        echo "=== Not a pull request"
    else
        echo "=== Checking PR"

        if ! nox-review pr ${TRAVIS_PULL_REQUEST}; then
            if sudo dmesg | egrep 'Out of memory|Killed process' > /tmp/oom-log; then
                echo "=== The build failed due to running out of memory:"
                cat /tmp/oom-log
                echo "=== Please disregard the result of this Travis build."
            fi
            exit 1
        fi
    fi
else
    echo "$0: Unknown option $1" >&2
    false
fi
