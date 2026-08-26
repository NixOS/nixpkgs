{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    attrNames
    boolToString
    concatLines
    concatStringsSep
    filterAttrs
    forEach
    getExe
    isBool
    mapAttrs
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    subtractLists
    types
    ;

  cfg = config.services.firezone.server;
  availableAuthAdapters = [
    "email"
    "openid_connect"
    "userpass"
    "token"
    "google_workspace"
    "microsoft_entra"
    "okta"
    "jumpcloud"
  ];

  # All non-secret environment variables or the given component
  collectEnvironment =
    component:
    mapAttrs (_: v: if isBool v then boolToString v else toString v) (
      cfg.settings // cfg.${component}.settings
    );

  # All mandatory secrets which were not explicitly provided by the user will
  # have to be generated, if they do not yet exist.
  generateSecrets =
    let
      requiredSecrets = filterAttrs (_: v: v == null) cfg.settingsSecret;
    in
    ''
      mkdir -p secrets
      chmod 700 secrets
    ''
    + concatLines (
      forEach (attrNames requiredSecrets) (secret: ''
        if [[ ! -e secrets/${secret} ]]; then
          echo "Generating ${secret}"
          # Some secrets like TOKENS_KEY_BASE require a value >=64 bytes.
          head -c 64 /dev/urandom | base64 -w 0 > secrets/${secret}
          chmod 600 secrets/${secret}
        fi
      '')
    );

  # All secrets given in `cfg.settingsSecret` must be loaded from a file and
  # exported into the environment. Also exclude any variables that were
  # overwritten by the local component settings.
  loadSecretEnvironment =
    component:
    let
      relevantSecrets = subtractLists (attrNames cfg.${component}.settings) (
        attrNames cfg.settingsSecret
      );
    in
    concatLines (
      forEach relevantSecrets (
        secret:
        "export ${secret}=$(< ${
          if cfg.settingsSecret.${secret} == null then
            "secrets/${secret}"
          else
            "\"$CREDENTIALS_DIRECTORY/${secret}\""
        })"
      )
    );

  commonServiceConfig = {
    AmbientCapabilities = [ ];
    CapabilityBoundingSet = [ ];
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateUsers = false;
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
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_NETLINK"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = "@system-service";
    UMask = "077";

    DynamicUser = true;
    User = "firezone";

    Slice = "system-firezone.slice";
    StateDirectory = "firezone";
    WorkingDirectory = "/var/lib/firezone";

    LoadCredential = mapAttrsToList (secretName: secretFile: "${secretName}:${secretFile}") (
      filterAttrs (_: v: v != null) cfg.settingsSecret
    );
    Type = "exec";
    Restart = "on-failure";
    RestartSec = 10;
  };

  componentOptions = component: {
    enable = mkEnableOption "the Firezone ${component} server";
    package = mkPackageOption pkgs "firezone-server-${component}" { };

    settings = mkOption {
      description = ''
        Environment variables for this component of the Firezone server. For a
        list of available variables, please refer to the [upstream definitions](https://github.com/firezone/firezone/blob/main/elixir/apps/domain/lib/domain/config/definitions.ex).
        Some variables like `OUTBOUND_EMAIL_ADAPTER_OPTS` require json values
        for which you can use `VAR = builtins.toJSON { /* ... */ }`.

        This component will automatically inherit all variables defined via
        {option}`services.firezone.server.settings` and
        {option}`services.firezone.server.settingsSecret`, but which can be
        overwritten by this option.
      '';
      default = { };
      type = types.submodule {
        freeformType = types.attrsOf (
          types.oneOf [
            types.bool
            types.float
            types.int
            types.str
            types.path
            types.package
          ]
        );
      };
    };
  };
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "firezone" "server" "provision" ] ''
      Firezone provisioning support has been removed due to outsized maintenance efforts. See https://github.com/NixOS/nixpkgs/pull/529428.
    '')
  ];

  options.services.firezone.server = {
    enable = mkEnableOption "all Firezone components";
    enableLocalDB = mkEnableOption "a local postgresql database for Firezone";
    nginx.enable = mkEnableOption "nginx virtualhost definition";

    openClusterFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Opens up the erlang distribution port of all enabled components to
        allow reaching the server cluster from the internet. You only need to
        set this if you are actually distributing your cluster across multiple
        machines.
      '';
    };

    clusterHosts = mkOption {
      type = types.listOf types.str;
      default = [
        "api@localhost.localdomain"
        "web@localhost.localdomain"
        "domain@localhost.localdomain"
      ];
      description = ''
        A list of components and their hosts that are part of this cluster. For
        a single-machine setup, the default value will be sufficient. This
        value will automatically set `ERLANG_CLUSTER_ADAPTER_CONFIG`.

        The format is `<COMPONENT_NAME>@<HOSTNAME>`.
      '';
    };

    settingsSecret = mkOption {
      default = { };
      description = ''
        This is a convenience option which allows you to set secret values for
        environment variables by specifying a file which will contain the value
        at runtime. Before starting the server, the content of each file will
        be loaded into the respective environment variable.

        Otherwise, this option is equivalent to
        {option}`services.firezone.server.settings`. Refer to the settings
        option for more information regarding the actual variables and how
        filtering rules are applied for each component.
      '';
      type = types.submodule {
        freeformType = types.attrsOf types.path;
        options = {
          RELEASE_COOKIE = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              A file containing a unique secret identifier for the Erlang
              cluster. All Firezone components in your cluster must use the
              same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine. You do
              not need to set this except when you spread your cluster over
              multiple hosts.
            '';
          };

          TOKENS_KEY_BASE = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              A file containing a unique base64 encoded secret for the
              `TOKENS_KEY_BASE`. All Firezone components in your cluster must
              use the same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine. You do
              not need to set this except when you spread your cluster over
              multiple hosts.
            '';
          };

          SECRET_KEY_BASE = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              A file containing a unique base64 encoded secret for the
              `SECRET_KEY_BASE`. All Firezone components in your cluster must
              use the same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine. You do
              not need to set this except when you spread your cluster over
              multiple hosts.
            '';
          };

          TOKENS_SALT = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              A file containing a unique base64 encoded secret for the
              `TOKENS_SALT`. All Firezone components in your cluster must
              use the same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine. You do
              not need to set this except when you spread your cluster over
              multiple hosts.
            '';
          };

          LIVE_VIEW_SIGNING_SALT = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              A file containing a unique base64 encoded secret for the
              `LIVE_VIEW_SIGNING_SALT`. All Firezone components in your cluster must
              use the same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine. You do
              not need to set this except when you spread your cluster over
              multiple hosts.
            '';
          };

          COOKIE_SIGNING_SALT = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              A file containing a unique base64 encoded secret for the
              `COOKIE_SIGNING_SALT`. All Firezone components in your cluster must
              use the same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine. You do
              not need to set this except when you spread your cluster over
              multiple hosts.
            '';
          };

          COOKIE_ENCRYPTION_SALT = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              A file containing a unique base64 encoded secret for the
              `COOKIE_ENCRYPTION_SALT`. All Firezone components in your cluster must
              use the same value.

              If this is `null`, a shared value will automatically be generated
              on startup and used for all components on this machine. You do
              not need to set this except when you spread your cluster over
              multiple hosts.
            '';
          };
        };
      };
    };

    settings = mkOption {
      description = ''
        Environment variables for the Firezone server. For a list of available
        variables, please refer to the [upstream definitions](https://github.com/firezone/firezone/blob/main/elixir/apps/domain/lib/domain/config/definitions.ex).
        Some variables like `OUTBOUND_EMAIL_ADAPTER_OPTS` require json values
        for which you can use `VAR = builtins.toJSON { /* ... */ }`.

        Each component has an additional `settings` option which allows you to
        override specific variables passed to that component.
      '';
      default = { };
      type = types.submodule {
        freeformType = types.attrsOf (
          types.oneOf [
            types.bool
            types.float
            types.int
            types.str
            types.path
            types.package
          ]
        );
      };
    };

    smtp = {
      configureManually = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Outbound email configuration is mandatory for Firezone and supports
          many different delivery adapters. Yet, most users will only need an
          SMTP relay to send emails, so this configuration enforced by default.

          If you want to utilize an alternative way to send emails (e.g. via a
          supportd API-based service), enable this option and define
          `OUTBOUND_EMAIL_FROM`, `OUTBOUND_EMAIL_ADAPTER` and
          `OUTBOUND_EMAIL_ADAPTER_OPTS` manually via
          {option}`services.firezone.server.settings` and/or
          {option}`services.firezone.server.settingsSecret`.

          The Firezone documentation holds [a list of supported Swoosh adapters](https://github.com/firezone/firezone/blob/main/website/src/app/docs/reference/env-vars/readme.mdx#outbound-emails).
        '';
      };

      from = mkOption {
        type = types.str;
        example = "firezone@example.com";
        description = "Outbound SMTP FROM address";
      };

      host = mkOption {
        type = types.str;
        example = "mail.example.com";
        description = "Outbound SMTP host";
      };

      port = mkOption {
        type = types.port;
        example = 465;
        description = "Outbound SMTP port";
      };

      implicitTls = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use implicit TLS instead of STARTTLS (usually port 465)";
      };

      username = mkOption {
        type = types.str;
        example = "firezone@example.com";
        description = "Username to authenticate against the SMTP relay";
      };

      passwordFile = mkOption {
        type = types.path;
        example = "/run/secrets/smtp-password";
        description = "File containing the password for the given username. Beware that a file in the nix store will be world readable.";
      };
    };

    domain = componentOptions "domain";

    web = componentOptions "web" // {
      externalUrl = mkOption {
        type = types.strMatching "^https://.+/$";
        example = "https://firezone.example.com/";
        description = ''
          The external URL under which you will serve the web interface. You
          need to setup a reverse proxy for TLS termination, either with
          {option}`services.firezone.server.nginx.enable` or manually.
        '';
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The address to listen on";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "The port under which the web interface will be served locally";
      };

      trustedProxies = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "A list of trusted proxies";
      };
    };

    api = componentOptions "api" // {
      externalUrl = mkOption {
        type = types.strMatching "^https://.+/$";
        example = "https://firezone.example.com/api/";
        description = ''
          The external URL under which you will serve the api. You need to
          setup a reverse proxy for TLS termination, either with
          {option}`services.firezone.server.nginx.enable` or manually.
        '';
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The address to listen on";
      };

      port = mkOption {
        type = types.port;
        default = 8081;
        description = "The port under which the api will be served locally";
      };

      trustedProxies = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "A list of trusted proxies";
      };
    };
  };

  config = mkMerge [
    # Enable all components if the main server is enabled
    (mkIf cfg.enable {
      services.firezone.server.domain.enable = true;
      services.firezone.server.web.enable = true;
      services.firezone.server.api.enable = true;
    })
    # Create (and configure) a local database if desired
    (mkIf cfg.enableLocalDB {
      services.postgresql = {
        enable = true;
        ensureUsers = [
          {
            name = "firezone";
            ensureDBOwnership = true;
            ensureClauses.superuser = true;
          }
        ];
        ensureDatabases = [ "firezone" ];
        # Firezone uses an internal replication strategy
        # that depends on a logical wal
        settings.wal_level = "logical";
      };

      services.firezone.server.settings = {
        DATABASE_SOCKET_DIR = "/run/postgresql";
        DATABASE_PORT = "5432";
        DATABASE_NAME = "firezone";
        DATABASE_USER = "firezone";
        DATABASE_PASSWORD = "firezone";
      };
    })
    # Create a local nginx reverse proxy
    (mkIf cfg.nginx.enable {
      services.nginx = mkMerge [
        {
          enable = true;
        }
        (
          let
            urlComponents = builtins.elemAt (builtins.split "https://([^/]*)(/?.*)" cfg.web.externalUrl) 1;
            domain = builtins.elemAt urlComponents 0;
            location = builtins.elemAt urlComponents 1;
          in
          {
            virtualHosts.${domain} = {
              forceSSL = mkDefault true;
              locations.${location} = {
                # The trailing slash is important to strip the location prefix from the request
                proxyPass = "http://${cfg.web.address}:${toString cfg.web.port}/";
                proxyWebsockets = true;
              };
            };
          }
        )
        (
          let
            urlComponents = builtins.elemAt (builtins.split "https://([^/]*)(/?.*)" cfg.api.externalUrl) 1;
            domain = builtins.elemAt urlComponents 0;
            location = builtins.elemAt urlComponents 1;
          in
          {
            virtualHosts.${domain} = {
              forceSSL = mkDefault true;
              locations.${location} = {
                # The trailing slash is important to strip the location prefix from the request
                proxyPass = "http://${cfg.api.address}:${toString cfg.api.port}/";
                proxyWebsockets = true;
              };
            };
          }
        )
      ];
    })
    # Specify sensible defaults
    {
      services.firezone.server = {
        settings = {
          LOG_LEVEL = mkDefault "info";
          RELEASE_HOSTNAME = mkDefault "localhost.localdomain";

          ERLANG_CLUSTER_ADAPTER = mkDefault "Elixir.Cluster.Strategy.Epmd";
          ERLANG_CLUSTER_ADAPTER_CONFIG = mkDefault (
            builtins.toJSON {
              hosts = cfg.clusterHosts;
            }
          );

          TZDATA_DIR = mkDefault "/var/lib/firezone/tzdata";
          TELEMETRY_ENABLED = mkDefault false;

          # By default this will open nproc * 2 connections for each component,
          # which can exceeds the (default) maximum of 100 connections for
          # postgresql on a 12 core +SMT machine. 16 connections will be
          # sufficient for small to medium deployments
          DATABASE_POOL_SIZE = "16";

          AUTH_PROVIDER_ADAPTERS = mkDefault (concatStringsSep "," availableAuthAdapters);

          FEATURE_FLOW_ACTIVITIES_ENABLED = mkDefault true;
          FEATURE_POLICY_CONDITIONS_ENABLED = mkDefault true;
          FEATURE_MULTI_SITE_RESOURCES_ENABLED = mkDefault true;
          FEATURE_SELF_HOSTED_RELAYS_ENABLED = mkDefault true;
          FEATURE_IDP_SYNC_ENABLED = mkDefault true;
          FEATURE_REST_API_ENABLED = mkDefault true;
          FEATURE_INTERNET_RESOURCE_ENABLED = mkDefault true;
          FEATURE_TRAFFIC_FILTERS_ENABLED = mkDefault true;

          FEATURE_SIGN_UP_ENABLED = mkDefault true;

          WEB_EXTERNAL_URL = mkDefault cfg.web.externalUrl;
          API_EXTERNAL_URL = mkDefault cfg.api.externalUrl;
        };

        domain.settings = {
          ERLANG_DISTRIBUTION_PORT = mkDefault 9000;
          HEALTHZ_PORT = mkDefault 4000;
          BACKGROUND_JOBS_ENABLED = mkDefault true;
        };

        web.settings = {
          ERLANG_DISTRIBUTION_PORT = mkDefault 9001;
          HEALTHZ_PORT = mkDefault 4001;
          BACKGROUND_JOBS_ENABLED = mkDefault false;

          PHOENIX_LISTEN_ADDRESS = mkDefault cfg.web.address;
          PHOENIX_EXTERNAL_TRUSTED_PROXIES = mkDefault (builtins.toJSON cfg.web.trustedProxies);
          PHOENIX_HTTP_WEB_PORT = mkDefault cfg.web.port;
          PHOENIX_HTTP_API_PORT = mkDefault cfg.api.port;
          PHOENIX_SECURE_COOKIES = mkDefault true; # enforce HTTPS on cookies
        };

        api.settings = {
          ERLANG_DISTRIBUTION_PORT = mkDefault 9002;
          HEALTHZ_PORT = mkDefault 4002;
          BACKGROUND_JOBS_ENABLED = mkDefault false;

          PHOENIX_LISTEN_ADDRESS = mkDefault cfg.api.address;
          PHOENIX_EXTERNAL_TRUSTED_PROXIES = mkDefault (builtins.toJSON cfg.api.trustedProxies);
          PHOENIX_HTTP_WEB_PORT = mkDefault cfg.web.port;
          PHOENIX_HTTP_API_PORT = mkDefault cfg.api.port;
          PHOENIX_SECURE_COOKIES = mkDefault true; # enforce HTTPS on cookies
        };
      };
    }
    (mkIf (!cfg.smtp.configureManually) {
      services.firezone.server.settings = {
        OUTBOUND_EMAIL_ADAPTER = "Elixir.Swoosh.Adapters.Mua";
        OUTBOUND_EMAIL_ADAPTER_OPTS = builtins.toJSON { };
        OUTBOUND_EMAIL_FROM = cfg.smtp.from;
        OUTBOUND_EMAIL_SMTP_HOST = cfg.smtp.host;
        OUTBOUND_EMAIL_SMTP_PORT = toString cfg.smtp.port;
        OUTBOUND_EMAIL_SMTP_PROTOCOL = if cfg.smtp.implicitTls then "ssl" else "tcp";
        OUTBOUND_EMAIL_SMTP_USERNAME = cfg.smtp.username;
      };
      services.firezone.server.settingsSecret = {
        OUTBOUND_EMAIL_SMTP_PASSWORD = cfg.smtp.passwordFile;
      };
    })
    (mkIf (cfg.openClusterFirewall && cfg.domain.enable) {
      networking.firewall.allowedTCPPorts = [
        cfg.domain.settings.ERLANG_DISTRIBUTION_PORT
      ];
    })
    (mkIf (cfg.openClusterFirewall && cfg.web.enable) {
      networking.firewall.allowedTCPPorts = [
        cfg.web.settings.ERLANG_DISTRIBUTION_PORT
      ];
    })
    (mkIf (cfg.openClusterFirewall && cfg.api.enable) {
      networking.firewall.allowedTCPPorts = [
        cfg.api.settings.ERLANG_DISTRIBUTION_PORT
      ];
    })
    (mkIf (cfg.domain.enable || cfg.web.enable || cfg.api.enable) {
      systemd.slices.system-firezone = {
        description = "Firezone Slice";
      };

      systemd.targets.firezone = {
        description = "Common target for all Firezone services.";
        wantedBy = [ "multi-user.target" ];
      };

      systemd.services.firezone-initialize = {
        description = "Backend initialization service for the Firezone zero-trust access platform";

        after = mkIf cfg.enableLocalDB [ "postgresql.target" ];
        requires = mkIf cfg.enableLocalDB [ "postgresql.target" ];
        wantedBy = [ "firezone.target" ];
        partOf = [ "firezone.target" ];

        script = ''
          mkdir -p "$TZDATA_DIR"

          # Generate and load secrets
          ${generateSecrets}
          ${loadSecretEnvironment "domain"}

          echo "Running migrations"
          ${getExe cfg.domain.package} eval Domain.Release.migrate
        '';

        # We use the domain environment to be able to run migrations
        environment = collectEnvironment "domain";
        serviceConfig = commonServiceConfig // {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      systemd.services.firezone-server-domain = mkIf cfg.domain.enable {
        description = "Backend domain server for the Firezone zero-trust access platform";
        after = [ "firezone-initialize.service" ];
        bindsTo = [ "firezone-initialize.service" ];
        wantedBy = [ "firezone.target" ];
        partOf = [ "firezone.target" ];

        script = ''
          ${loadSecretEnvironment "domain"}
          exec ${getExe cfg.domain.package} start;
        '';

        path = [ pkgs.curl ];
        postStart = ''
          # Wait for the firezone server to come online
          count=0
          while [[ "$(curl -s "http://localhost:${toString cfg.domain.settings.HEALTHZ_PORT}" 2>/dev/null || echo)" != '{"status":"ok"}' ]]
          do
            sleep 1
            if [[ "$count" -eq 30 ]]; then
              echo "Tried for at least 30 seconds, giving up..."
              exit 1
            fi
            count=$((count++))
          done
        '';

        environment = collectEnvironment "domain";
        serviceConfig = commonServiceConfig;
      };

      systemd.services.firezone-server-web = mkIf cfg.web.enable {
        description = "Backend web server for the Firezone zero-trust access platform";
        after = [ "firezone-initialize.service" ];
        bindsTo = [ "firezone-initialize.service" ];
        wantedBy = [ "firezone.target" ];
        partOf = [ "firezone.target" ];

        script = ''
          ${loadSecretEnvironment "web"}
          exec ${getExe cfg.web.package} start;
        '';

        environment = collectEnvironment "web";
        serviceConfig = commonServiceConfig;
      };

      systemd.services.firezone-server-api = mkIf cfg.api.enable {
        description = "Backend api server for the Firezone zero-trust access platform";
        after = [ "firezone-initialize.service" ];
        bindsTo = [ "firezone-initialize.service" ];
        wantedBy = [ "firezone.target" ];
        partOf = [ "firezone.target" ];

        script = ''
          ${loadSecretEnvironment "api"}
          exec ${getExe cfg.api.package} start;
        '';

        environment = collectEnvironment "api";
        serviceConfig = commonServiceConfig;
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [
    oddlama
    patrickdag
  ];
}
