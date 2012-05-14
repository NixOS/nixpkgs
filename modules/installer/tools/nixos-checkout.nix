# This module generates the nixos-checkout script, which replaces the
# NixOS and Nixpkgs source trees in /etc/nixos/{nixos,nixpkgs} with
# Subversion checkouts.

{config, pkgs, ...}:

with pkgs.lib;

let

  nixosCheckout = pkgs.substituteAll {
    name = "nixos-checkout";
    dir = "bin";
    isExecutable = true;
    src = pkgs.writeScript "nixos-checkout"
      ''
        #! ${pkgs.stdenv.shell} -e
        
        prefix="$1"
        if [ -z "$prefix" ]; then prefix=/etc/nixos; fi
        mkdir -p "$prefix"
        cd "$prefix"

        # Move any old nixos or nixpkgs directories out of the way.
        backupTimestamp=$(date "+%Y%m%d%H%M%S")

        if test -e nixos -a ! -e nixos/.svn; then
            mv nixos nixos-$backupTimestamp
        fi

        if test -e nixpkgs -a ! -e nixpkgs/.svn; then
            mv nixpkgs nixpkgs-$backupTimestamp
        fi

        # Check out the NixOS and Nixpkgs sources.
        ${pkgs.subversion}/bin/svn co https://nixos.org/repos/nix/nixos/trunk nixos
        ${pkgs.subversion}/bin/svn co https://nixos.org/repos/nix/nixpkgs/trunk nixpkgs
      '';
   };

in

{
  environment.systemPackages =
    [ nixosCheckout
      # Since the checkout script depends on Subversion, we may as
      # well put it in $PATH.
      pkgs.subversion
    ];
}
