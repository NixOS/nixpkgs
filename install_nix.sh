#!/bin/sh

# This script installs the Nix package manager on your system by
# downloading a binary distribution and running its installer script
# (which in turn creates and populates /nix).

{ # Prevent execution if this script was only partially downloaded
oops() {
    echo "$0:" "$@" >&2
    exit 1
}

umask 0022

tmpDir="$(mktemp -d -t nix-binary-tarball-unpack.XXXXXXXXXX || \
          oops "Can't create temporary directory for downloading the Nix binary tarball")"
cleanup() {
    rm -rf "$tmpDir"
}
trap cleanup EXIT INT QUIT TERM

require_util() {
    command -v "$1" > /dev/null 2>&1 ||
        oops "you do not have '$1' installed, which I need to $2"
}

case "$(uname -s).$(uname -m)" in
    Linux.x86_64)
        hash=c3fe29778acaa93b5095ee66e36f11ec7c6a284c40970a24cc83ac4f04809db3
        path=k6lygsiw1mfizfd9vk5hlinb1l8icyix/nix-2.35.1-x86_64-linux.tar.xz
        system=x86_64-linux
        ;;
    Linux.i?86)
        hash=e8dff06a2bd3e7286cc7ff820603d7b56200983a4a91a84a61c52b711346e904
        path=ijp3dcg840b2h4076zppc2cnn61gzz09/nix-2.35.1-i686-linux.tar.xz
        system=i686-linux
        ;;
    Linux.aarch64)
        hash=79b739996f1751573b4d2b56e4ae607855184c711f2cc1274fa0952a13d4bfc9
        path=pzxr7zbby089dqlm173haj6jjg29aii5/nix-2.35.1-aarch64-linux.tar.xz
        system=aarch64-linux
        ;;
    Linux.armv6l)
        hash=483c245c93f453205d5d0e799efdfb20388625c0edb3487d9aea215724fb383b
        path=361awhq7w3abvqwvfkdzgns1yg3yhzlz/nix-2.35.1-armv6l-linux.tar.xz
        system=armv6l-linux
        ;;
    Linux.armv7l)
        hash=1f61ef952f285aecb977b47eafea8e83bfea2ed51a884fffdef5eb95ddb45cf3
        path=9kxhf0cd14rzb3fh3h6p5456qv25i2xg/nix-2.35.1-armv7l-linux.tar.xz
        system=armv7l-linux
        ;;
    Linux.riscv64)
        hash=cfdca9d248b974ef267edcd9cd1284921d830eae1a5e32bc3e6df52d89ba1d71
        path=sg1n8dvyz8hb6gwpacfrbdgwkp68mqb9/nix-2.35.1-riscv64-linux.tar.xz
        system=riscv64-linux
        ;;
    Darwin.x86_64)
        hash=1a932047a6e563acbd86024599bb377cbceca4dc6934a49f62a41ea1d9bdcb1b
        path=chizk45jlbbvwa5vsy0g9p2zwynfqhrc/nix-2.35.1-x86_64-darwin.tar.xz
        system=x86_64-darwin
        ;;
    Darwin.arm64|Darwin.aarch64)
        hash=414e073c4754e0c9eed1dd25e482af45213a34aa67c930201e35df7c8333c19a
        path=w72n0my0gd6hvxsca7hwbxr0xxsi4p43/nix-2.35.1-aarch64-darwin.tar.xz
        system=aarch64-darwin
        ;;
    FreeBSD.amd64|FreeBSD.x86_64)
        hash=779cfd9b552e1afcdfcde978ee87e0538ed7ad5479f53318f05125009d2ba1e5
        path=3r8xab9wvarb756kxrqzicnvnciif9mb/nix-2.35.1-x86_64-freebsd.tar.xz
        system=x86_64-freebsd
        ;;
    *) oops "sorry, there is no binary distribution of Nix for your platform";;
esac

# Use this command-line option to fetch the tarballs using nar-serve or Cachix
if [ "${1:-}" = "--tarball-url-prefix" ]; then
    if [ -z "${2:-}" ]; then
        oops "missing argument for --tarball-url-prefix"
    fi
    url=${2}/${path}
    shift 2
else
    url=https://releases.nixos.org/nix/nix-2.35.1/nix-2.35.1-$system.tar.xz
fi

tarball=$tmpDir/nix-2.35.1-$system.tar.xz

require_util tar "unpack the binary tarball"
if [ "$(uname -s)" != "Darwin" ]; then
    require_util xz "unpack the binary tarball"
fi

if command -v curl > /dev/null 2>&1; then
    fetch() { curl --fail -L "$1" -o "$2"; }
elif command -v wget > /dev/null 2>&1; then
    fetch() { wget "$1" -O "$2"; }
else
    oops "you don't have wget or curl installed, which I need to download the binary tarball"
fi

echo "downloading Nix 2.35.1 binary tarball for $system from '$url' to '$tmpDir'..."
fetch "$url" "$tarball" || oops "failed to download '$url'"

if command -v sha256sum > /dev/null 2>&1; then
    hash2="$(sha256sum -b "$tarball" | cut -c1-64)"
elif command -v shasum > /dev/null 2>&1; then
    hash2="$(shasum -a 256 -b "$tarball" | cut -c1-64)"
elif command -v openssl > /dev/null 2>&1; then
    hash2="$(openssl dgst -r -sha256 "$tarball" | cut -c1-64)"
else
    oops "cannot verify the SHA-256 hash of '$url'; you need one of 'shasum', 'sha256sum', or 'openssl'"
fi

if [ "$hash" != "$hash2" ]; then
    oops "SHA-256 hash mismatch in '$url'; expected $hash, got $hash2"
fi

unpack=$tmpDir/unpack
mkdir -p "$unpack"
tar -xJf "$tarball" -C "$unpack" || oops "failed to unpack '$url'"

script=$(echo "$unpack"/*/install)

[ -e "$script" ] || oops "installation script is missing from the binary tarball!"
export INVOKED_FROM_INSTALL_IN=1
"$script" "$@"

} # End of wrapping
