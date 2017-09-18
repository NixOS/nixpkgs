#! /usr/bin/env bash
set -e

while test -n "$1"; do

    # tell Travis to use folding
    echo -en "travis_fold:start:$1\r"

    case $1 in

        nixpkgs-verify)
            echo "=== Verifying that nixpkgs evaluates..."

            nix-env -f. -qa --json > /dev/null
            ;;

        nixos-options)
            echo "=== Checking NixOS options"

            nix-build nixos/release.nix -A options --show-trace -Q
            ;;

        nixos-manual)
            echo "=== Checking NixOS manuals"

            nix-build nixos/release.nix -A manual --show-trace -Q
            ;;

        nixpkgs-manual)
            echo "=== Checking nixpkgs manuals"

            nix-build pkgs/top-level/release.nix -A manual --show-trace -Q
            ;;

        nixpkgs-tarball)
            echo "=== Checking nixpkgs tarball creation"

            nix-build pkgs/top-level/release.nix -A tarball --show-trace -Q
            ;;

        nixpkgs-unstable)
            echo "=== Checking nixpkgs unstable job"

            nix-instantiate pkgs/top-level/release.nix -A unstable \
                                                       --show-trace -Q
            ;;

        nixpkgs-lint)
            echo "=== Checking nixpkgs lint"

            nix-shell -p nixpkgs-lint \
                      --run "nixpkgs-lint -f $TRAVIS_BUILD_DIR"
            ;;

        nox)
            # build nox (+ a basic nix-shell env) silently so it's not in the
            # log
            nix-build '<nixpkgs>' -A nox -Q > /dev/null

            args=""
            if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
                echo "=== Build $TRAVIS_BRANCH branch"
                args="wip --against $TRAVIS_BRANCH^"
            else
                echo "=== Building pull request #$TRAVIS_PULL_REQUEST"

                args="pr --no-merge --slug $TRAVIS_REPO_SLUG"
                if [ -n "$GITHUB_TOKEN" ]; then
                    args="$args --token $GITHUB_TOKEN"
                fi
                args="$args $TRAVIS_PULL_REQUEST"
            fi

            nix-shell -p nox --run "nox-review $args"
            ;;

        *)
            echo "Skipping unknown option $1"
            ;;
    esac

    echo -en "travis_fold:end:$1\r"
    shift
done
