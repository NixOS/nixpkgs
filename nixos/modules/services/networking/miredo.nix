{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.miredo;
  pidFile = "/run/miredo.pid";
  miredoConf = pkgs.writeText "miredo.conf" ''
    InterfaceName ${cfg.interfaceName}
    ServerAddress ${cfg.serverAddress}
    ${optionalString (cfg.bindAddress != null) "BindAddress ${cfg.bindAddress}"}
    ${optionalString (cfg.bindPort != null) "BindPort ${cfg.bindPort}"}
  '';
in
{

  ###### interface

  options = {

    services.miredo = {

      enable = mkEnableOption "the Miredo IPv6 tunneling service";

      package = mkOption {
        type = types.package;
        default = pkgs.miredo;
        defaultText = literalExpression "pkgs.miredo";
        description = lib.mdDoc ''
          The package to use for the miredo daemon's binary.
        '';
      };

      serverAddress = mkOption {
        default = "teredo.remlab.net";
        type = types.str;
        description = lib.mdDoc ''
          The hostname or primary IPv4 address of the Teredo server.
          This setting is required if Miredo runs as a Teredo client.
          "teredo.remlab.net" is an experimental service for testing only.
          Please use another server for production and/or large scale deployments.
        '';
      };

      interfaceName = mkOption {
        default = "teredo";
        type = types.str;
        description = lib.mdDoc ''
          Name of the network tunneling interface.
        '';
      };

      bindAddress = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          Depending on the local firewall/NAT rules, you might need to force
          Miredo to use a fixed UDP port and or IPv4 address.
        '';
      };

      bindPort = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          Depending on the local firewall/NAT rules, you might need to force
          Miredo to use a fixed UDP port and or IPv4 address.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.miredo = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Teredo IPv6 Tunneling Daemon";
      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        ExecStart = "${cfg.package}/bin/miredo -c ${miredoConf} -p ${pidFile} -f";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };

  };

}
