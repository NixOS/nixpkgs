# Upower daemon.

{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.upower = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable Upower, a DBus service that provides power
          management support to applications.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.upower.enable {

    environment.systemPackages = [ pkgs.upower ];

    services.dbus.packages = [ pkgs.upower ];

    services.udev.packages = [ pkgs.upower ];

    systemd.services.upower =
      { description = "Power Management Daemon";
        path = [ pkgs.glib ]; # needed for gdbus
        serviceConfig =
          { Type = "dbus";
            BusName = "org.freedesktop.UPower";
            ExecStart = "@${pkgs.upower}/libexec/upowerd upowerd";
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
        ${config.system.build.systemd}/bin/systemctl try-restart upower
      '';

  };

}
