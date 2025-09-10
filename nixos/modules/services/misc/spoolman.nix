{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.spoolman;
in
{

  options.services.spoolman = {

    enable = lib.mkEnableOption "Spoolman, a filament spool inventory management system.";

    environment = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = {
        SPOOLMAN_DB_TYPE = "sqlite";
        SPOOLMAN_LOGGING_LEVEL = "DEBUG";
        SPOOLMAN_AUTOMATIC_BACKUP = "TRUE";
        SPOOLMAN_BASE_PATH = "/spoolman";
        SPOOLMAN_METRICS_ENABLED = "TRUE";
        SPOOLMAN_CORS_ORIGIN = "source1.domain.com:p1, source2.domain.com:p2";
      };
      description = ''
        Environment variables to be passed to the spoolman service.
        Refer to https://github.com/Donkie/Spoolman/blob/master/.env.example for details on supported variables.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the appropriate ports in the firewall for spoolman.
      '';
    };

    listen = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The IP address to bind the spoolman server to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 7912;
      description = ''
        TCP port where spoolman web-gui listens.
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.spoolman = {
      description = "A self-hosted filament spool inventory management system";
      wantedBy = [ "multi-user.target" ];
      environment = {
        SPOOLMAN_DIR_DATA = "/var/lib/spoolman";
      }
      // cfg.environment;
      serviceConfig = lib.mkMerge [
        {
          DynamicUser = true;
          ExecStart = "${pkgs.spoolman}/bin/spoolman --host ${cfg.listen} --port ${toString cfg.port}";
          StateDirectory = "spoolman";
        }
      ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = lib.optional (cfg.listen != "127.0.0.1") cfg.port;
    };

  };
  meta = {
    maintainers = with lib.maintainers; [ MayNiklas ];
  };
}
