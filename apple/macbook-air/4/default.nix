{
  imports = [ ../. ];

  boot.kernelParams = [
    "acpi_backlight=vendor"
  ];
}
