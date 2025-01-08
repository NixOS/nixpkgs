{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.icecream.scheduler;
in
{

  ###### interface

  options = {

    services.icecream.scheduler = {
      enable = lib.mkEnableOption "Icecream Scheduler";

      netName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Network name for the icecream scheduler.

          Uses the default ICECREAM if null.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8765;
        description = ''
          Server port to listen for icecream daemon requests.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to automatically open the daemon port in the firewall.
        '';
      };

      openTelnet = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the telnet TCP port on 8766.
        '';
      };

      persistentClientConnection = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to prevent clients from connecting to a better scheduler.
        '';
      };

      package = lib.mkPackageOption pkgs "icecream" { };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional command line parameters";
        example = [ "-v" ];
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkMerge [
      (lib.mkIf cfg.openFirewall [ cfg.port ])
      (lib.mkIf cfg.openTelnet [ 8766 ])
    ];

    systemd.services.icecc-scheduler = {
      description = "Icecream scheduling server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            "${lib.getBin cfg.package}/bin/icecc-scheduler"
            "-p"
            (toString cfg.port)
          ]
          ++ lib.optionals (cfg.netName != null) [
            "-n"
            (toString cfg.netName)
          ]
          ++ lib.optional cfg.persistentClientConnection "-r"
          ++ cfg.extraArgs
        );

        DynamicUser = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ emantor ];
}
