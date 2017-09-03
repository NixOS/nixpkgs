{ lib, ... }:

with lib;

{
  hardware.trackpoint = mkDefault {
    enable = true;
    emulateWheel = true;
  };

  hardware.enableAllFirmware = true;
}
