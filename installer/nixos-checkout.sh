#! @shell@ -e
set -x

# Obtain Subversion.
nix-channel --add http://nix.cs.uu.nl/dist/nix/channels-v3/nixpkgs-unstable
nix-channel --update
nix-env -i subversion

cd /etc/nixos

# Move any old nixos or nixpkgs directories out of the way.
backupTimestamp=$(date "+%Y%m%d%H%M%S")

if test -e nixos -a ! -e nixos/.svn; then
    mv nixos nixos-$backupTimestamp
fi

if test -e nixpkgs -a ! -e nixpkgs/.svn; then
    mv nixpkgs nixpkgs-$backupTimestamp
fi

# Check out the NixOS and Nixpkgs sources.
svn co https://svn.cs.uu.nl:12443/repos/trace/nixos/trunk nixos
svn co https://svn.cs.uu.nl:12443/repos/trace/nixpkgs/trunk nixpkgs

# A few symlink.
ln -sfn ../nixpkgs/pkgs nixos/pkgs
ln -sfn nixpkgs/pkgs/top-level/all-packages.nix install-source.nix
