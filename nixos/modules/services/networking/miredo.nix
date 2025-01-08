{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.miredo;
  pidFile = "/run/miredo.pid";
  miredoConf = pkgs.writeText "miredo.conf" ''
    InterfaceName ${cfg.interfaceName}
    ServerAddress ${cfg.serverAddress}
    ${lib.optionalString (cfg.bindAddress != null) "BindAddress ${cfg.bindAddress}"}
    ${lib.optionalString (cfg.bindPort != null) "BindPort ${cfg.bindPort}"}
  '';
in
{

  ###### interface

  options = {

    services.miredo = {

      enable = lib.mkEnableOption "the Miredo IPv6 tunneling service";

      package = lib.mkPackageOption pkgs "miredo" { };

      serverAddress = lib.mkOption {
        default = "teredo.remlab.net";
        type = lib.types.str;
        description = ''
          The hostname or primary IPv4 address of the Teredo server.
          This setting is required if Miredo runs as a Teredo client.
          "teredo.remlab.net" is an experimental service for testing only.
          Please use another server for production and/or large scale deployments.
        '';
      };

      interfaceName = lib.mkOption {
        default = "teredo";
        type = lib.types.str;
        description = ''
          Name of the network tunneling interface.
        '';
      };

      bindAddress = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          Depending on the local firewall/NAT rules, you might need to force
          Miredo to use a fixed UDP port and or IPv4 address.
        '';
      };

      bindPort = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          Depending on the local firewall/NAT rules, you might need to force
          Miredo to use a fixed UDP port and or IPv4 address.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

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
