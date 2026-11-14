{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.cocoon;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    optional
    ;
in
{
  options.services.cocoon = {
    enable = mkEnableOption "cocoon";

    package = mkPackageOption pkgs "cocoon" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (types.nullOr (types.either types.str types.path));

        options = {
          COCOON_ADDR = mkOption {
            type = types.str;
            default = ":8080";
            example = ":3000";
            description = "Address to bind the Cocoon instance to";
          };

          COCOON_DID = mkOption {
            type = types.nullOr types.str;
            example = "did:web:cocoon.example.com";
            description = "DID web address for the Cocoon instance";
          };

          COCOON_HOSTNAME = mkOption {
            type = types.nullOr types.str;
            example = "cocoon.example.com";
            description = "Hostname for the Cocoon instance";
          };

          COCOON_ROTATION_KEY_PATH = mkOption {
            type = types.either types.path types.str;
            default = "/var/lib/cocoon/rotation.key";
            description = ''
              Path to the rotation key file.

              Generate it with:
              ```
              cocoon create-rotation-key --out /var/lib/cocoon/rotation.key
              ```
            '';
          };

          COCOON_JWK_PATH = mkOption {
            type = types.either types.path types.str;
            default = "/var/lib/cocoon/jwk.key";
            description = ''
              Path to the JWK key file

              Generate it with:
              ```
              cocoon create-private-jwk --out /var/lib/cocoon/jwk.key
              ```
            '';
          };

          COCOON_CONTACT_EMAIL = mkOption {
            type = types.str;
            example = "me@example.com";
            description = "Contact email for the Cocoon instance";
          };

          COCOON_RELAYS = mkOption {
            type = types.str;
            default = "https://bsky.network";
            description = "Comma-separated list of Nostr relays to connect to";
          };

          COCOON_SESSION_COOKIE_KEY = mkOption {
            type = types.str;
            default = "session";
            description = "Name of the session cookie";
          };

          COCOON_DB_TYPE = mkOption {
            type = types.str;
            default = "sqlite";
            description = "Type of database to use (sqlite or postgres)";
          };

          COCOON_DB_NAME = mkOption {
            type = types.str;
            default = "/var/lib/cocoon/cocoon.db";
            description = "Name of the SQLite database file (if using sqlite)";
          };

          COCOON_DATABASE_URL = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "postgres://cocoon:password@localhost:5432/cocoon?sslmode=disable";
            description = "Database connection URL";
          };
        };
      };

      description = ''
        Environment variables to set for the service. Secrets should be
        specified using {option}`environmentFile`.

        Refer to <https://github.com/haileyok/cocoon/blob/main/.env.example>
        and <https://github.com/haileyok/cocoon/blob/main/README.md> for
        available environment variables.
      '';
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        File to load environment variables from. Loaded variables override
        values set in {option}`environment`.

        Use it to set values of `COCOON_ADMIN_PASSWORD` and `COCOON_SESSION_SECRE`.

        Generate `COCOON_ADMIN_PASSWORD` with
        ```
        openssl rand -hex 16
        ```

        Generate `COCOON_SESSION_SECRET` with
        ```
        openssl rand -hex 32
        ```
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.cocoon = {
      description = "cocoon";

      after = [
        "network-online.target"
      ]
      ++ optional (cfg.settings.COCOON_DB_TYPE == "postgres") "postgresql.service";
      wants = [
        "network-online.target"
      ]
      ++ optional (cfg.settings.COCOON_DB_TYPE == "postgres") "postgresql.service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${getExe cfg.package} run";
        Environment = lib.mapAttrsToList (k: v: "${k}=${if builtins.isInt v then toString v else v}") (
          lib.filterAttrs (_: v: v != null) cfg.settings
        );

        EnvironmentFile = cfg.environmentFiles;
        StateDirectory = "cocoon";
        StateDirectoryMode = "0755";
        Restart = "always";

        # Hardening
        RemoveIPC = true;
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        PrivateMounts = true;
        SystemCallArchitectures = [ "native" ];
        MemoryDenyWriteExecute = true;
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        ProtectHostname = true;
        LockPersonality = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictRealtime = true;
        DeviceAllow = [ "" ];
        ProtectSystem = "strict";
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectHome = true;
        PrivateUsers = true;
        PrivateTmp = true;
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ isabelroses ];
}
