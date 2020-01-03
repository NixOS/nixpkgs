{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = config.services.connman;
  configFile = pkgs.writeText "connman.conf" ''
    [General]
    NetworkInterfaceBlacklist=${concatStringsSep "," cfg.networkInterfaceBlacklist}

    ${cfg.extraConfig}
  '';
in {

  imports = [
    (mkRenamedOptionModule [ "networking" "connman" ] [ "services" "connman" ])
  ];

  ###### interface

  options = {

    services.connman = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use ConnMan for managing your network connections.
        '';
      };

      enableVPN = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable ConnMan VPN service.
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
        type = with types; listOf str;
        default = [ "vmnet" "vboxnet" "virbr" "ifb" "ve" ];
        description = ''
          Default blacklisted interfaces, this includes NixOS containers interfaces (ve).
        '';
      };

      extraFlags = mkOption {
        type = with types; listOf str;
        default = [ ];
        example = [ "--nodnsproxy" ];
        description = ''
          Extra flags to pass to connmand
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [{
      assertion = !config.networking.useDHCP;
      message = "You can not use services.connman with networking.useDHCP";
    }{
      assertion = config.networking.wireless.enable;
      message = "You must use services.connman with networking.wireless";
    }{
      assertion = !config.networking.networkmanager.enable;
      message = "You can not use services.connman with networking.networkmanager";
    }];

    environment.systemPackages = [ connman ];

    systemd.services.connman = {
      description = "Connection service";
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "net.connman";
        Restart = "on-failure";
        ExecStart = "${pkgs.connman}/sbin/connmand --config=${configFile} --nodaemon ${toString cfg.extraFlags}";
        StandardOutput = "null";
      };
    };

    systemd.services.connman-vpn = mkIf cfg.enableVPN {
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

    systemd.services.net-connman-vpn = mkIf cfg.enableVPN {
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
  };
}
