#! /usr/bin/env bash
set -e

while test -n "$1"; do

    # tell Travis to use folding
    echo -en "travis_fold:start:$1\r"

    case $1 in

        nixpkgs-verify)
            echo "=== Verifying that nixpkgs evaluates..."

            nix-env --file $TRAVIS_BUILD_DIR --query --available --json > /dev/null
            ;;

        nixos-options)
            echo "=== Checking NixOS options"

            nix-build $TRAVIS_BUILD_DIR/nixos/release.nix --attr options --show-trace
            ;;

        nixos-manual)
            echo "=== Checking NixOS manuals"

            nix-build $TRAVIS_BUILD_DIR/nixos/release.nix --attr manual --show-trace
            ;;

        nixpkgs-manual)
            echo "=== Checking nixpkgs manuals"

            nix-build $TRAVIS_BUILD_DIR/pkgs/top-level/release.nix --attr manual --show-trace
            ;;

        nixpkgs-tarball)
            echo "=== Checking nixpkgs tarball creation"

            nix-build $TRAVIS_BUILD_DIR/pkgs/top-level/release.nix --attr tarball --show-trace
            ;;

        nixpkgs-unstable)
            echo "=== Checking nixpkgs unstable job"

            nix-instantiate $TRAVIS_BUILD_DIR/pkgs/top-level/release.nix --attr unstable --show-trace
            ;;

        nixpkgs-lint)
            echo "=== Checking nixpkgs lint"

            nix-shell --packages nixpkgs-lint --run "nixpkgs-lint -f $TRAVIS_BUILD_DIR"
            ;;

        nox)
            echo "=== Fetching Nox from binary cache"

            # build nox (+ a basic nix-shell env) silently so it's not in the log
            nix-shell -p nox stdenv --command true
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

                nix-shell --packages nox --run "nox-review pr --slug $TRAVIS_REPO_SLUG $token $TRAVIS_PULL_REQUEST"
            fi
            ;;

        *)
            echo "Skipping unknown option $1"
            ;;
    esac

    echo -en "travis_fold:end:$1\r"
    shift
done
