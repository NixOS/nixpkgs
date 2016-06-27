#! /usr/bin/env bash
set -e

# This should make Curl silent
# but download-from-binary-cache doesn't respect
export NIX_CURL_FLAGS=-sS

if [ -d $HOME/.nix-profile ]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

while test -n "$1"; do

    # tell Travis to use folding
    echo -en "travis_fold:start:$1\r"

    case $1 in

        install)
            echo "=== Installing Nix..."

            curl -sS https://nixos.org/nix/install | sh

            # Make sure we can use hydra's binary cache
            sudo mkdir /etc/nix
            echo "build-max-jobs = 4" | sudo tee /etc/nix/nix.conf > /dev/null

            # Make sure we can execute within /tmp in Linux
            if [ "$TRAVIS_OS_NAME" == "linux" ]; then
                sudo mount -o remount,exec /run
                sudo mount -o remount,exec /run/user
                sudo mount > /dev/null
            fi
            ;;

        verify)
            echo "=== Verifying that nixpkgs evaluates..."

            nix-env --file $TRAVIS_BUILD_DIR --query --available --json > /dev/null
            ;;

        check)
            echo "=== Checking NixOS options"

            nix-build $TRAVIS_BUILD_DIR/nixos/release.nix --attr options --show-trace
            ;;

	tarball)
            echo "=== Checking tarball creation"

            nix-build $TRAVIS_BUILD_DIR/pkgs/top-level/release.nix --attr tarball --show-trace
            ;;

        pr)
            if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
                echo "=== No pull request found"
            else
                echo "=== Building pull request #$TRAVIS_PULL_REQUEST"

                nix-shell --packages nox git --run "nox-review pr $TRAVIS_PULL_REQUEST" -I nixpkgs=$TRAVIS_BUILD_DIR
            fi
            ;;

        *)
            echo "Skipping unknown option $1"
            ;;
    esac

    echo -en "travis_fold:end:$1\r"
    shift
done
