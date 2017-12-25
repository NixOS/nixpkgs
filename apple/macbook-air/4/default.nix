{ lib, ... }:

{
  imports = [ ../. ];

  boot.kernelParams = [
    "acpi_backlight=vendor"
  ];

  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
  '';
}
