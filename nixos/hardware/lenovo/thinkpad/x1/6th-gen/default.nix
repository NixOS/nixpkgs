# A good source of information about how to fix the issues still
# standing with kernel 4.6.11 is the following wiki page:
# https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6). The
# TrackPoint and TouchPad issues there seem to have been fixed already.
#
# Enable the lower-power S3 suspend state by upgrading the BIOS to version >= 1.30,
# then manually selecting Linux in the power management section.
{ config, pkgs, lib, ... }:
{
  imports = [
    ../.
    ../../../../common/pc/laptop/acpi_call.nix
  ];

  # New ThinkPads have a different TrackPoint manufacturer/name.
  # See also https://certification.ubuntu.com/catalog/component/input/5313/input%3ATPPS/2ElanTrackPoint/
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";

  services.throttled.enable = lib.mkDefault true;
}
