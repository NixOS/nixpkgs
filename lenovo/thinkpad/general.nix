{ pkgs, lib, ... }:

with lib;

{
  hardware.trackpoint = mkDefault {
    enable = true;
    emulateWheel = true;
  };

  hardware.enableRedistributableFirmware = mkDefault true;
  services.tlp.enable = true;

  services.xserver = mkDefault {
    synaptics.enable = false;
    libinput.enable = true;
  };

  environment.systemPackages = [ pkgs.acpi ];

  sound.enableMediaKeys = mkDefault true;
}
