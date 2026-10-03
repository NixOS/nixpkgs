{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pgdog;
  settingsFormat = pkgs.formats.toml { };

  settingsPath =
    if cfg.settingsFile == "" || cfg.settingsFile == null then
      settingsFormat.generate "pgdog.toml" cfg.settings
    else
      cfg.settingsFile;

  usersPath =
    if cfg.usersFile == "" || cfg.usersFile == null then
      settingsFormat.generate "users.toml" cfg.users
    else
      cfg.usersFile;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    maintainers
    ;
in

{
  ###### interface
  options.services.pgdog = {
    enable = mkEnableOption "PgDog instance";

    package = mkPackageOption pkgs "pgdog" { };

    openFirewall = mkEnableOption "Whether to open the TCP port in the firewall for `PgDog`. (This only works if `settingsFile` is NOT set)";

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/pgdog";
      description = ''
        Path to a file containing extra pgdog environment variables in the systemd `EnvironmentFile`
        format.

        This can be used to set the admin password using PGDOG_ADMIN_PASSWORD and a few other things.
      '';
    };

    settings = mkOption {
      description = "General settings for PgDog inside of `pgdog.toml`, see https://docs.pgdog.dev/configuration/pgdog.toml/general/ for supported values.";
      default = { };
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          # general section
          general = mkOption {
            type = types.submodule {
              freeformType = settingsFormat.type;

              options = {
                port = mkOption {
                  type = types.port;
                  default = 6432;
                  description = "The TCP port PgDog will bind to listen for connections.";
                };
              };
            };
            description = "General settings are relevant to the operations of the pooler itself, or apply to all database pools.";
            default = { };
          };
        };
      };
      example = {
        general = {
          host = "0.0.0.0";
          port = 6432;
          pooler_mode = "transaction";
          passthrough_auth = "enabled";
        };

        databases = [
          {
            name = "prod";
            host = "127.0.0.1";
            port = 5432;
            role = "primary";
          }
        ];
      };
    };

    settingsFile = mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Overrides the `pgdog.toml` configuration file, see https://docs.pgdog.dev/configuration/pgdog.toml/general/ for supported values.";
      example = "/etc/pgdog/pgdog.toml";
    };

    users = mkOption {
      type = settingsFormat.type;
      default = { };
      description = "User configuration for PgDog inside of `users.toml`, see https://docs.pgdog.dev/configuration/users.toml/users/ for supported values.";
      example = {
        users = [
          {
            name = "pgdog";
            password = "pgdog";
            database = "pgdog";
          }
        ];
      };
    };

    usersFile = mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Overrides the `users.toml` configuration file, see https://docs.pgdog.dev/configuration/users.toml/users/ for supported values.";
      example = "/etc/pgdog/users.toml";
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    warnings =
      [ ]
      ++ (lib.optional (
        cfg.settingsFile != null && cfg.settingsFile != "" && cfg.settings != { }
      ) "services.pgdog.settings will be ignored since services.pgdog.settingsFile has been set.")
      ++ (lib.optional (
        cfg.usersFile != null && cfg.usersFile != "" && cfg.users != { }
      ) "services.pgdog.users will be ignored since services.pgdog.usersFile has been set.");

    assertions = [
      {
        assertion = !(cfg.openFirewall && cfg.settingsFile != null);
        message = "services.pgdog.openFirewall cannot be used when services.pgdog.settingsFile is set. Please open it manually.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf (cfg.openFirewall && cfg.settingsFile == null) {
      allowedTCPPorts = [ cfg.settings.general.port ];
    };

    systemd.services.pgdog = {
      wantedBy = [ "multi-user.target" ];
      description = "A PgDog instance";
      restartTriggers = [
        settingsPath
        usersPath
      ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config=${settingsPath} --users=${usersPath}";
        KillSignal = "SIGINT"; # https://docs.pgdog.dev/administration/#shutting-down-pgdog
        DynamicUser = lib.mkDefault true;

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        # Have this relative path be set correctly,
        # https://docs.pgdog.dev/configuration/pgdog.toml/general/#two_phase_commit_wal_dir
        StateDirectory = "pgdog";
        WorkingDirectory = "/var/lib/pgdog";
        UMask = "0077";

        # Incase a path outside of the nix store is defined.
        ReadOnlyPaths = [
          settingsPath
          usersPath
        ];

        ### Service hardening

        CapabilityBoundingSet = [
          ""
        ];

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = "strict";

        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];

        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        SystemCallErrorNumber = "EPERM";
        SystemCallArchitectures = "native";
        ProtectProc = "invisible";
        ProcSubset = "pid";
        NoNewPrivileges = true;
      };
    };
  };

  meta.maintainers = with maintainers; [ MrSnowy ];
}
