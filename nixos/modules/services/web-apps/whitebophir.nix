{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.whitebophir;
in
{
  options = {
    services.whitebophir = {
      enable = lib.mkEnableOption "whitebophir, an online collaborative whiteboard server (persistent state will be maintained under {file}`/var/lib/whitebophir`)";

      package = lib.mkPackageOption pkgs "whitebophir" { };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "Address to listen on (use 0.0.0.0 to allow access from any address).";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5001;
        description = "Port to bind to.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.whitebophir = {
      description = "Whitebophir Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        PORT = toString cfg.port;
        HOST = toString cfg.listenAddress;
        WBO_HISTORY_DIR = "/var/lib/whitebophir";
      };

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/whitebophir";
        Restart = "always";
        StateDirectory = "whitebophir";
      };
    };
  };
}
