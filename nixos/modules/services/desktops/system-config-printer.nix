{
  config,
  pkgs,
  lib,
  ...
}:
{

  ###### interface

  options = {

    services.system-config-printer = {

      enable = lib.mkEnableOption "system-config-printer, a service for CUPS administration used by printing interfaces";

    };

  };

  ###### implementation

  config = lib.mkIf config.services.system-config-printer.enable {

    services.dbus.packages = [
      pkgs.system-config-printer
    ];

    systemd.packages = [
      pkgs.system-config-printer
    ];

    services.udev.packages = [
      pkgs.system-config-printer
    ];

    # for $out/bin/install-printer-driver
    # TODO: Enable once #177946 is resolved
    # services.packagekit.enable = true;

  };

}
