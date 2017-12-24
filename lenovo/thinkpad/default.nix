{ lib, pkgs, ... }:

{
  hardware.trackpoint.enable = lib.mkDefault true;
  services.tlp.enable = lib.mkDefault true;
  services.xserver.libinput.enable = lib.mkDefault true;

  # Fingerprint reader: login and unlock with fingerprint (if you add one with `fprintd-enroll`)
  # services.fprintd.enable = true;
}
