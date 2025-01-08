{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wastebin;
in
{

  options.services.wastebin = {

    enable = lib.mkEnableOption "Wastebin, a pastebin service";

    package = lib.mkPackageOption pkgs "wastebin" { };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/wastebin";
      description = "State directory of the daemon.";
    };

    secretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/wastebin.env";
      description = ''
        Path to file containing sensitive environment variables.
        Some variables that can be considered secrets are:

        - WASTEBIN_PASSWORD_SALT:
          salt used to hash user passwords used for encrypting pastes.

        - WASTEBIN_SIGNING_KEY:
          sets the key to sign cookies. If not set, a random key will be
          generated which means cookies will become invalid after restarts and
          paste creators will not be able to delete their pastes anymore.
      '';
    };

    settings = lib.mkOption {

      description = ''
        Additional configuration for wastebin, see
        <https://github.com/matze/wastebin#usage> for supported values.
        For secrets use secretFile option instead.
      '';

      type = lib.types.submodule {

        freeformType =
          with lib.types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);

        options = {

          WASTEBIN_ADDRESS_PORT = lib.mkOption {
            type = lib.types.str;
            default = "0.0.0.0:8088";
            description = "Address and port to bind to";
          };

          WASTEBIN_BASE_URL = lib.mkOption {
            default = "http://localhost";
            example = "https://myhost.tld";
            type = lib.types.str;
            description = ''
              Base URL for the QR code display. If not set, the user agent's Host
              header field is used as an approximation.
            '';
          };

          WASTEBIN_CACHE_SIZE = lib.mkOption {
            default = 128;
            type = lib.types.int;
            description = "Number of rendered syntax highlight items to cache. Can be disabled by setting to 0.";
          };

          WASTEBIN_DATABASE_PATH = lib.mkOption {
            default = "/var/lib/wastebin/sqlite3.db"; # TODO make this default to stateDir/sqlite3.db
            type = lib.types.str;
            description = "Path to the sqlite3 database file. If not set, an in-memory database is used.";
          };

          WASTEBIN_HTTP_TIMEOUT = lib.mkOption {
            default = 5;
            type = lib.types.int;
            description = "Maximum number of seconds a request can be processed until wastebin responds with 408";
          };

          WASTEBIN_MAX_BODY_SIZE = lib.mkOption {
            default = 1024;
            type = lib.types.int;
            description = "Number of bytes to accept for POST requests";
          };

          WASTEBIN_TITLE = lib.mkOption {
            default = "wastebin";
            type = lib.types.str;
            description = "Overrides the HTML page title";
          };

          RUST_LOG = lib.mkOption {
            default = "info";
            type = lib.types.str;
            description = ''
              Influences logging. Besides the typical trace, debug, info etc.
              keys, you can also set the tower_http key to some log level to get
              additional information request and response logs.
            '';
          };
        };
      };

      default = { };

      example = {
        WASTEBIN_TITLE = "My awesome pastebin";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.wastebin = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = lib.mapAttrs (_: v: if lib.isBool v then lib.boolToString v else toString v) cfg.settings;
      serviceConfig =
        {
          DevicePolicy = "closed";
          DynamicUser = true;
          ExecStart = "${lib.getExe cfg.package}";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = [ "native" ];
          SystemCallFilter = [ "@system-service" ];
          StateDirectory = baseNameOf cfg.stateDir;
          ReadWritePaths = cfg.stateDir;
        }
        // lib.optionalAttrs (cfg.secretFile != null) {
          EnvironmentFile = cfg.secretFile;
        };
    };
  };

  meta.maintainers = with lib.maintainers; [ pinpox ];
}
