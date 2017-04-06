{ config, lib, pkgs, ... }:

with lib;

{
  imports =
    [ ../../../modules/installer/cd-dvd/channel.nix
      ../../../modules/virtualisation/nova-config.nix
    ];

  system.build.novaImage = import ../../../lib/make-disk-image.nix {
    inherit lib config;
    pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    diskSize = 8192;
    format = "qcow2";
    configFile = pkgs.writeText "configuration.nix"
      ''
        {
          imports = [ <nixpkgs/nixos/modules/virtualisation/nova-config.nix> ];
        }
      '';
  };

}
