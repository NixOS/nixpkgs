{
  imports = [
    ../.
  ];
  # Give TLP service more control over battery
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
    kernelModules = [
      "acpi_call"
    ];
  };

  # See https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
  services.tlp.extraConfig = ''
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
'';
}
