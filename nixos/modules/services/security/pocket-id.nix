{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    concatMap
    concatStringsSep
    getExe
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    ;
  inherit (lib.types)
    attrsOf
    bool
    path
    str
    submodule
    ;

  cfg = config.services.pocket-id;

  format = pkgs.formats.keyValue { };
  settingsFile = format.generate "pocket-id-env-vars" cfg.settings;

  exportCredentials = n: _: ''export ${n}="$(${pkgs.systemd}/bin/systemd-creds cat ${n}_FILE)"'';
  exportAllCredentials = vars: lib.concatStringsSep "\n" (lib.mapAttrsToList exportCredentials vars);
  getLoadCredentialList = lib.mapAttrsToList (n: v: "${n}_FILE:${v}") cfg.credentials;
in
{
  meta.maintainers = with maintainers; [
    gepbird
    ymstnt
  ];

  options.services.pocket-id = {
    enable = mkEnableOption "Pocket ID server";

    package = mkPackageOption pkgs "pocket-id" { };

    environmentFile = mkOption {
      type = path;
      description = ''
        Path to an environment file to be loaded.
        This can be used to securely store tokens and secrets outside of the world-readable Nix store.

        See [PocketID environment variables](https://pocket-id.org/docs/configuration/environment-variables).

        Example contents of the file:
        MAXMIND_LICENSE_KEY=your-license-key

        Alternatively you can use `services.pocket-id.credentials` to define each variable in separate files.
      '';
      default = "/dev/null";
      example = "/var/lib/secrets/pocket-id";
    };

    credentials = mkOption {
      type = attrsOf path;
      default = { };
      example = {
        ENCRYPTION_KEY = "/run/secrets/pocket-id/encryption-key";
      };
      description = ''
        Environment variables which are loaded from the contents of the specified file paths.
        This can be used to securely store tokens and secrets outside of the world-readable Nix store.

        See [PocketID environment variables](https://pocket-id.org/docs/configuration/environment-variables).

        Alternatively you can use `services.pocket-id.environmentFile` to define all the variables in a single file.
      '';
    };

    settings = mkOption {
      type = submodule {
        freeformType = format.type;

        options = {
          APP_URL = mkOption {
            type = str;
            description = ''
              The URL where you will access the app.
            '';
            default = "http://localhost";
          };

          TRUST_PROXY = mkOption {
            type = bool;
            description = ''
              Whether the app is behind a reverse proxy.
            '';
            default = false;
          };

          ANALYTICS_DISABLED = mkOption {
            type = bool;
            description = ''
              Whether to disable analytics.

              See the [analytics documentation](https://pocket-id.org/docs/configuration/analytics/).
            '';
            default = false;
          };
        };
      };

      default = { };

      description = ''
        Environment variables to be passed.

        See [PocketID environment variables](https://pocket-id.org/docs/configuration/environment-variables).
      '';
    };

    dataDir = mkOption {
      type = path;
      default = "/var/lib/pocket-id";
      description = ''
        The directory where Pocket ID will store its data, such as the database when using SQLite.
      '';
    };

    user = mkOption {
      type = str;
      default = "pocket-id";
      description = "User account under which Pocket ID runs.";
    };

    group = mkOption {
      type = str;
      default = "pocket-id";
      description = "Group account under which Pocket ID runs.";
    };
  };

  config = mkIf cfg.enable {
    assertions = (
      map
        (
          # Converted to assert 2026-01-08
          setting: {
            assertion = !(cfg.settings ? "${setting}");
            message = ''
              `services.pocket-id.settings.${setting}` is deprecated.
              See [v1 migration guide](https://pocket-id.org/docs/setup/major-releases/migrate-v1).
            '';
          })
        [
          "PUBLIC_APP_URL"
          "PUBLIC_UI_CONFIG_DISABLED"
          "CADDY_DISABLED"
          "CADDY_PORT"
          "BACKEND_PORT"
          "POSTGRES_CONNECTION_STRING"
          "SQLITE_DB_PATH"
          "INTERNAL_BACKEND_URL"
        ]
    );

    warnings =
      (concatMap
        (
          setting:
          optional (cfg.settings ? "${setting}") ''
            `services.pocket-id.settings.${setting}` will be stored as plaintext in the Nix store. Use `services.pocket-id.credentials.${setting}` or `services.pocket-id.environmentFile` instead.
          ''
        )
        [
          "ENCRYPTION_KEY"
          "MAXMIND_LICENSE_KEY"
          "SMTP_PASSWORD"
          "LDAP_BIND_PASSWORD"
        ]
      )
      ++ (concatMap
        (
          # Added 2026-01-08
          setting:
          optional (cfg.settings ? "${setting}") ''
            `services.pocket-id.settings.${setting}` is deprecated.
            See [v2 migration guide](https://pocket-id.org/docs/setup/major-releases/migrate-v2).
          ''
        )
        [
          "DB_PROVIDER"
          "KEYS_PATH"
          "KEYS_STORAGE"
          "LDAP_ATTRIBUTE_ADMIN_GROUP"
        ]
      );

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group}"
    ];

    systemd.services = {
      pocket-id = {
        description = "Pocket ID";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [
          cfg.package
          cfg.environmentFile
          settingsFile
        ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          ExecStart = pkgs.writeShellScript "pocket-id-start" ''
            ${exportAllCredentials cfg.credentials}
            ${getExe cfg.package}
          '';
          Restart = "always";
          EnvironmentFile = [
            cfg.environmentFile
            settingsFile
          ];
          LoadCredential = getLoadCredentialList;

          # Hardening
          AmbientCapabilities = "";
          CapabilityBoundingSet = "";
          DeviceAllow = "";
          DevicePolicy = "closed";
          #IPAddressDeny = "any"; # provides the service through network
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateNetwork = false; # provides the service through network
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ReadWritePaths = [ cfg.dataDir ];
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = concatStringsSep " " [
            "~"
            "@clock"
            "@cpu-emulation"
            "@debug"
            "@module"
            "@mount"
            "@obsolete"
            "@privileged"
            "@raw-io"
            "@reboot"
            "@resources"
            "@swap"
          ];
          UMask = "0077";
        };
      };
    };

    users.users = optionalAttrs (cfg.user == "pocket-id") {
      pocket-id = {
        isSystemUser = true;
        group = cfg.group;
        description = "Pocket ID backend user";
        home = cfg.dataDir;
      };
    };

    users.groups = optionalAttrs (cfg.group == "pocket-id") {
      pocket-id = { };
    };
  };
}
