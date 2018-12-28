# A good source of information about how to fix the issues still
# standing with kernel 4.6.11 is the following wiki page:
# https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6). The
# TrackPoint and TouchPad issues there seem to have been fixed already.
#
# Enable the lower-power S3 suspend state by upgrading the BIOS to version >= 1.30,
# then manually selecting Linux in the power management section.
{ config, pkgs, ... }:
{
  imports = [
    ../.
    ../../../../common/pc/laptop/acpi_call.nix
    ../../../../common/pc/laptop/cpu-throttling-bug.nix
  ];

  # See https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
  services.tlp.extraConfig = ''
    START_CHARGE_THRESH_BAT0=75
    STOP_CHARGE_THRESH_BAT0=80
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
    ENERGY_PERF_POLICY_ON_BAT=powersave
  '';
}
