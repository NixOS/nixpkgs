{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.komodo-periphery;
  settingsFormat = pkgs.formats.toml { };

  actualRepoDir = if cfg.repoDir != null then cfg.repoDir else "${cfg.rootDirectory}/repos";
  actualStackDir = if cfg.stackDir != null then cfg.stackDir else "${cfg.rootDirectory}/stacks";
  actualBuildDir = if cfg.buildDir != null then cfg.buildDir else "${cfg.rootDirectory}/builds";

  genFinalSettings =
    let
      actualServerEnabled =
        if cfg.inbound.serverEnabled != null then
          cfg.inbound.serverEnabled
        else
          (cfg.outbound.coreAddress == "");

      hasAnyPrivateKey = cfg.auth.privateKey != "";

      baseSettings = {
        default_terminal_command = cfg.defaultTerminalCommand;
        disable_terminals = cfg.disableTerminals;
        disable_container_terminals = cfg.disableContainerTerminals;

        stats_polling_rate = cfg.statsPollingRate;
        container_stats_polling_rate = cfg.containerStatsPollingRate;
        legacy_compose_cli = cfg.legacyComposeCli;

        include_disk_mounts = cfg.includeDiskMounts;
        exclude_disk_mounts = cfg.excludeDiskMounts;

        # When a private key is explicitly configured, it's passed via env var.
        # Otherwise, use the default file path so Periphery auto-generates a key.
        private_key = if !hasAnyPrivateKey then "file:${cfg.rootDirectory}/keys/periphery.key" else "";
        core_public_keys = [ ];
        passkeys = [ ];

        server_enabled = actualServerEnabled;
        port = cfg.inbound.port;
        bind_ip = cfg.inbound.bindIp;
        allowed_ips = cfg.inbound.allowedIps;
        ssl_enabled = cfg.inbound.ssl.enable;
      }
      // {
        core_address = cfg.outbound.coreAddress;
        connect_as = cfg.outbound.connectAs;
        onboarding_key = "";
      }
      // {
        logging = {
          level = cfg.logging.level;
          stdio = cfg.logging.stdio;
          opentelemetry_service_name = cfg.logging.opentelemetryServiceName;
          opentelemetry_scope_name = cfg.logging.opentelemetryScopeName;
          pretty = cfg.logging.pretty;
        }
        // lib.optionalAttrs (cfg.logging.otlpEndpoint != "") {
          otlp_endpoint = cfg.logging.otlpEndpoint;
        };
        pretty_startup_config = cfg.prettyStartupConfig;
      }
      // cfg.extraSettings;
    in
    lib.filterAttrsRecursive (_: v: v != null && v != { } && v != [ ] && v != "") baseSettings;

  configFile =
    if cfg.configFile == null then
      settingsFormat.generate "komodo-periphery.toml" genFinalSettings
    else
      cfg.configFile;
