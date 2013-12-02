# This module generates the nixos-checkout script, which replaces the
# Nixpkgs source trees in /etc/nixos/nixpkgs with a Git checkout.

{ config, pkgs, ... }:

with pkgs.lib;

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
            nix-env -iA nixos.pkgs.git || nix-env -i git
        fi

        # Move any old nixpkgs directories out of the way.
        backupTimestamp=$(date "+%Y%m%d%H%M%S")

        if [ -e nixpkgs -a ! -e nixpkgs/.git ]; then
            mv nixpkgs nixpkgs-$backupTimestamp
        fi

        # Check out the NixOS and Nixpkgs sources.
        git clone git://github.com/NixOS/nixpkgs.git nixpkgs
      '';
   };

in

{
  environment.systemPackages = [ nixosCheckout ];
}
