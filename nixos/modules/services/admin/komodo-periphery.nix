{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.komodo-periphery;
  settingsFormat = pkgs.formats.toml { };

  genFinalSettings =
    let
      baseSettings = {
        port = cfg.port;
        bind_ip = cfg.bindIp;
        root_directory = cfg.rootDirectory;
        repo_dir = "${cfg.rootDirectory}/repos";
        stack_dir = "${cfg.rootDirectory}/stacks";
        ssl_enabled = cfg.ssl.enable;
      }
      // lib.optionalAttrs cfg.ssl.enable {
        ssl_key_file = cfg.ssl.keyFile;
        ssl_cert_file = cfg.ssl.certFile;
      }
      // {
        logging = {
          level = cfg.logging.level;
          stdio = cfg.logging.stdio;
        }
        // lib.optionalAttrs (cfg.logging.otlpEndpoint != "") {
          otlp_endpoint = cfg.logging.otlpEndpoint;
        };
        allowed_ips = cfg.allowedIps;
        passkeys = cfg.passkeys;
        disable_terminals = cfg.disableTerminals;
        disable_container_exec = cfg.disableContainerExec;
        stats_polling_rate = cfg.statsPollingRate;
        container_stats_polling_rate = cfg.containerStatsPollingRate;
        legacy_compose_cli = cfg.legacyComposeCli;
        include_disk_mounts = cfg.includeDiskMounts;
        exclude_disk_mounts = cfg.excludeDiskMounts;
      }
      // cfg.extraSettings;
    in
    lib.filterAttrsRecursive (_: v: v != null && v != { } && v != [ ]) baseSettings;

  configFile =
    if cfg.configFile == null then
      settingsFormat.generate "komodo-periphery.toml" genFinalSettings
    else
      cfg.configFile;
in
{
  options.services.komodo-periphery = {
    enable = lib.mkEnableOption "Periphery, a multi-server Docker and Git deployment agent by Komodo";

    package = lib.mkPackageOption pkgs "komodo" { };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the periphery configuration file. If null, a configuration file will be generated from the module options.";
      example = lib.literalExpression ''
        pkgs.writeText "periphery.toml" '''
          port = 8120
          bind_ip = "[::]"
          ssl_enabled = true
          [logging]
          level = "info"
        '''
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8120;
      description = "Port for the Periphery agent to listen on.";
    };

    bindIp = lib.mkOption {
      type = lib.types.str;
      default = "[::]";
      description = "IP address to bind to.";
    };

    rootDirectory = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/komodo-periphery";
      description = "Root directory for Komodo Periphery data.";
    };

    ssl = {
      enable = lib.mkEnableOption "SSL/TLS support" // {
        default = true;
      };

      keyFile = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.rootDirectory}/ssl/key.pem";
        defaultText = lib.literalExpression ''"''${config.services.komodo-periphery.rootDirectory}/ssl/key.pem"'';
        description = "Path to SSL key file.";
      };

      certFile = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.rootDirectory}/ssl/cert.pem";
        defaultText = lib.literalExpression ''"''${config.services.komodo-periphery.rootDirectory}/ssl/cert.pem"'';
        description = "Path to SSL certificate file.";
      };
    };

    logging = {
      level = lib.mkOption {
        type = lib.types.enum [
          "off"
          "error"
          "warn"
          "info"
          "debug"
          "trace"
        ];
        default = "info";
        description = "Logging verbosity level.";
      };

      stdio = lib.mkOption {
        type = lib.types.enum [
          "standard"
          "json"
          "none"
        ];
        default = "standard";
        description = "Logging format for stdout/stderr.";
      };

      otlpEndpoint = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "OpenTelemetry OTLP endpoint for traces.";
        example = "http://localhost:4317";
      };
    };

    allowedIps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "IP addresses or subnets allowed to call the periphery API. Empty list allows all.";
      example = [
        "::ffff:12.34.56.78"
        "10.0.10.0/24"
      ];
    };

    passkeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Passkeys required to access the periphery API.
        WARNING: These will be stored in the Nix store in plain text!
      '';
      example = [ "your-secure-passkey" ];
    };

    extraSettings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = "Extra settings to add to the generated TOML config.";
      example = {
        secrets.GITHUB_TOKEN = "ghp_xxxx";
      };
    };

    disableTerminals = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable remote shell access through Periphery.";
    };

    disableContainerExec = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable remote container shell access through Periphery.";
    };

    statsPollingRate = lib.mkOption {
      type = lib.types.str;
      default = "5-sec";
      description = "System stats polling interval.";
      example = "10-sec";
    };

    containerStatsPollingRate = lib.mkOption {
      type = lib.types.str;
      default = "30-sec";
      description = "Container stats polling interval.";
      example = "1-min";
    };

    legacyComposeCli = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use `docker-compose` instead of `docker compose`.";
    };

    includeDiskMounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Only include these mount paths in disk reporting.";
      example = [
        "/mnt/data"
        "/mnt/backup"
      ];
    };

    excludeDiskMounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Exclude these mount paths from disk reporting.";
      example = [
        "/tmp"
        "/boot"
      ];
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "komodo-periphery";
      description = "User under which the Periphery agent runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "komodo-periphery";
      description = "Group under which the Periphery agent runs.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Environment file for additional configuration via environment variables.";
      example = "/run/secrets/komodo-periphery.env";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Environment variables to set for the service.";
      example = {
        RUST_LOG = "komodo=debug";
        DOCKER_HOST = "unix:///var/run/docker.sock";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    users.users.${cfg.user} = lib.mkIf (cfg.user == "komodo-periphery") {
      isSystemUser = true;
      group = cfg.group;
      description = "Komodo Periphery service user";
      home = cfg.rootDirectory;
      extraGroups = [ "docker" ];
    };

    users.groups.${cfg.group} = lib.mkIf (cfg.group == "komodo-periphery") { };

    systemd.tmpfiles.settings."10-komodo-periphery" = {
      "${cfg.rootDirectory}".d = {
        mode = "0755";
        user = cfg.user;
        group = cfg.group;
      };
      "${cfg.rootDirectory}/repos".d = {
        mode = "0755";
        user = cfg.user;
        group = cfg.group;
      };
      "${cfg.rootDirectory}/stacks".d = {
        mode = "0755";
        user = cfg.user;
        group = cfg.group;
      };
      "${cfg.rootDirectory}/ssl".d = {
        mode = "0700";
        user = cfg.user;
        group = cfg.group;
      };
    };

    systemd.services.komodo-periphery = {
      description = "Komodo Periphery - Multi-server Docker and Git deployment agent";
      after = [
        "network-online.target"
        "docker.service"
      ];
      wants = [
        "network-online.target"
        "docker.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        SupplementaryGroups = [ "docker" ];
        Restart = "on-failure";
        RestartSec = "10s";
        WorkingDirectory = cfg.rootDirectory;

        ExecStart = lib.escapeShellArgs [
          "${lib.getExe' cfg.package "periphery"}"
          "--config-path"
          (if cfg.configFile != null then cfg.configFile else configFile)
        ];

        Environment = lib.mapAttrsToList (name: value: "${name}=${value}") (
          cfg.environment
          // lib.optionalAttrs (!cfg.disableTerminals) {
            PATH = "/run/current-system/sw/bin:/run/wrappers/bin";
          }
        );
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        StateDirectory = "komodo-periphery";
        StateDirectoryMode = "0755";

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ channinghe ];
}
