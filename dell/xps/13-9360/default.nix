{ lib, pkgs, ... }:
let
  firmware_qca6174 = pkgs.callPackage ./firmware_qca6174.nix {};
in
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];
  boot.kernelModules = ["kvm-intel"]; # should this be in common/cpu/intel?
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    # touchpad goes over i2c
    blacklistedKernelModules = [ "psmouse" ];

    kernelParams = [ "i915.enable_fbc=1" "i915.enable_psr=2" ];
  };
  
  # intel huc, guc. qca6174 (old?)
  hardware.enableRedistributableFirmware = true;

  # 4k screen, use bigger console font
  i18n.consoleFont = "latarcyrheb-sun32";

  # touchpad
  services.xserver.libinput.enable = lib.mkDefault true;

  networking.wireless.enable = lib.mkDefault true;
  hardware.bluetooth.enable = lib.mkDefault true;
  
  services.thermald.enable = lib.mkDefault true;

  # optional: without it, firmware crashes happened
  hardware.firmware = lib.mkBefore [ firmware_qca6174 ];

}
