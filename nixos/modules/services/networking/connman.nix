{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = config.networking.connman;

in {

  ###### interface

  options = {

    networking.connman = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use ConnMan for managing your network connections.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [{
      assertion = config.networking.useDHCP == false;
      message = "You can not use services.networking.connman with services.networking.useDHCP";
    }{
      assertion = config.networking.wireless.enable == true;
      message = "You must use services.networking.connman with services.networking.wireless";
    }{
      assertion = config.networking.networkmanager.enable == false;
      message = "You can not use services.networking.connman with services.networking.networkmanager";
    }];

    environment.systemPackages = [ connman ];

    systemd.services."connman" = {
      description = "Connection service";
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "net.connman";
        Restart = "on-failure";
        ExecStart = "${pkgs.connman}/sbin/connmand --nodaemon";
        StandardOutput = "null";
      };
    };

    systemd.services."connman-vpn" = {
      description = "ConnMan VPN service";
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" ];
      before = [ "connman" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "net.connman.vpn";
        ExecStart = "${pkgs.connman}/sbin/connman-vpnd -n";
        StandardOutput = "null";
      };
    };

    systemd.services."net-connman-vpn" = {
      description = "D-BUS Service";
      serviceConfig = {
        Name = "net.connman.vpn";
        before = [ "connman" ];
        ExecStart = "${pkgs.connman}/sbin/connman-vpnd -n";
        User = "root";
        SystemdService = "connman-vpn.service";
      };
    };

    networking = {
      useDHCP = false;
      wireless.enable = true;
      networkmanager.enable = false;
    };

    powerManagement.resumeCommands = ''
      systemctl restart connman
    '';

  };
}
