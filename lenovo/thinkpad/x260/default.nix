{
  imports = [
    ../.
    ../acpi_call.nix
    ../../../common/cpu/intel
  ];

  # https://wiki.archlinux.org/index.php/TLP#Btrfs
  services.tlp.extraConfig = ''
    SATA_LINKPWR_ON_BAT=max_performance
  '';
}