in
{
  imports = with lib; [
    (mkRenamedOptionModule
      [ "services" "komodo-periphery" "port" ]
      [ "services" "komodo-periphery" "inbound" "port" ]
    )
    (mkRenamedOptionModule
      [ "services" "komodo-periphery" "bindIp" ]
      [ "services" "komodo-periphery" "inbound" "bindIp" ]
    )
    (mkRenamedOptionModule
      [ "services" "komodo-periphery" "allowedIps" ]
      [ "services" "komodo-periphery" "inbound" "allowedIps" ]
    )
    (mkRenamedOptionModule
      [ "services" "komodo-periphery" "ssl" "enable" ]
      [ "services" "komodo-periphery" "inbound" "ssl" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "komodo-periphery" "ssl" "keyFile" ]
      [ "services" "komodo-periphery" "inbound" "ssl" "keyFile" ]
    )
    (mkRenamedOptionModule
      [ "services" "komodo-periphery" "ssl" "certFile" ]
      [ "services" "komodo-periphery" "inbound" "ssl" "certFile" ]
    )
    (mkRenamedOptionModule
      [ "services" "komodo-periphery" "serverEnabled" ]
      [ "services" "komodo-periphery" "inbound" "serverEnabled" ]
    )
    (mkRenamedOptionModule
      [ "services" "komodo-periphery" "disableContainerExec" ]
      [ "services" "komodo-periphery" "disableContainerTerminals" ]
    )
    (mkRemovedOptionModule [ "services" "komodo-periphery" "passkeys" ]
      "services.komodo-periphery.passkeys has been removed. Use passkeyFiles for v1.X compatibility, or migrate to auth.privateKey and auth.corePublicKeys (v2.0+)."
    )
    (mkRemovedOptionModule [ "services" "komodo-periphery" "outbound" "onboardingKey" ]
      "services.komodo-periphery.outbound.onboardingKey has been removed. Use outbound.onboardingKeyFile instead for better security."
    )
  ];

  options.services.komodo-periphery = {
    enable = lib.mkEnableOption "Periphery, a multi-server Docker and Git deployment agent by Komodo";

    package = lib.mkPackageOption pkgs "komodo" { };

    dockerHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Docker host socket URI to use for container operations.
        If null, uses the default Docker socket and automatically enables Docker.
        Set this to use alternative container runtimes like Podman or remote Docker hosts.
      '';
      example = lib.literalExpression ''
        # Podman rootless
        "unix:///run/user/1000/podman/podman.sock"

        # Podman rootful
        "unix:///run/podman/podman.sock"

        # Remote Docker
        "tcp://192.168.1.100:2375"
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to the Periphery configuration file.

        - If `null` (default), a configuration file will be automatically generated
          from the module options (recommended for most users).
        - If set to a path, that file will be used directly as the configuration file.
        - You can also use `pkgs.writeText` to write configuration inline in your NixOS configuration.

        When using a custom config file, all other module options (except `package`, `user`, `group`,
        `environment`, and `environmentFile`) will be ignored.
      '';
      example = lib.literalExpression ''
        # Option 1: Use an existing config file
        "/etc/komodo/periphery.toml"

        # Option 2: Write config inline using pkgs.writeText
        pkgs.writeText "periphery.toml" '''
          root_directory = "/var/lib/komodo-periphery"

          logging.level = "info"
          logging.stdio = "standard"
        '''
      '';
    };

    rootDirectory = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/komodo-periphery";
      description = "Root directory for Komodo Periphery data.";
    };

    repoDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      defaultText = lib.literalExpression ''"''${config.services.komodo-periphery.rootDirectory}/repos"'';
      description = "Directory for Komodo Periphery to manage repos. If null, defaults to `\${rootDirectory}/repos`.";
    };

    stackDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      defaultText = lib.literalExpression ''"''${config.services.komodo-periphery.rootDirectory}/stacks"'';
      description = "Directory for Komodo Periphery to manage stacks. If null, defaults to `\${rootDirectory}/stacks`.";
    };

    buildDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      defaultText = lib.literalExpression ''"''${config.services.komodo-periphery.rootDirectory}/builds"'';
      description = "Directory for Komodo Periphery to manage builds. If null, defaults to `\${rootDirectory}/builds`.";
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

      opentelemetryServiceName = lib.mkOption {
        type = lib.types.str;
        default = "Periphery";
        description = "(v2.0+) OpenTelemetry service name attached to telemetry.";
      };

      opentelemetryScopeName = lib.mkOption {
        type = lib.types.str;
        default = "Komodo";
        description = "(v2.0+) OpenTelemetry scope name attached to telemetry.";
      };

      pretty = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "(v2.0+) Enable human-readable logging (multi-line).";
      };
    };

    prettyStartupConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "(v2.0+) Enable human-readable startup config log (multi-line).";
    };

    passkeyFiles = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to file containing passkeys (v1.X compatibility).
        This will be passed via `PERIPHERY_PASSKEYS_FILE` environment variable.
        Consider migrating to the new v2.0+ authentication mechanism.
      '';
      example = "/run/secrets/komodo-passkey";
    };

    extraSettings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = "Extra settings to add to the generated TOML config.";
      example = {
        secrets.GITHUB_TOKEN = "ghp_xxxx";
      };
    };

    defaultTerminalCommand = lib.mkOption {
      type = lib.types.str;
      default = "bash";
      description = "(v2.0+) Default terminal command used to initialize the shell.";
      example = "zsh";
    };

    disableTerminals = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable remote shell access through Periphery.";
    };

    disableContainerTerminals = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "(v2.0+) Disable remote container shell access through Periphery.";
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

    auth = {
      privateKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          (v2.0+) Private key used with the Noise handshake.

          Use `file:/path/to/file` prefix to load from a file. If the file doesn't exist,
          Periphery will generate and write a new key to the path.

          If empty, defaults to `file:''${rootDirectory}/keys/periphery.key`.
        '';
        example = lib.literalExpression ''
          # Reference a secret file
          "file:''${config.age.secrets.komodo-private-key.path}"

          # Or direct path
          "file:/run/secrets/komodo-private-key"
        '';
      };

      corePublicKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          (v2.0+) Accepted public keys to allow Core(s) to connect.
          Accepts Spki base64 DER directly or can reference files using `file:/path/to/core.pub` prefix.
          You can mix direct keys and file references.

          For better security, use the `file:` prefix to reference secret files.
        '';
        example = lib.literalExpression ''
          [
            # Direct key value
            "MCowBQYDK2VuAyEATZgrjGHeF0KJUe0+n77+qAWOg3YzEzXOmQWaRgO3OGQ="
            # Reference secret files
            "file:''${config.age.secrets.komodo-core1-pub.path}"
            "file:''${config.age.secrets.komodo-core2-pub.path}"
          ]
        '';
      };
    };

    inbound = {
      serverEnabled = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Enable the inbound connection server for Core -> Periphery connections.
          If null, defaults to false when `outbound.coreAddress` is defined, otherwise true.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8120;
        description = "Port for the inbound Periphery server to listen on.";
      };

      bindIp = lib.mkOption {
        type = lib.types.str;
        default = "[::]";
        description = ''
          IP address the periphery server will bind to.
          The default allows external IPv4 and IPv6 connections.
        '';
      };

      allowedIps = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Limit the IP addresses which can connect to Periphery.
          Supports IPv4/IPv6 addresses and subnets.
          Empty list allows all connections.
        '';
        example = [
          "::ffff:12.34.56.78"
          "10.0.10.0/24"
        ];
      };

      ssl = {
        enable = lib.mkEnableOption "(v2.0+) SSL/TLS support for inbound connections" // {
          default = true;
        };

        keyFile = lib.mkOption {
          type = lib.types.path;
          default = "${cfg.rootDirectory}/ssl/key.pem";
          defaultText = lib.literalExpression ''"''${config.services.komodo-periphery.rootDirectory}/ssl/key.pem"'';
          description = ''
            Path to SSL key file.
            If the file doesn't exist and SSL is enabled, self-signed keys will be generated using openssl.
          '';
        };

        certFile = lib.mkOption {
          type = lib.types.path;
          default = "${cfg.rootDirectory}/ssl/cert.pem";
          defaultText = lib.literalExpression ''"''${config.services.komodo-periphery.rootDirectory}/ssl/cert.pem"'';
          description = ''
            Path to SSL certificate file.
            If the file doesn't exist and SSL is enabled, self-signed certificate will be generated using openssl.
          '';
        };
      };
    };

    outbound = {
      coreAddress = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          (v2.0+) The address of Komodo Core. Must be reachable from this host.
          If provided, Periphery will operate in outbound mode.
        '';
        example = "demo.komo.do";
      };

      connectAs = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          (v2.0+) The Server this Periphery agent should connect as.
          Must match an existing Server name or id.
        '';
        example = "server-name";
      };

      onboardingKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          (v2.0+) Path to file containing the onboarding key.
          This will be passed via `PERIPHERY_ONBOARDING_KEY_FILE` environment variable.
        '';
        example = lib.literalExpression ''"''${config.age.secrets.komodo-onboarding.path}"'';
      };
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
    virtualisation.docker.enable = lib.mkDefault (cfg.dockerHost == null);

    users.users.${cfg.user} = lib.mkIf (cfg.user == "komodo-periphery") {
      isSystemUser = true;
      group = cfg.group;
      description = "Komodo Periphery service user";
      home = cfg.rootDirectory;
      extraGroups = lib.optional (cfg.dockerHost == null) "docker";
    };

    users.groups.${cfg.group} = lib.mkIf (cfg.group == "komodo-periphery") { };

    systemd.tmpfiles.settings."10-komodo-periphery" = {
      "${cfg.rootDirectory}".d = {
        mode = "0755";
        user = cfg.user;
        group = cfg.group;
      };
      "${actualRepoDir}".d = {
        mode = "0755";
        user = cfg.user;
        group = cfg.group;
      };
      "${actualStackDir}".d = {
        mode = "0755";
        user = cfg.user;
        group = cfg.group;
      };
      "${actualBuildDir}".d = {
        mode = "0755";
        user = cfg.user;
        group = cfg.group;
      };
      "${cfg.rootDirectory}/keys".d = {
        mode = "0700";
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
      ]
      ++ lib.optional (cfg.dockerHost == null) "docker.service";
      wants = [
        "network-online.target"
      ]
      ++ lib.optional (cfg.dockerHost == null) "docker.service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        SupplementaryGroups = lib.mkIf (cfg.dockerHost == null) [ "docker" ];
        Restart = "on-failure";
        RestartSec = "10s";
        WorkingDirectory = cfg.rootDirectory;

        ExecStart = lib.escapeShellArgs [
          (lib.getExe' cfg.package "periphery")
          "--config-path"
          configFile
        ];

        Environment = lib.mapAttrsToList (name: value: "${name}=${value}") (
          lib.optionalAttrs (cfg.configFile == null) {
            PERIPHERY_ROOT_DIRECTORY = cfg.rootDirectory;
            PERIPHERY_REPO_DIR = actualRepoDir;
            PERIPHERY_STACK_DIR = actualStackDir;
            PERIPHERY_BUILD_DIR = actualBuildDir;
          }
          // lib.optionalAttrs (cfg.configFile == null && cfg.inbound.ssl.enable) {
            PERIPHERY_SSL_KEY_FILE = cfg.inbound.ssl.keyFile;
            PERIPHERY_SSL_CERT_FILE = cfg.inbound.ssl.certFile;
          }
          // lib.optionalAttrs (cfg.dockerHost != null) {
            DOCKER_HOST = cfg.dockerHost;
          }
          // lib.optionalAttrs (cfg.passkeyFiles != null) {
            PERIPHERY_PASSKEYS_FILE = cfg.passkeyFiles;
          }
          // lib.optionalAttrs (cfg.auth.privateKey != "") {
            PERIPHERY_PRIVATE_KEY = cfg.auth.privateKey;
          }
          // lib.optionalAttrs (cfg.auth.corePublicKeys != [ ]) {
            PERIPHERY_CORE_PUBLIC_KEYS = lib.concatStringsSep "," cfg.auth.corePublicKeys;
          }
          // lib.optionalAttrs (cfg.outbound.onboardingKeyFile != null) {
            PERIPHERY_ONBOARDING_KEY_FILE = cfg.outbound.onboardingKeyFile;
          }
          // cfg.environment
        );

        ExecSearchPath = lib.mkIf (!cfg.disableTerminals) [
          "/run/current-system/sw/bin"
          "/run/wrappers/bin"
        ];

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
