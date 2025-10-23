{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wastebin;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    mapAttrs
    isBool
    getExe
    boolToString
    optionalAttrs
    ;
in
{

  options.services.wastebin = {

    enable = mkEnableOption "Wastebin, a pastebin service";

    package = mkPackageOption pkgs "wastebin" { };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/wastebin";
      description = "State directory of the daemon.";
    };

    secretFile = mkOption {
      type = types.nullOr types.path;
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

    settings = mkOption {

      description = ''
        Additional configuration for wastebin, see
        <https://github.com/matze/wastebin#usage> for supported values.
        For secrets use secretFile option instead.
      '';

      type = types.submodule {

        freeformType =
          with types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);

        options = {

          WASTEBIN_ADDRESS_PORT = mkOption {
            type = types.str;
            default = "0.0.0.0:8088";
            description = "Address and port to bind to";
          };

          WASTEBIN_BASE_URL = mkOption {
            default = "http://localhost";
            example = "https://myhost.tld";
            type = types.str;
            description = ''
              Base URL for the QR code display. If not set, the user agent's Host
              header field is used as an approximation.
            '';
          };

          WASTEBIN_CACHE_SIZE = mkOption {
            default = 128;
            type = types.int;
            description = "Number of rendered syntax highlight items to cache. Can be disabled by setting to 0.";
          };

          WASTEBIN_DATABASE_PATH = mkOption {
            default = "/var/lib/wastebin/sqlite3.db"; # TODO make this default to stateDir/sqlite3.db
            type = types.str;
            description = "Path to the sqlite3 database file. If not set, an in-memory database is used.";
          };

          WASTEBIN_HTTP_TIMEOUT = mkOption {
            default = 5;
            type = types.int;
            description = "Maximum number of seconds a request can be processed until wastebin responds with 408";
          };

          WASTEBIN_MAX_BODY_SIZE = mkOption {
            default = 1048576;
            type = types.int;
            description = "Number of bytes to accept for POST requests";
          };

          WASTEBIN_TITLE = mkOption {
            default = "wastebin";
            type = types.str;
            description = "Overrides the HTML page title";
          };

          RUST_LOG = mkOption {
            default = "info";
            type = types.str;
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

  config = mkIf cfg.enable {
    systemd.services.wastebin = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = mapAttrs (_: v: if isBool v then boolToString v else toString v) cfg.settings;
      serviceConfig = {
        DevicePolicy = "closed";
        DynamicUser = true;
        ExecStart = "${getExe cfg.package}";
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
      // optionalAttrs (cfg.secretFile != null) {
        EnvironmentFile = cfg.secretFile;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ pinpox ];
}
