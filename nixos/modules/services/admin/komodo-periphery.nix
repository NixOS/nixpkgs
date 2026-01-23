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
      # Determine the actual value for disable_container_terminals
      # Use disableContainerTerminals, but fall back to disableContainerExec if set
      actualDisableContainerTerminals =
        if cfg.disableContainerExec != false then
          cfg.disableContainerExec
        else
          cfg.disableContainerTerminals;

      # Backward compatibility: check if old-style options are used
      usingOldPort = cfg.port != 8120;
      usingOldBindIp = cfg.bindIp != "[::]";
      usingOldAllowedIps = cfg.allowedIps != [ ];
      usingOldSsl =
        cfg.ssl.enable != true
        || cfg.ssl.keyFile != "${cfg.rootDirectory}/ssl/key.pem"
        || cfg.ssl.certFile != "${cfg.rootDirectory}/ssl/cert.pem";
      usingOldServerEnabled = cfg.serverEnabled != null;

      # Determine actual values (prefer new inbound.* options, fall back to old top-level options)
      actualPort = if usingOldPort then cfg.port else cfg.inbound.port;
      actualBindIp = if usingOldBindIp then cfg.bindIp else cfg.inbound.bindIp;
      actualAllowedIps = if usingOldAllowedIps then cfg.allowedIps else cfg.inbound.allowedIps;
      actualSslEnable = if usingOldSsl then cfg.ssl.enable else cfg.inbound.ssl.enable;
      actualSslKeyFile = if usingOldSsl then cfg.ssl.keyFile else cfg.inbound.ssl.keyFile;
      actualSslCertFile = if usingOldSsl then cfg.ssl.certFile else cfg.inbound.ssl.certFile;
      actualServerEnabled =
        if usingOldServerEnabled then
          cfg.serverEnabled
        else if cfg.inbound.serverEnabled != null then
          cfg.inbound.serverEnabled
        else
          # Per documentation: defaults to false when outbound.coreAddress is defined, otherwise true
          (cfg.outbound.coreAddress == "");

      # ALL sensitive data will be passed via environment variables for security
      # Only check for private key as it has special default behavior
      hasAnyPrivateKey = cfg.auth.privateKey != "";

      baseSettings = {
        root_directory = cfg.rootDirectory;
        repo_dir = "${cfg.rootDirectory}/repos";
        stack_dir = "${cfg.rootDirectory}/stacks";
        build_dir = if cfg.buildDir != null then cfg.buildDir else "${cfg.rootDirectory}/builds";

        default_terminal_command = cfg.defaultTerminalCommand;
        disable_terminals = cfg.disableTerminals;
        disable_container_terminals = actualDisableContainerTerminals;

        stats_polling_rate = cfg.statsPollingRate;
        container_stats_polling_rate = cfg.containerStatsPollingRate;
        legacy_compose_cli = cfg.legacyComposeCli;

        include_disk_mounts = cfg.includeDiskMounts;
        exclude_disk_mounts = cfg.excludeDiskMounts;

        # Authentication - ALL sensitive fields excluded (passed via environment variables)
        # Set to empty/default so they don't appear in TOML
        private_key = if !hasAnyPrivateKey then "file:${cfg.rootDirectory}/keys/periphery.key" else "";
        core_public_keys = [ ]; # Always exclude, use env var
        passkeys = [ ]; # Always exclude, use env var

        # Inbound mode
        server_enabled = actualServerEnabled;
        port = actualPort;
        bind_ip = actualBindIp;
        allowed_ips = actualAllowedIps;
        ssl_enabled = actualSslEnable;
      }
      // lib.optionalAttrs actualSslEnable {
        ssl_key_file = actualSslKeyFile;
        ssl_cert_file = actualSslCertFile;
      }
      // {
        # Outbound mode - exclude onboarding key (passed via environment variable)
        core_address = cfg.outbound.coreAddress;
        connect_as = cfg.outbound.connectAs;
        onboarding_key = ""; # Always exclude, use env var
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

  # Determine if we need to generate environment script

  needsEnvScript =
    cfg.passkeys != [ ]
    || cfg.passkeyFiles != null
    || cfg.auth.privateKey != ""
    || cfg.auth.corePublicKeys != [ ]
    || cfg.outbound.onboardingKey != ""
    || cfg.outbound.onboardingKeyFile != null;

  # Script to generate environment file with sensitive data
  # This script will run as the service user to ensure proper permissions
  genEnvScript = pkgs.writeShellScript "komodo-periphery-gen-env" ''
    set -euo pipefail

    ENV_FILE="/run/komodo-periphery/env"
    # RuntimeDirectory is already created by systemd with correct ownership
    rm -f "$ENV_FILE"
    touch "$ENV_FILE"
    # Set restrictive permissions - only the service user can read
    chmod 400 "$ENV_FILE"

    # Passkeys (Legacy v1.X)
    ${lib.optionalString (cfg.passkeyFiles != null) ''
      echo "PERIPHERY_PASSKEYS_FILE=${cfg.passkeyFiles}" >> "$ENV_FILE"
    ''}
    ${lib.optionalString (cfg.passkeys != [ ]) ''
      printf 'PERIPHERY_PASSKEYS=%s\n' ${lib.escapeShellArg (builtins.toJSON cfg.passkeys)} >> "$ENV_FILE"
    ''}

    # Private key (v2.0+) - direct configuration
    ${lib.optionalString (cfg.auth.privateKey != "") ''
      printf '%s\n' ${lib.escapeShellArg "PERIPHERY_PRIVATE_KEY=${cfg.auth.privateKey}"} >> "$ENV_FILE"
    ''}

    # Core public keys (v2.0+) - direct configuration (may include file: prefixes)
    ${lib.optionalString (cfg.auth.corePublicKeys != [ ]) ''
      printf '%s\n' ${lib.escapeShellArg "PERIPHERY_CORE_PUBLIC_KEYS=${lib.concatStringsSep "," cfg.auth.corePublicKeys}"} >> "$ENV_FILE"
    ''}

    # Onboarding key (v2.0+)
    ${lib.optionalString (cfg.outbound.onboardingKeyFile != null) ''
      echo "PERIPHERY_ONBOARDING_KEY_FILE=${cfg.outbound.onboardingKeyFile}" >> "$ENV_FILE"
    ''}
    ${lib.optionalString (cfg.outbound.onboardingKey != "") ''
      printf '%s\n' ${lib.escapeShellArg "PERIPHERY_ONBOARDING_KEY=${cfg.outbound.onboardingKey}"} >> "$ENV_FILE"
    ''}

    echo "Environment file generated at $ENV_FILE"
  '';
