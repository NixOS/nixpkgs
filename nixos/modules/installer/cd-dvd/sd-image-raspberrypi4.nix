# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/cd-dvd/sd-image-raspberrypi4.nix -A config.system.build.sdImage
{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles/base.nix
    ../../profiles/installation-device.nix
    ./sd-image.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  boot.consoleLogLevel = lib.mkDefault 7;

  sdImage = {
    # This is a hack to avoid replicating config.txt from boot.loader.raspberryPi
    populateBootCommands =
      "${config.system.build.installBootLoader} ${config.system.build.toplevel} -d ./boot";
  };

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;
}
