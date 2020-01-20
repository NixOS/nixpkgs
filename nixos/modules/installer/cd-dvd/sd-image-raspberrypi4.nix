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
    firmwareSize = 128;
    # /var/empty is needed for some services, such as sshd
    populateRootCommands = "mkdir -p ./files/var/empty";
  };

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;

	fileSystems = lib.mkForce {
		"/boot" = {
			device = "/dev/disk/by-label/FIRMWARE";
			fsType = "vfat";
		};
		"/" = {
			device = "/dev/disk/by-label/NIXOS_SD";
			fsType = "ext4";
		};
	};
}
