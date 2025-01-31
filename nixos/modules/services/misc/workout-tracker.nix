{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  cfg = config.services.workout-tracker;
  stateDir = "workout-tracker";
in

{
  options = {
    services.workout-tracker = {
      enable = lib.mkEnableOption "workout tracking web application for personal use (or family, friends), geared towards running and other GPX-based activities";

      package = lib.mkPackageOption pkgs "workout-tracker" { };

      address = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Web interface address.";
      };

      port = lib.mkOption {
        type = types.port;
        default = 8080;
        description = "Web interface port.";
      };

      environmentFile = lib.mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/workout-tracker.env";
        description = ''
          An environment file as defined in {manpage}`systemd.exec(5)`.

          Secrets like `WT_JWT_ENCRYPTION_KEY` may be passed to the service without adding them
          to the world-readable Nix store.
        '';
      };

      settings = lib.mkOption {
        type = types.attrsOf types.str;

        default = { };
        description = ''
          Extra config options.
        '';
        example = {
          WT_LOGGING = "true";
          WT_DEBUG = "false";
          WT_DATABASE_DRIVER = "sqlite";
          WT_DSN = "./database.db";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.workout-tracker = {
      description = "A workout tracking web application for personal use (or family, friends), geared towards running and other GPX-based activities";
      wantedBy = [ "multi-user.target" ];
      environment = {
        WT_BIND = "${cfg.address}:${toString cfg.port}";
        WT_DATABASE_DRIVER = "sqlite";
        WT_DSN = "./database.db";
      } // cfg.settings;
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        DynamicUser = true;
        StateDirectory = stateDir;
        WorkingDirectory = "%S/${stateDir}";
        Restart = "always";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ bhankas ];
}
