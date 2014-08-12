# Upower daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.upower;
in
{

  ###### interface

  options = {

    services.upower = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Upower, a DBus service that provides power
          management support to applications.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.upower;
        example = lib.literalExample "pkgs.upower";
        description = ''
          Which upower package to use.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.services.upower =
      { description = "Power Management Daemon";
        path = [ pkgs.glib ]; # needed for gdbus
        serviceConfig =
          { Type = "dbus";
            BusName = "org.freedesktop.UPower";
            ExecStart = "@${cfg.package}/libexec/upowerd upowerd";
          };
      };

    system.activationScripts.upower =
      ''
        mkdir -m 0755 -p /var/lib/upower
      '';

    # The upower daemon seems to get stuck after doing a suspend
    # (i.e. subsequent suspend requests will say "Sleep has already
    # been requested and is pending").  So as a workaround, restart
    # the daemon.
    powerManagement.resumeCommands =
      ''
        ${config.systemd.package}/bin/systemctl try-restart upower
      '';

  };

}
