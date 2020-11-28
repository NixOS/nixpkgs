{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
  ];

  # https://wiki.archlinux.org/index.php/TLP#Btrfs
  services.tlp.extraConfig = ''
    SATA_LINKPWR_ON_BAT=med_power_with_dipm
  '';
}
