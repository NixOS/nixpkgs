{ config, lib, pkgs, ... }:

let
  cfg = config.services.matrix-synapse.sliding-sync;
in
{
  options.services.matrix-synapse.sliding-sync = {
    enable = lib.mkEnableOption (lib.mdDoc "sliding sync");

    package = lib.mkPackageOptionMD pkgs "matrix-sliding-sync" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf str;
        options = {
          SYNCV3_SERVER = lib.mkOption {
            type = lib.types.str;
            description = lib.mdDoc ''
              The destination homeserver to talk to not including `/_matrix/` e.g `https://matrix.example.org`.
            '';
          };

          SYNCV3_DB = lib.mkOption {
            type = lib.types.str;
            default = "postgresql:///matrix-sliding-sync?host=/run/postgresql";
            description = lib.mdDoc ''
              The postgres connection string.
              Refer to <https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING>.
            '';
          };

          SYNCV3_BINDADDR = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:8009";
            example = "[::]:8008";
            description = lib.mdDoc "The interface and port to listen on.";
          };

          SYNCV3_LOG_LEVEL = lib.mkOption {
            type = lib.types.enum [ "trace" "debug" "info" "warn" "error" "fatal" ];
            default = "info";
            description = lib.mdDoc "The level of verbosity for messages logged.";
          };
        };
      };
      default = { };
      description = lib.mdDoc ''
        Freeform environment variables passed to the sliding sync proxy.
        Refer to <https://github.com/matrix-org/sliding-sync#setup> for all supported values.
      '';
    };

    createDatabase = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to enable and configure `services.postgres` to ensure that the database user `matrix-sliding-sync`
        and the database `matrix-sliding-sync` exist.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc ''
        Environment file as defined in {manpage}`systemd.exec(5)`.

        This must contain the {env}`SYNCV3_SECRET` variable which should
        be generated with {command}`openssl rand -hex 32`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = lib.optionalAttrs cfg.createDatabase {
      enable = true;
      ensureDatabases = [ "matrix-sliding-sync" ];
      ensureUsers = [ rec {
        name = "matrix-sliding-sync";
        ensurePermissions."DATABASE \"${name}\"" = "ALL PRIVILEGES";
      } ];
    };

    systemd.services.matrix-sliding-sync = {
      after = lib.optional cfg.createDatabase "postgresql.service";
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;
      serviceConfig = {
        DynamicUser = true;
        EnvironmentFile = cfg.environmentFile;
        ExecStart = lib.getExe cfg.package;
        StateDirectory = "matrix-sliding-sync";
        WorkingDirectory = "%S/matrix-sliding-sync";
      };
    };
  };
}
