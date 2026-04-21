{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.hister;

  yamlFormat = pkgs.formats.yaml { };

  dataDir = if cfg.dataDir != null then cfg.dataDir else "/var/lib/hister";

  histerEnv =
    lib.optionalAttrs (cfg.port != null) {
      HISTER_PORT = toString cfg.port;
    }
    // lib.optionalAttrs (cfg.configPath != null) {
      HISTER_CONFIG = toString cfg.configPath;
    }
    // lib.optionalAttrs (cfg.settings != { }) {
      HISTER_CONFIG = "${yamlFormat.generate "hister-config.yml" cfg.settings}";
    }
    // {
      HISTER_DATA_DIR = dataDir;
    };

  privilegedPort = cfg.port != null && cfg.port < 1024;
in
{
  meta.maintainers = with lib.maintainers; [ FlameFlag ];

  options.services.hister = {
    enable = lib.mkEnableOption "Hister, a web history service with content-based search";

    package = lib.mkPackageOption pkgs "hister" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "hister";
      description = "User account under which Hister runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "hister";
      description = "Group under which Hister runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/lib/hister";
      description = ''
        Directory where Hister stores its data. When `null` (the default), the
        service is isolated under `/var/lib/hister` via systemd's
        `StateDirectory=`. When set to an explicit path, that path is granted
        via `ReadWritePaths=` instead and its creation and permissions are the
        administrator's responsibility.
      '';
    };

    port = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      example = 4433;
      description = ''
        Port on which Hister listens. When set, this overrides the port in
        `server.address` from the configuration file via the `HISTER_PORT`
        environment variable.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open {option}`services.hister.port` in the firewall. Has no
        effect if `port` is `null`.
      '';
    };

    configPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/etc/hister/config.yml";
      description = ''
        Path to an existing Hister configuration file. Mutually exclusive with
        {option}`services.hister.settings`.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/hister.env";
      description = ''
        Path to an environment file (read at service start) used to inject
        secrets such as `HISTER__APP__ACCESS_TOKEN` without placing them in the
        world-readable Nix store.
      '';
    };

    settings = lib.mkOption {
      type = yamlFormat.type;
      default = { };
      description = ''
        Hister configuration rendered to YAML and passed via `HISTER_CONFIG`.
        Accepts any structure the server accepts: see the `app`, `server`,
        `indexer`, `crawler`, `hotkeys`, `extractors`, and
        `sensitive_content_patterns` blocks documented upstream.
      '';
      example = lib.literalExpression ''
        {
          app = {
            search_url = "https://google.com/search?q={query}";
            log_level = "info";
          };
          server = {
            address = "127.0.0.1:4433";
            database = "db.sqlite3";
          };
          hotkeys.web = {
            "/" = "focus_search_input";
            "enter" = "open_result";
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.configPath != null && cfg.settings != { });
        message = "Only one of services.hister.configPath and services.hister.settings can be set";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    users.users = lib.mkIf (cfg.user == "hister") {
      hister = {
        description = "Hister web history service";
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "hister") {
      hister = { };
    };

    systemd.services.hister = {
      description = "Hister web history service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = histerEnv;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} listen";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = lib.mkIf (cfg.dataDir == null) "hister";
        ReadWritePaths = lib.mkIf (cfg.dataDir != null) [ cfg.dataDir ];
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        AmbientCapabilities = lib.mkIf privilegedPort [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = if privilegedPort then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        LockPersonality = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        MemoryDenyWriteExecute = true;
        UMask = "0077";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall && cfg.port != null) [ cfg.port ];
  };
}
