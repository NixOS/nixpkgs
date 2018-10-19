# acpi_call makes tlp work for newer thinkpads

{ config, ... }:

{
  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}
