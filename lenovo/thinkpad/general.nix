{ pkgs, lib, ... }:

with lib;

{
  hardware.trackpoint = mkDefault {
    enable = true;
    emulateWheel = true;
  };

  hardware.enableRedistributableFirmware = mkDefault true;
  services.tlp.enable = true;

  services.xserver = {
    synaptics.enable = false;
    libinput.enable = true;
  };

  environment.systemPackages = [ pkgs.acpi ];

  sound.enableMediaKeys = true;
}
