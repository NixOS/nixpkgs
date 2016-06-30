#! /usr/bin/env bash
set -e

# This should make Curl silent
# but download-from-binary-cache doesn't respect
export NIX_CURL_FLAGS=-sS

##
## HARDCODED, needs to be updated with Nix
NIX_VERSION=1.11.2
case $TRAVIS_OS_NAME in
    linux)
        nix=/nix/store/4z8srway6dl128dxzn5r0wwdvglz3m61-nix-1.11.2
        export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
        ;;
    osx)
        nix=/nix/store/g7wllqq33dc8a8dsb6r71wrbd6mz3ykf-nix-1.11.2
        cacert=/nix/store/brfzgc99w9zyqj68i14w5jhyybg6j1sf-nss-cacert-3.21
        if [ -d $cacert ]; then
            export SSL_CERT_FILE=$cacert/etc/ssl/certs/ca-bundle.crt
        fi
        ;;
esac
##
##

while test -n "$1"; do

    # tell Travis to use folding
    echo -en "travis_fold:start:$1\r"

    case $1 in

        install)

            # Make sure we can use hydra's binary cache
            if [ ! -d /etc/nix/ ]; then
                sudo mkdir -p /etc/nix
                echo "build-max-jobs = 4" | sudo tee /etc/nix/nix.conf > /dev/null
            fi

            if [ ! -d /nix/ ]; then
                echo "=== Installing Nix..."

                case $TRAVIS_OS_NAME in
                    linux) system=x86_64-linux ;;
                    osx) system=x86_64-darwin ;;
                esac

                unpack=$HOME/nix-$NIX_VERSION-$system
                if [ ! -d $unpack/store/ ]; then
                    tarball=$HOME/nix-$NIX_VERSION-$system.tar.bz2
                    if [ ! -e $tarball ]; then
                        url="https://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-$system.tar.bz2"
                        echo "Downloading $url to file in $unpack"
                        curl -sSL $url -o $tarball
                    fi

                    echo "Extracting $tarball to Nix store closure in $HOME"
                    < $tarball bzcat | tar -x -C $HOME

                    echo "Removing $tarball"
                    rm -f $tarball
                fi

                sudo mkdir -m 0755 /nix/
                sudo chown $USER /nix/

                mkdir /nix/store/
                echo -n "Copying unpacked closure to nix store"
                for i in $(cd $unpack/store/ > /dev/null && echo *); do
                    echo -n "."
                    i_tmp="/nix/store/$i.$$"
                    if [ -e "$i_tmp" ]; then
                        rm -rf "$i_tmp"
                    fi
                    if ! [ -e "/nix/store/$i" ]; then
                        cp -Rp "$unpack/store/$i" "$i_tmp"
                        chmod -R a-w "$i_tmp"
                        chmod +w "$i_tmp"
                        mv "$i_tmp" "/nix/store/$i"
                        chmod -w "/nix/store/$i"
                    fi
                done
                echo

                echo "Initialising the database"
                $nix/bin/nix-store --init

                echo "Loading the database from the unpacked closure"
                $nix/bin/nix-store --load-db < $unpack/.reginfo
            fi
            ;;

        verify)
            echo "=== Verifying that nixpkgs evaluates..."

            $nix/bin/nix-env --file $TRAVIS_BUILD_DIR --query --available --json > /dev/null
            ;;

        check)
            echo "=== Checking NixOS options"

            $nix/bin/nix-build $TRAVIS_BUILD_DIR/nixos/release.nix --attr options --show-trace
            ;;

	tarball)
            echo "=== Checking tarball creation"

            $nix/bin/nix-build $TRAVIS_BUILD_DIR/pkgs/top-level/release.nix --attr tarball --show-trace
            ;;

        pr)
            if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
                echo "=== No pull request found"
            else
                echo "=== Building pull request #$TRAVIS_PULL_REQUEST"

                $nix/bin/nix-shell --packages nox git nix --run "nox-review pr $TRAVIS_PULL_REQUEST" -I nixpkgs=$TRAVIS_BUILD_DIR
            fi
            ;;

        *)
            echo "Skipping unknown option $1"
            ;;
    esac

    echo -en "travis_fold:end:$1\r"
    shift
done
