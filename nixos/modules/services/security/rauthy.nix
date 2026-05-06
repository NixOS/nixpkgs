{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.rauthy;
  format = pkgs.formats.toml { };
  settings = format.generate "rauthy-config.toml" cfg.settings;
in
{
  options.services.rauthy = {
    enable = lib.mkEnableOption "Rauthy";
    package = lib.mkPackageOption pkgs "rauthy" { };
    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for Rauthy. See the
        [Rauthy documentation](https://sebadob.github.io/rauthy/config/config.html)
        for possible options.

        You can generate a base config using Rauthy's config wizard:
        ```bash
        nix-shell -p rauthy --run "rauthy generate-config --output-file config.toml"
        ```

        To convert the config file to Nix, use
        `builtins.fromTOML (builtins.readFile ./config.toml)`
        or run the following command:
        ```bash
        nix-shell -p toml2nix --run "cat config.toml | toml2nix"
        ```

        ::: {.caution}
        The settings will be stored in the world-readable Nix store.
        Use {option}`services.rauthy.environmentFile` instead for setting secrets.
        :::
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.oneOf [
        lib.types.str
        lib.types.path
      ];
      default = "";
      description = ''
        Environment file to pass to Rauthy. Use this option to set secrets.
        See the
        [Rauthy documentation](https://sebadob.github.io/rauthy/config/config.html)
        for possible environment variables.
      '';
    };
    enableUnixSocket = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable a UNIX domain socket at `/run/rauthy/rauthy.sock`
        instead of listening on an IP address and port.

        Make sure to set {option}`services.rauthy.settings.server.scheme`
        to `unix_http` or `unix_https`.
      '';
    };
    configurePostgres = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to use PostgreSQL instead of Hiqlite.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.enableUnixSocket
          && cfg.settings ? server.scheme
          && (cfg.settings.server.scheme == "unix_http" || cfg.settings.server.scheme == "unix_https");
        message =
          "`services.rauthy.settings.server.scheme` must be set to 'unix_http' "
          + "or 'unix_https' when `services.rauthy.enableUnixSocket` is enabled.";
      }
    ];

    services.postgresql = lib.mkIf cfg.configurePostgres {
      enable = true;
      ensureDatabases = [ "rauthy" ];
      ensureUsers = [
        {
          name = "rauthy";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.rauthy = {
      description = "Rauthy";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ] ++ lib.optional cfg.configurePostgres "postgresql.target";
      requires = lib.mkIf cfg.configurePostgres [ "postgresql.target" ];
      wants = [ "network-online.target" ];
      environment = lib.mkMerge [
        (lib.mkIf cfg.enableUnixSocket { LISTEN_ADDRESS = "%t/rauthy/rauthy.sock"; })
        (lib.mkIf cfg.configurePostgres {
          HIQLITE = "false";
          PG_DB_NAME = "rauthy";
          PG_HOST = "%t/postgresql";
          PG_PORT = "5432";
          PG_USER = "rauthy";
          PG_TLS = "disable";
          PG_PASSWORD = "";
        })
      ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve --config-file ${settings}";
        DynamicUser = true;
        StateDirectory = "rauthy";
        WorkingDirectory = "%S/rauthy";
        RuntimeDirectory = lib.mkIf cfg.enableUnixSocket "rauthy";
        RuntimeDirectoryMode = lib.mkIf cfg.enableUnixSocket "750";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != "") [ cfg.environmentFile ];
        # Hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        PrivateTmp = "disconnected";
        ProcSubset = "pid";
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = [
          "~cgroup"
          "~ipc"
          "~mnt"
          "~net"
          "~pid"
          "~user"
          "~uts"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@swap"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    ungeskriptet
  ];
}
