# Usage:
# $ NIX_PATH=`pwd`:nixos-config=`pwd`/nixpkgs/nixos/modules/virtualisation/cloud-image.nix nix-build '<nixpkgs/nixos>' -A config.system.build.cloudImage

{ config, lib, pkgs, ... }:

with lib;

{
  system.build.cloudImage = import ../../lib/make-disk-image.nix {
    inherit pkgs lib config;
    partitioned = true;
    diskSize = 1 * 1024;
    configFile = pkgs.writeText "configuration.nix"
      ''
        { config, lib, pkgs, ... }:

        with lib;

        {
          imports = [ <nixpkgs/nixos/modules/virtualisation/cloud-image.nix> ];
        }
      '';
  };

  imports = [ ../profiles/qemu-guest.nix ];

  fileSystems."/".device = "/dev/disk/by-label/nixos";

  boot = {
    kernelParams = [ "console=ttyS0" ];
    loader.grub.device = "/dev/vda";
    loader.timeout = 0;
  };

  networking.hostName = mkDefault "";

  services.openssh = {
    enable = true;
    permitRootLogin = "without-password";
    passwordAuthentication = mkDefault false;
  };

  services.cloud-init.enable = true;
}
