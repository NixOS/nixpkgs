# A good source of information about how to fix the issues still
# standing with kernel 4.6.11 is the following wiki page:
# https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6). The
# TrackPoint and TouchPad issues there seem to have been fixed already.

{ config, pkgs, ... }:
{
  imports = [
    ../.
    ../../cpu-throttling-bug.nix
    ../../acpi_call.nix
  ];

  # See https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
  services.tlp.extraConfig = ''
    START_CHARGE_THRESH_BAT0=75
    STOP_CHARGE_THRESH_BAT0=80
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
    ENERGY_PERF_POLICY_ON_BAT=powersave
  '';

  # Enable S3 suspend state: you have to manually follow the
  # instructions shown here: https://delta-xi.net/#056 in order to
  # produce the ACPI patched table. Put the CPIO archive in /boot and
  # then enable the following lines
  # boot.kernelParams = [
  #   "mem_sleep_default=deep"
  # ];
  # boot.initrd.prepend = [
  #   "${/boot/acpi_override}"
  # ];
}
