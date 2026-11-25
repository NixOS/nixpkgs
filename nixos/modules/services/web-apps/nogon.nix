{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nogon;

  useLegacyDefault = lib.versionOlder config.system.stateVersion "27.05";
  defaultName = if useLegacyDefault then "hister" else "nogon";

  yamlFormat = pkgs.formats.yaml { };

  dataDir = if cfg.dataDir != null then cfg.dataDir else "/var/lib/${defaultName}";
  generatedConfig = yamlFormat.generate "nogon-config.yml" cfg.settings;
  hasConfig = cfg.configPath != null || cfg.settings != { };
  runtimeConfigSource = if cfg.settings != { } then generatedConfig else cfg.configPath;
  runtimeConfig = "/run/nogon/config.yml";

  nogonEnv =
    lib.optionalAttrs (cfg.port != null) {
      NOGON_PORT = toString cfg.port;
    }
    // lib.optionalAttrs hasConfig {
      NOGON_CONFIG = runtimeConfig;
    }
    // {
      NOGON_DATA_DIR = dataDir;
    };

  privilegedPort = cfg.port != null && cfg.port < 1024;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "hister" ] [ "services" "nogon" ])
  ];

  meta.maintainers = with lib.maintainers; [ _4evy ];

  options.services.nogon = {
    enable = lib.mkEnableOption "Nogon, a web history service with content-based search";

    package = lib.mkPackageOption pkgs "nogon" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultName;
      defaultText = lib.literalMD ''`"hister"` if `config.system.stateVersion` < "27.05", otherwise `"nogon"`'';
      description = "User account under which Nogon runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = defaultName;
      defaultText = lib.literalMD ''`"hister"` if `config.system.stateVersion` < "27.05", otherwise `"nogon"`'';
      description = "Group under which Nogon runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/lib/nogon";
      description = ''
        Directory where Nogon stores its data. When `null` (the default), the
        service is isolated under `/var/lib/nogon` (or `/var/lib/hister` if `stateVersion` < "27.05")
        via systemd's `StateDirectory=`. When set to an explicit path, that path is created
        with `systemd-tmpfiles` and granted via `ReadWritePaths=` instead.
      '';
    };

    port = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      example = 4433;
      description = ''
        Port on which Nogon listens. When set, this overrides the port in
        `server.address` from the configuration file via the `NOGON_PORT`
        environment variable.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open {option}`services.nogon.port` in the firewall. Has no
        effect if `port` is `null`.
      '';
    };

    configPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/etc/nogon/config.yml";
      description = ''
        Path to an existing Nogon configuration file mounted read-only into
        the service runtime directory and passed via `NOGON_CONFIG`. Mutually
        exclusive with {option}`services.nogon.settings`.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/nogon.env";
      description = ''
        Path to an environment file (read at service start) used to inject
        secrets such as `NOGON__APP__ACCESS_TOKEN` without placing them in the
        world-readable Nix store.
      '';
    };

    settings = lib.mkOption {
      type = yamlFormat.type;
      default = { };
      description = ''
        Nogon configuration rendered to YAML and passed via `NOGON_CONFIG`.
        Accepts any structure the server accepts: see the `app`, `server`,
        `indexer`, `crawler`, `hotkeys`, `extractors`, `semantic_search`, and
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
        message = "Only one of services.nogon.configPath and services.nogon.settings can be set";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    users.users = lib.mkIf (cfg.user == defaultName) {
      ${cfg.user} = {
        description = "Nogon web history service";
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == defaultName) {
      ${cfg.group} = { };
    };

    systemd.tmpfiles.settings."10-nogon"."${dataDir}".d = lib.mkIf (cfg.dataDir != null) {
      user = cfg.user;
      group = cfg.group;
      mode = "0750";
    };

    systemd.services.nogon = {
      description = "Nogon web history service";
      aliases = [ "hister.service" ];
      after = [
        "network.target"
        "systemd-tmpfiles-setup.service"
        "systemd-tmpfiles-resetup.service"
      ];
      wantedBy = [ "multi-user.target" ];

      environment = nogonEnv;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} listen";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = lib.mkIf hasConfig "nogon";
        RuntimeDirectoryMode = lib.mkIf hasConfig "0750";
        BindReadOnlyPaths = lib.mkIf hasConfig [ "${runtimeConfigSource}:${runtimeConfig}" ];
        StateDirectory = lib.mkIf (cfg.dataDir == null) defaultName;
        StateDirectoryMode = lib.mkIf (cfg.dataDir == null) "0750";
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
