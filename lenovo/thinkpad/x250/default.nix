{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  # Thinkfan is enabled by thinkpad profile.
  # However it requires to set a different `sensor` for this hardware, since there is no /proc/acpi/ibm/thermal
  # Regulation also works fine without thinkfan daemon though.
  services.thinkfan.enable = lib.mkOverride 900 false;

  # maintainers: Mic92
}
