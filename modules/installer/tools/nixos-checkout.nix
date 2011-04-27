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
        svn co https://svn.nixos.org/repos/nix/nixos/trunk nixos
        svn co https://svn.nixos.org/repos/nix/nixpkgs/trunk nixpkgs
      '';
   };
  
in

{
  environment.systemPackages = [ nixosCheckout ];
}
