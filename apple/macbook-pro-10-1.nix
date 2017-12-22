{ config, pkgs, ... }:

{
  imports =
    [ ../lib/kernel-version.nix
    ];

  # Use the systemd-boot efi boot loader. (From default generated configuration.nix)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # I use this but not sure whether its needed.
  # Right click does *NOT* work
  services.xserver.libinput.enable = true;

  kernelAtleast =
    [ { version = "4.7"; msg = "Broadcom WiFi confirmed not to work."; }
    ];

  # Couldn't get X to work with nvidia
  # Also, PTYs don't work after X/nvidia starts
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  # Seems to improve battery life *and* keep the CPU cooler
  services.mbpfan.enable = true;
}
