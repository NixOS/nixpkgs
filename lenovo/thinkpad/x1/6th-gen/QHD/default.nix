# X1 6th generation with a QHD (2560x1440px) display
{ config,  ... }:

{
  imports = [
    ../.
  ];
  # give tlp more control over battery
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
    kernelModules = [
      "acpi_call"
    ];
  };

  # see https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
  services.tlp.extraConfig = ''
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
'';
  # fix font sizes in X
  services.xserver.dpi = 210;
  fonts.fontconfig.dpi = 210;
}
