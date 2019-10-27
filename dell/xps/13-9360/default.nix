{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
  ];

  boot.blacklistedKernelModules = [ "psmouse" ]; # touchpad goes over i2c

  # TODO: decide on boot loader policy
  boot.loader = {
    efi.canTouchEfiVariables = lib.mkDefault true;
    systemd-boot.enable = lib.mkDefault true;
  };

  hardware.firmware = lib.mkBefore [ pkgs.qca6174-firmware ];

  # TODO: move to general HiDPI profile
  i18n.consoleFont = lib.mkDefault "latarcyrheb-sun32"; # 4K screen, use bigger console font

  # TODO: upstream to NixOS/nixpkgs
  nixpkgs.overlays = [(final: previous: {
    qca6174-firmware = final.callPackage ./qca6174-firmware.nix {};
  })];

  # This will save you money and possibly your life!
  services.thermald.enable = true;
}
