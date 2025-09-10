{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.qgroundcontrol;
in
{

  options = {
    programs.qgroundcontrol = {
      enable = lib.mkEnableOption "qgroundcontrol";

      package = lib.mkPackageOption pkgs "qgroundcontrol" { };

      blacklistModemManagerFromTTYUSB = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Disallow ModemManager from interfering with serial connections that QGroundControl might use.

          Note that if you use a modem that's connected via USB, you might want to disable this option.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # ModemManager is known to interfere with serial connections;
    # QGC recommends disabling it, but we don't want to if we can avoid it
    # Instead, we blacklist tty devices using udev rules, which is a more targeted approach
    services.udev = lib.mkIf cfg.blacklistModemManagerFromTTYUSB {
      enable = true;
      extraRules = ''
        # nixos/qgroundcontrol: Blacklist ttyUSB devices from ModemManager
        SUBSYSTEM=="tty", KERNEL=="ttyUSB*", ENV{ID_MM_DEVICE_IGNORE}="1"
      '';
    };

    # Add to systemPackages for desktop entry file
    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = pkgs.qgroundcontrol.meta.maintainers;
}
