{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.icecream.scheduler;
in {

  ###### interface

  options = {

    services.icecream.scheduler = {
      enable = mkEnableOption (lib.mdDoc "Icecream Scheduler");

      netName = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Network name for the icecream scheduler.

          Uses the default ICECREAM if null.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8765;
        description = lib.mdDoc ''
          Server port to listen for icecream daemon requests.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          Whether to automatically open the daemon port in the firewall.
        '';
      };

      openTelnet = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to open the telnet TCP port on 8766.
        '';
      };

      persistentClientConnection = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to prevent clients from connecting to a better scheduler.
        '';
      };

      package = mkOption {
        default = pkgs.icecream;
        defaultText = literalExpression "pkgs.icecream";
        type = types.package;
        description = lib.mdDoc "Icecream package to use.";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc "Additional command line parameters";
        example = [ "-v" ];
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkMerge [
      (mkIf cfg.openFirewall [ cfg.port ])
      (mkIf cfg.openTelnet [ 8766 ])
    ];

    systemd.services.icecc-scheduler = {
      description = "Icecream scheduling server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = escapeShellArgs ([
          "${getBin cfg.package}/bin/icecc-scheduler"
          "-p" (toString cfg.port)
        ]
        ++ optionals (cfg.netName != null) [ "-n" (toString cfg.netName) ]
        ++ optional cfg.persistentClientConnection "-r"
        ++ cfg.extraArgs);

        DynamicUser = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ emantor ];
}
