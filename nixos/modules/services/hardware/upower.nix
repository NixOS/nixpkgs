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

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.upower ];

    services.dbus.packages = [ pkgs.upower ];

    services.udev.packages = [ pkgs.upower ];

    systemd.services.upower =
      { description = "Power Management Daemon";
        path = [ pkgs.glib.out ]; # needed for gdbus
        serviceConfig =
          { Type = "dbus";
            BusName = "org.freedesktop.UPower";
            ExecStart = "@${pkgs.upower}/libexec/upowerd upowerd";
            Restart = "on-failure";
            # Upstream lockdown:
            # Filesystem lockdown
            ProtectSystem = "strict";
            # Needed by keyboard backlight support
            ProtectKernelTunables = false;
            ProtectControlGroups = true;
            ReadWritePaths = "/var/lib/upower";
            ProtectHome = true;
            PrivateTmp = true;

            # Network
            # PrivateNetwork=true would block udev's netlink socket
            RestrictAddressFamilies = "AF_UNIX AF_NETLINK";

            # Execute Mappings
            MemoryDenyWriteExecute = true;

            # Modules
            ProtectKernelModules = true;

            # Real-time
            RestrictRealtime = true;

            # Privilege escalation
            NoNewPrivileges = true;
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
