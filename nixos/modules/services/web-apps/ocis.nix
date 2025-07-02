{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.ocis;

  # Generate environment file content only if environment variables are defined
  envFile =
    if cfg.environment != null then
      pkgs.writeText "ocis.env" (
        concatStringsSep "\n" (mapAttrsToList (name: value: "${name}=${toString value}") cfg.environment)
      )
    else
      null;

  # Setup script that runs once after package installation
  setupScript = pkgs.writeShellScript "ocis-setup" ''
    set -euo pipefail

    echo "Setting up ocis..."
    # doesnt run if the config file has already been initialized
    if [[ -f "${cfg.configDir}/ocis.yaml" ]]; then
      echo "Config file ${cfg.configDir}/ocis.yaml already exists, skipping setup"
      exit 0
    fi

    # Set URL and address explicitly
    export OCIS_URL="${cfg.url}"
    export PROXY_HTTP_ADDR="${cfg.address}:${toString cfg.port}"

    # Set config directory if specified
    ${optionalString (cfg.configDir != null) ''
      export OCIS_CONFIG_DIR="${cfg.configDir}"
    ''}

    # Set ACME cert paths if configured
    ${optionalString (cfg.useACMEHost != null) ''
      export PROXY_TRANSPORT_TLS_CERT="${
        config.security.acme.certs.${cfg.useACMEHost}.directory
      }/fullchain.pem"
      export PROXY_TRANSPORT_TLS_KEY="${config.security.acme.certs.${cfg.useACMEHost}.directory}/key.pem"
    ''}

    # Source user environment variables if provided
    ${optionalString (cfg.environment != null) ''
      set -a
      source ${envFile}
      set +a
    ''}

    # Source secrets file if provided
    ${optionalString (cfg.environmentFile != null) ''
      set -a
      if [[ -f "${cfg.environmentFile}" ]]; then
        source "${cfg.environmentFile}"
      else
        echo "Warning: Secrets file ${cfg.environmentFile} not found"
      fi
      set +a
    ''}

    # Run the ocis binary with environment variables
    ${cfg.package}/bin/ocis init --insecure ${if cfg.insecure then "true" else "false"}

    echo "ocis setup completed successfully"
  '';

