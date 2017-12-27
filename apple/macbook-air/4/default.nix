{ lib, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel/sandy-bridge
  ];

  boot.kernelParams = [
    "acpi_backlight=vendor"
  ];

  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
  '';
}
