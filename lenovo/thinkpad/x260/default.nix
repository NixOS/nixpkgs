{
  imports = [
    ../.
    ../acpi_call.nix
    ../../../common/cpu/intel
  ];

  # See https://linrunner.de/en/tlp/docs/tlp-faq.html#battery https://wiki.archlinux.org/index.php/TLP#Btrfs
  services.tlp.extraConfig = ''
    START_CHARGE_THRESH_BAT0=75
    STOP_CHARGE_THRESH_BAT0=80
    START_CHARGE_THRESH_BAT1=75
    STOP_CHARGE_THRESH_BAT1=80

    SATA_LINKPWR_ON_BAT=max_performance

    CPU_SCALING_GOVERNOR_ON_BAT=powersave
    ENERGY_PERF_POLICY_ON_BAT=powersave
  '';
}
