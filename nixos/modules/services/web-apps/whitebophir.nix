{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.whitebophir;
in {
  options = {
    services.whitebophir = {
      enable = mkEnableOption (lib.mdDoc "whitebophir, an online collaborative whiteboard server (persistent state will be maintained under {file}`/var/lib/whitebophir`)");

      package = mkOption {
        default = pkgs.whitebophir;
        defaultText = literalExpression "pkgs.whitebophir";
        type = types.package;
        description = lib.mdDoc "Whitebophir package to use.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = lib.mdDoc "Address to listen on (use 0.0.0.0 to allow access from any address).";
      };

      port = mkOption {
        type = types.port;
        default = 5001;
        description = lib.mdDoc "Port to bind to.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.whitebophir = {
      description = "Whitebophir Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" ];
      environment = {
        PORT            = toString cfg.port;
        HOST            = toString cfg.listenAddress;
        WBO_HISTORY_DIR = "/var/lib/whitebophir";
      };

      serviceConfig = {
        DynamicUser    = true;
        ExecStart      = "${cfg.package}/bin/whitebophir";
        Restart        = "always";
        StateDirectory = "whitebophir";
      };
    };
  };
}
