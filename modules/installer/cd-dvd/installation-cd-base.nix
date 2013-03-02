# This module contains the basic configuration for building a NixOS
# installation CD.

{ config, pkgs, ... }:

with pkgs.lib;

let

  # We need a copy of the Nix expressions for Nixpkgs and NixOS on the
  # CD.  These are installed into the "nixos" channel of the root
  # user, as expected by nixos-rebuild/nixos-install.
  channelSources = pkgs.runCommand "nixos-${config.system.nixosVersion}"
    { expr = builtins.readFile ../../../lib/channel-expr.nix; }
    ''
      mkdir -p $out/nixos
      cp -prd ${cleanSource ../../..} $out/nixos/nixos
      cp -prd ${cleanSource <nixpkgs>} $out/nixos/nixpkgs
      chmod -R u+w $out/nixos/nixos
      echo -n ${config.system.nixosVersion} > $out/nixos/nixos/.version
      echo -n "" > $out/nixos/nixos/.version-suffix
      echo "$expr" > $out/nixos/default.nix
    '';

  includeSources = true;

in

{
  require =
    [ ./memtest.nix
      ./iso-image.nix

      # Profiles of this basic installation CD.
      ../../profiles/all-hardware.nix
      ../../profiles/base.nix
      ../../profiles/installation-device.nix
    ];

  # ISO naming.
  isoImage.isoName = "${config.isoImage.isoBaseName}-${config.system.nixosVersion}-${pkgs.stdenv.system}.iso";

  isoImage.volumeID = "NIXOS_${config.system.nixosVersion}";

  # Provide the NixOS/Nixpkgs sources in /etc/nixos.  This is required
  # for nixos-install.
  boot.postBootCommands = optionalString includeSources
    ''
      echo "unpacking the NixOS/Nixpkgs sources..."
      mkdir -p /nix/var/nix/profiles/per-user/root
      ${config.environment.nix}/bin/nix-env -p /nix/var/nix/profiles/per-user/root/channels -i ${channelSources} --quiet
      mkdir -m 0700 -p /root/.nix-defexpr
      ln -s /nix/var/nix/profiles/per-user/root/channels /root/.nix-defexpr/channels
    '';

  # Make the installer more likely to succeed in low memory
  # environments.  The kernel's overcommit heustistics bite us
  # fairly often, preventing processes such as nix-worker or
  # download-using-manifests.pl from forking even if there is
  # plenty of free memory.
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  # To speed up installation a little bit, include the complete stdenv
  # in the Nix store on the CD.
  isoImage.storeContents = [ pkgs.stdenv pkgs.busybox ];
}
