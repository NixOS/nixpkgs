# nix-build '<nixpkgs/nixos>' -A config.system.build.openstackImage --arg configuration "{ imports = [ ./nixos/maintainers/scripts/openstack/openstack-image.nix ]; }"

{ config, lib, pkgs, ... }:

with lib;

{
  imports =
    [ ../../../modules/installer/cd-dvd/channel.nix
      ../../../modules/virtualisation/openstack-config.nix
    ];

  system.build.openstackImage = import ../../../lib/make-disk-image.nix {
    inherit lib config;
    pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    diskSize = 8192;
    format = "qcow2";
    configFile = pkgs.writeText "configuration.nix"
      ''
        {
          imports = [ <nixpkgs/nixos/modules/virtualisation/openstack-config.nix> ];
        }
      '';
  };

}
