#! /usr/bin/env bash
set -e

while test -n "$1"; do

    # tell Travis to use folding
    echo -en "travis_fold:start:$1\r"

    case $1 in

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

                token=""
                if [ -n "$GITHUB_TOKEN" ]; then
                    token="--token $GITHUB_TOKEN"
                fi

                nix-shell --packages nox git --run "nox-review pr --slug $TRAVIS_REPO_SLUG $token $TRAVIS_PULL_REQUEST" -I nixpkgs=$TRAVIS_BUILD_DIR
            fi
            ;;

        *)
            echo "Skipping unknown option $1"
            ;;
    esac

    echo -en "travis_fold:end:$1\r"
    shift
done