in
{
  options.services.ocis = {
    enable = mkEnableOption "ocis service";

    package = mkOption {
      type = types.package;
      default = pkgs.ocis_5-bin;
      defaultText = literalExpression "pkgs.ocis_5-bin";
      description = ''
        The ocis package to use for the service.
        This allows you to specify a custom package or override the default.
      '';
    };

    useACMEHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        A host of an existing Let's Encrypt certificate to use.
        This will automatically set the cert and key paths in the environment.
      '';
    };

    url = mkOption {
      type = types.str;
      default = "https://localhost:9200";
      description = ''
        The URL where ocis will be accessible.
        This sets the OCIS_URL environment variable.
      '';
    };

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        The address that ocis will bind to.
        Combined with port to set PROXY_HTTP_ADDR environment variable.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 9200;
      description = ''
        The port that ocis will listen on.
        Combined with address to set PROXY_HTTP_ADDR environment variable.
      '';
    };

    environment = mkOption {
      type = types.nullOr (types.attrsOf types.str);
      default = null;
      description = ''
        Environment variables to pass to the ocis service.
        These will be written to an environment file and sourced by the service.
        Do not include secrets or sensitive values here - use environmentFile instead.
          {
            CS3_ALLOW_INSECURE = "true";
            GATEWAY_STORAGE_USERS_MOUNT_ID = "123";
            GRAPH_APPLICATION_ID = "1234";
            IDM_IDPSVC_PASSWORD = "password";
            IDM_REVASVC_PASSWORD = "password";
            IDM_SVC_PASSWORD = "password";
            IDP_ISS = "https://localhost:9200";
            IDP_TLS = "false";
            OCIS_INSECURE = "false";
            OCIS_INSECURE_BACKENDS = "true";
            OCIS_JWT_SECRET = "super_secret";
            OCIS_LDAP_BIND_PASSWORD = "password";
            OCIS_LOG_LEVEL = "error";
            OCIS_MACHINE_AUTH_API_KEY = "foo";
            OCIS_MOUNT_ID = "123";
            OCIS_SERVICE_ACCOUNT_ID = "foo";
            OCIS_SERVICE_ACCOUNT_SECRET = "foo";
            OCIS_STORAGE_USERS_MOUNT_ID = "123";
            OCIS_SYSTEM_USER_API_KEY = "foo";
            OCIS_SYSTEM_USER_ID = "123";
            OCIS_TRANSFER_SECRET = "foo";
            STORAGE_USERS_MOUNT_ID = "123";
            TLS_INSECURE = "true";
            TLS_SKIP_VERIFY_CLIENT_CERT = "true";
            WEBDAV_ALLOW_INSECURE = "true";
          }
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to an environment file containing secrets and sensitive values.
        This file should contain KEY=VALUE pairs, one per line.
        The file will be sourced by the service in addition to the regular environment variables.
        Example contents:
          OCIS_JWT_SECRET=your-secret-here
          OCIS_MACHINE_AUTH_API_KEY=your-api-key
          OCIS_SYSTEM_USER_API_KEY=another-key
      '';
    };

    insecure = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable insecure mode for ocis initialization.
        When set to true, adds "--insecure true" to the ocis init command.
        This should only be used for development or testing purposes.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "ocis";
      description = "User account under which ocis runs.";
    };

    group = mkOption {
      type = types.str;
      default = "ocis";
      description = "Group under which ocis runs.";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/ocis";
      description = "Directory where ocis stores its data.";
    };

    configDir = mkOption {
      type = types.nullOr types.path;
      default = "/etc/ocis/config";
      description = ''
        Directory where ocis configuration files are stored.
        If specified, will be set as OCIS_CONFIG_DIR environment variable.
        If null, ocis will use its default configuration location.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Ensure ACME certificates are available if useACMEHost is set
    assertions = [
      {
        assertion = cfg.useACMEHost == null || config.security.acme.certs ? ${cfg.useACMEHost};
        message = "ACME certificate for host '${cfg.useACMEHost}' is not configured.";
      }
    ];

    # Create user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.stateDir;
      createHome = true;
      description = "ocis service user";
      extraGroups = optional (
        cfg.useACMEHost != null
      ) config.security.acme.certs.${cfg.useACMEHost}.group;
    };

    users.groups.${cfg.group} = { };

    # Create necessary directories
    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.configDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    # Setup service that runs once
    systemd.services.ocis-setup = {
      description = "ocis Initial Setup";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ] ++ optional (cfg.useACMEHost != null) "acme-${cfg.useACMEHost}.service";
      wants = optional (cfg.useACMEHost != null) "acme-${cfg.useACMEHost}.service";

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = setupScript;
        RemainAfterExit = true;

        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.stateDir ] ++ optional (cfg.configDir != null) cfg.configDir;
      };
    };

    # Main ocis service
    systemd.services.ocis = {
      description = "ocis Server";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "ocis-setup.service"
      ] ++ optional (cfg.useACMEHost != null) "acme-${cfg.useACMEHost}.service";
      wants = [
        "ocis-setup.service"
      ] ++ optional (cfg.useACMEHost != null) "acme-${cfg.useACMEHost}.service";
      requires = [ "ocis-setup.service" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;

        # Set built-in environment variables directly
        Environment =
          [
            "OCIS_URL=${cfg.url}"
            "PROXY_HTTP_ADDR=${cfg.address}:${toString cfg.port}"
          ]
          ++ optional (cfg.configDir != null) [ "OCIS_CONFIG_DIR=${cfg.configDir}" ]
          ++ optional (cfg.useACMEHost != null) [
            "PROXY_TRANSPORT_TLS_CERT=${config.security.acme.certs.${cfg.useACMEHost}.directory}/fullchain.pem"
            "PROXY_TRANSPORT_TLS_KEY=${config.security.acme.certs.${cfg.useACMEHost}.directory}/key.pem"
          ];

        # Load user-defined environment files
        EnvironmentFile =
          optional (envFile != null) envFile
          ++ optional (cfg.environmentFile != null) cfg.environmentFile;

        ExecStart = "${cfg.package}/bin/ocis server";
        Restart = "always";
        RestartSec = "10s";

        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.stateDir ] ++ optional (cfg.configDir != null) cfg.configDir;

        # Additional hardening
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
      };
    };

  };
  meta.maintainers = with lib.maintainers; [
    bhankas
    danth
    ramblurr
  ];

}
