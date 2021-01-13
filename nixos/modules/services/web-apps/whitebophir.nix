{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.whitebophir;
in {
  options = {
    services.whitebophir = {
      enable = mkEnableOption "whitebophir, an online collaborative whiteboard server (persistent state will be maintained under <filename>/var/lib/whitebophir</filename>)";

      package = mkOption {
        default = pkgs.whitebophir;
        defaultText = "pkgs.whitebophir";
        type = types.package;
        description = "Whitebophir package to use.";
      };

      port = mkOption {
        type = types.port;
        default = 5001;
        description = "Port to bind to.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.whitebophir = {
      description = "Whitebophir Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" ];
      environment = {
        PORT            = "${toString cfg.port}";
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
