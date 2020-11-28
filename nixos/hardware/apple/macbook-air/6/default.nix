{ config, lib, ... }:

{
  imports = [ ../. ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ mba6x_bl ];
    kernelModules = [ "mba6x_bl" ];

    # Divides power consumption by two.
    kernelParams = [ "acpi_osi=" ];
  };

  services.xserver.deviceSection = lib.mkDefault ''
    Option "Backlight" "mba6x_backlight"
    Option "TearFree" "true"
  '';
}
