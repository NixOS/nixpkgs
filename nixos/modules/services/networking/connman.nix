{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = config.networking.connman;
  configFile = pkgs.writeText "connman.conf" ''
    [General]
    NetworkInterfaceBlacklist=${concatStringsSep "," cfg.networkInterfaceBlacklist}

    ${cfg.extraConfig}
  '';
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

      extraConfig = mkOption {
        type = types.lines;
        default = ''
        '';
        description = ''
          Configuration lines appended to the generated connman configuration file.
        '';
      };

      networkInterfaceBlacklist = mkOption {
        type = with types; listOf string;
        default = [ "vmnet" "vboxnet" "virbr" "ifb" "ve" ];
        description = ''
          Default blacklisted interfaces, this includes NixOS containers interfaces (ve).
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [{
      assertion = !config.networking.useDHCP;
      message = "You can not use services.networking.connman with services.networking.useDHCP";
    }{
      assertion = config.networking.wireless.enable;
      message = "You must use services.networking.connman with services.networking.wireless";
    }{
      assertion = !config.networking.networkmanager.enable;
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
        ExecStart = "${pkgs.connman}/sbin/connmand --config=${configFile} --nodaemon";
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
