{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.quota-tracker;
in
{
  options.services.quota-tracker = {
    enable = lib.mkEnableOption "quota-tracker daemon";

    package = lib.mkPackageOption pkgs "quota-tracker" { };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host to bind the quota-tracker daemon to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8787;
      description = "Port to bind the quota-tracker daemon to.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--log-level"
        "DEBUG"
      ];
      description = "Extra arguments to pass to the quota-tracker daemon.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        QUOTA_TRACKER_LOG_LEVEL = "DEBUG";
      };
      description = "Environment variables for the quota-tracker service.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.quota-tracker = {
      description = "Quota Tracker Daemon";
      wantedBy = [ "default.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "daemon"
            "--host"
            cfg.host
            "--port"
            (toString cfg.port)
          ]
          ++ cfg.extraArgs
        );
        Restart = "on-failure";
      };

      inherit (cfg) environment;
    };
  };
}