in
{
  options.services.komodo-periphery = {
    enable = lib.mkEnableOption "Periphery, a multi-server Docker and Git deployment agent by Komodo";

    package = lib.mkPackageOption pkgs "komodo" { };

    binaryPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Custom path to the Periphery binary.
        If null, uses `periphery` from the specified package.
        This is useful for testing custom builds or using a manually installed binary.
      '';
      example = "/usr/local/bin/periphery";
    };

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

    passkeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        (Deprecated - Legacy v1.X compatibility) Passkeys required to access the periphery API.
        Consider migrating to the new authentication mechanism using `auth.privateKey` and `auth.corePublicKeys`.

        For better security, use `passkeyFiles` instead to avoid storing secrets in the Nix store.
        If set, this will be passed via environment variable at runtime.
      '';
      example = [ "your-secure-passkey" ];
    };

    passkeyFiles = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        (Deprecated - Legacy v1.X compatibility) Path to file containing passkeys.

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

    disableContainerExec = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "(Deprecated - use `disableContainerTerminals`) Disable remote container shell access through Periphery.";
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

          If neither these nor passkeys are provided, inbound connections will not be authenticated.

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

    # Inbound mode configuration (for Core -> Periphery connections)
    # v2.0+: These options are reorganized under the inbound namespace
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

    # Outbound mode configuration (for Periphery -> Core connections)
    # v2.0+: New outbound mode allows Periphery to initiate connections to Core
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

      onboardingKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          (v2.0+) Onboarding key for registering new servers.
          Make Onboarding Keys in Server settings.
          Not needed if connecting as a Server that already exists.

          For better security with secrets management, use `onboardingKeyFile` instead.
        '';
        example = "MC4CAQAwBQYDK2VuBCIEIHPHNA/0M9ejFviE2y4dpyczAvnAwPWDQtGGGhEJ2G6K";
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

    # Backward compatibility aliases (deprecated)
    port = lib.mkOption {
      type = lib.types.port;
      default = 8120;
      visible = false;
      description = "(Deprecated - use `inbound.port`) Port for the Periphery agent to listen on.";
    };

    bindIp = lib.mkOption {
      type = lib.types.str;
      default = "[::]";
      visible = false;
      description = "(Deprecated - use `inbound.bindIp`) IP address to bind to.";
    };

    allowedIps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      visible = false;
      description = "(Deprecated - use `inbound.allowedIps`) IP addresses or subnets allowed to call the periphery API.";
    };

    ssl = {
      enable = lib.mkEnableOption "SSL/TLS support" // {
        default = true;
        visible = false;
      };

      keyFile = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.rootDirectory}/ssl/key.pem";
        visible = false;
        description = "(Deprecated - use `inbound.ssl.keyFile`) Path to SSL key file.";
      };

      certFile = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.rootDirectory}/ssl/cert.pem";
        visible = false;
        description = "(Deprecated - use `inbound.ssl.certFile`) Path to SSL certificate file.";
      };
    };

    serverEnabled = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      visible = false;
      description = "(Deprecated - use `inbound.serverEnabled`) Enable the inbound connection server.";
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
    # Backward compatibility and deprecation warnings
    warnings =
      lib.optional (cfg.disableContainerExec != false)
        "services.komodo-periphery.disableContainerExec is deprecated, use disableContainerTerminals instead"
      ++
        lib.optional (cfg.passkeys != [ ])
          "services.komodo-periphery.passkeys is deprecated (legacy v1 compatibility). Consider migrating to auth.privateKey and auth.corePublicKeys authentication."
      ++ lib.optional (
        cfg.port != 8120
      ) "services.komodo-periphery.port is deprecated, use inbound.port instead"
      ++ lib.optional (
        cfg.bindIp != "[::]"
      ) "services.komodo-periphery.bindIp is deprecated, use inbound.bindIp instead"
      ++ lib.optional (
        cfg.allowedIps != [ ]
      ) "services.komodo-periphery.allowedIps is deprecated, use inbound.allowedIps instead"
      ++ lib.optional (
        cfg.serverEnabled != null
      ) "services.komodo-periphery.serverEnabled is deprecated, use inbound.serverEnabled instead"
      ++ lib.optional (
        cfg.ssl.enable != true
        || cfg.ssl.keyFile != "${cfg.rootDirectory}/ssl/key.pem"
        || cfg.ssl.certFile != "${cfg.rootDirectory}/ssl/cert.pem"
      ) "services.komodo-periphery.ssl.* options are deprecated, use inbound.ssl.* instead";

    # Ensure compatibility
    assertions = [
      {
        assertion = !(cfg.auth.corePublicKeys != [ ] && cfg.passkeys != [ ]);
        message = "services.komodo-periphery: Cannot use both auth.corePublicKeys (v2) and passkeys (v1 legacy) authentication simultaneously.";
      }
      {
        assertion = !(cfg.passkeyFiles != null && cfg.passkeys != [ ]);
        message = "services.komodo-periphery: Cannot use both passkeyFiles and passkeys. Use passkeyFiles for better security.";
      }
      {
        assertion = !(cfg.outbound.onboardingKeyFile != null && cfg.outbound.onboardingKey != "");
        message = "services.komodo-periphery: Cannot use both outbound.onboardingKeyFile and outbound.onboardingKey. Use outbound.onboardingKeyFile for better security.";
      }
    ];

    # Enable Docker only if no custom dockerHost is specified
    virtualisation.docker.enable = lib.mkDefault (cfg.dockerHost == null);

    users.users.${cfg.user} = lib.mkIf (cfg.user == "komodo-periphery") {
      isSystemUser = true;
      group = cfg.group;
      description = "Komodo Periphery service user";
      home = cfg.rootDirectory;
      # Add to docker group only if using default Docker
      extraGroups = lib.optional (cfg.dockerHost == null) "docker";
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
      "${cfg.rootDirectory}/builds".d = {
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
        SupplementaryGroups = lib.optional (cfg.dockerHost == null) "docker";
        Restart = "on-failure";
        RestartSec = "10s";
        WorkingDirectory = cfg.rootDirectory;

        # Generate environment file before starting (only if needed for direct config)
        # This runs as the service user (cfg.user) to ensure proper file permissions
        ExecStartPre = lib.mkIf needsEnvScript genEnvScript;

        ExecStart = lib.escapeShellArgs [
          (if cfg.binaryPath != null then cfg.binaryPath else "${lib.getExe' cfg.package "periphery"}")
          "--config-path"
          (if cfg.configFile != null then cfg.configFile else configFile)
        ];

        Environment = lib.mapAttrsToList (name: value: "${name}=${value}") (
          cfg.environment
          // lib.optionalAttrs (cfg.dockerHost != null) {
            DOCKER_HOST = cfg.dockerHost;
          }
        );

        # Provide additional executable search paths for terminal functionality
        ExecSearchPath = lib.optionals (!cfg.disableTerminals) [
          "/run/current-system/sw/bin"
          "/run/wrappers/bin"
        ];

        # Load environment files in order:
        # 1. Generated environment file with sensitive data (all *File options and direct config)
        # 2. User-provided environmentFile (if specified)
        EnvironmentFile =
          lib.optional needsEnvScript "-/run/komodo-periphery/env"
          ++ lib.optional (cfg.environmentFile != null) cfg.environmentFile;

        RuntimeDirectory = lib.mkIf needsEnvScript "komodo-periphery";
        RuntimeDirectoryMode = lib.mkIf needsEnvScript "0700";
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
