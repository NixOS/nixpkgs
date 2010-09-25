# This module contains the basic configuration for building a NixOS
# installation CD.

{ config, pkgs, ... }:

with pkgs.lib;

let

  # We need a copy of the Nix expressions for Nixpkgs and NixOS on the
  # CD.  We put them in a tarball because accessing that many small
  # files from a slow device like a CD-ROM takes too long.  !!! Once
  # we use squashfs, maybe we won't need this anymore.
  makeTarball = tarName: input: pkgs.runCommand "tarball" {inherit tarName;}
    ''
      ensureDir $out
      (cd ${input} && tar cvfj $out/${tarName} . \
        --exclude '*~' --exclude 'result')
    '';

  # Put the current directory in a tarball.
  nixosTarball = makeTarball "nixos.tar.bz2" (cleanSource ../../..);

  # Put Nixpkgs in a tarball.
  nixpkgsTarball = makeTarball "nixpkgs.tar.bz2" (cleanSource pkgs.path);

  includeSources = true;
  
in

{
  require =
    [ ./memtest.nix
      ./iso-image.nix

      # Profiles of this basic installation CD.
      ../../profiles/base.nix
      ../../profiles/installation-device.nix
    ];

  # ISO naming.
  isoImage.isoName = "nixos-${config.system.nixosVersion}-${pkgs.stdenv.system}.iso";
    
  isoImage.volumeID = "NIXOS_INSTALL_CD_${config.system.nixosVersion}";
  
  boot.postBootCommands =
    ''
      export PATH=${pkgs.gnutar}/bin:${pkgs.bzip2}/bin:$PATH

      # Provide the NixOS/Nixpkgs sources in /etc/nixos.  This is required
      # for nixos-install.
      ${optionalString includeSources ''
        echo "unpacking the NixOS/Nixpkgs sources..."
        mkdir -p /etc/nixos/nixos
        tar xjf ${nixosTarball}/nixos.tar.bz2 -C /etc/nixos/nixos
        mkdir -p /etc/nixos/nixpkgs
        tar xjf ${nixpkgsTarball}/nixpkgs.tar.bz2 -C /etc/nixos/nixpkgs
        chown -R root.root /etc/nixos
     ''}
    '';

  # To speed up installation a little bit, include the complete stdenv
  # in the Nix store on the CD.
  isoImage.storeContents = [ pkgs.stdenv pkgs.klibc pkgs.klibcShrunk ];
}
