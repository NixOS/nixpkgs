# This module generates the nixos-checkout script, which performs a
# checkout of the Nixpkgs Git repository.

{ config, lib, pkgs, ... }:

with lib;

let

  nixosCheckout = pkgs.substituteAll {
    name = "nixos-checkout";
    dir = "bin";
    isExecutable = true;
    src = pkgs.writeScript "nixos-checkout"
      ''
        #! ${pkgs.stdenv.shell} -e

        if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
          echo "Usage: `basename $0` [PREFIX]. See NixOS Manual for more info."
          exit 0
        fi

        prefix="$1"
        if [ -z "$prefix" ]; then prefix=/etc/nixos; fi
        mkdir -p "$prefix"
        cd "$prefix"

        if [ -z "$(type -P git)" ]; then
            echo "installing Git..."
            nix-env -iA nixos.git
        fi

        # Move any old nixpkgs directories out of the way.
        backupTimestamp=$(date "+%Y%m%d%H%M%S")

        if [ -e nixpkgs -a ! -e nixpkgs/.git ]; then
            mv nixpkgs nixpkgs-$backupTimestamp
        fi

        # Check out the Nixpkgs sources.
        if ! [ -e nixpkgs/.git ]; then
            echo "Creating repository in $prefix/nixpkgs..."
            git init --quiet nixpkgs
        else
            echo "Updating repository in $prefix/nixpkgs..."
        fi
        cd nixpkgs
        git remote add origin git://github.com/NixOS/nixpkgs.git || true
        git remote add channels git://github.com/NixOS/nixpkgs-channels.git || true
        git remote set-url origin --push git@github.com:NixOS/nixpkgs.git
        git remote update
        git checkout master
      '';
   };

in

{
  environment.systemPackages = [ nixosCheckout ];
}
