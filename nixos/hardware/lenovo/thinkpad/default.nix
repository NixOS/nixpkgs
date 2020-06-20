{ config, lib, pkgs, ... }:

{
  imports = [ ../../common/pc/laptop ];

  hardware.trackpoint.enable = lib.mkDefault true;
  hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;

  # Fingerprint reader: login and unlock with fingerprint (if you add one with `fprintd-enroll`)
  # services.fprintd.enable = true;
}
