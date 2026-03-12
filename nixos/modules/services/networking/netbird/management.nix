{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    any
    concatMap
    getExe'
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionals
    optionalAttrs
    recursiveUpdate
    ;

  inherit (lib.types)
    bool
    enum
    listOf
    nullOr
    path
    port
    str
    ;

  inherit (utils) escapeSystemdExecArgs genJqSecretsReplacementSnippet;

  stateDir = "/var/lib/netbird-mgmt";

  settingsFormat = pkgs.formats.json { };

  defaultSettings = {
    Stuns = [
      {
        Proto = "udp";
        URI = "stun:${cfg.turnDomain}:3478";
        Username = "";
        Password = null;
      }
    ];

    TURNConfig = {
      Turns = [
        {
          Proto = "udp";
          URI = "turn:${cfg.turnDomain}:${toString cfg.turnPort}";
          Username = "netbird";
          Password = "netbird";
        }
      ];

      CredentialsTTL = "12h";
      Secret = "not-secure-secret";
      TimeBasedCredentials = false;
    };

    Relay = {
      Addresses = cfg.relayAddresses;
      CredentialsTTL = "24h";
      Secret = if cfg.relaySecretFile != null then { _secret = cfg.relaySecretFile; } else "";
    };

    Signal = {
      Proto = "https";
      URI = "${cfg.domain}:443";
      Username = "";
      Password = null;
    };

    ReverseProxy = {
      TrustedHTTPProxies = [ ];
      TrustedHTTPProxiesCount = 0;
      TrustedPeers = [ "0.0.0.0/0" ];
    };

    Datadir = "${stateDir}/data";
    DataStoreEncryptionKey = "very-insecure-key";
    StoreConfig = {
      Engine = cfg.store.engine;
    }
    // optionalAttrs (cfg.store.engine == "postgres" && cfg.store.postgres.dsnFile != null) {
      DataSourcePath = {
        _secret = cfg.store.postgres.dsnFile;
      };
    }
    // optionalAttrs (cfg.store.engine == "mysql" && cfg.store.mysql.dsnFile != null) {
      DataSourcePath = {
        _secret = cfg.store.mysql.dsnFile;
      };
    };

    HttpConfig = {
      Address = "127.0.0.1:${toString cfg.port}";
      IdpSignKeyRefreshEnabled = true;
      OIDCConfigEndpoint = cfg.oidcConfigEndpoint;
    };

    IdpManagerConfig =
      if cfg.idp.embedded.enable then
        {
          ManagerType = "integrated";
          ClientConfig = {
            Issuer = "https://${cfg.domain}/oauth2";
            TokenEndpoint = "";
            ClientID = "netbird";
            ClientSecret = "";
            GrantType = "client_credentials";
          };
          ExtraConfig = { };
          Auth0ClientCredentials = null;
          AzureClientCredentials = null;
          KeycloakClientCredentials = null;
          ZitadelClientCredentials = null;
        }
      else
        {
          ManagerType = "none";
          ClientConfig = {
            Issuer = "";
            TokenEndpoint = "";
            ClientID = "netbird";
            ClientSecret = "";
            GrantType = "client_credentials";
          };
          ExtraConfig = { };
          Auth0ClientCredentials = null;
          AzureClientCredentials = null;
          KeycloakClientCredentials = null;
          ZitadelClientCredentials = null;
        };

    DeviceAuthorizationFlow = {
      Provider = "none";
      ProviderConfig = {
        Audience = "netbird";
        Domain = null;
        ClientID = "netbird";
        TokenEndpoint = null;
        DeviceAuthEndpoint = "";
        Scope = "openid profile email";
        UseIDToken = false;
      };
    };

    PKCEAuthorizationFlow = {
      ProviderConfig = {
        Audience = "netbird";
        ClientID = "netbird";
        ClientSecret = "";
        AuthorizationEndpoint = "";
        TokenEndpoint = "";
        Scope = "openid profile email";
        RedirectURLs = [ "http://localhost:53000" ];
        UseIDToken = false;
      };
    };
  }
  // optionalAttrs cfg.idp.embedded.enable {
    ProviderConfig = {
      Issuer = "https://${cfg.domain}/oauth2";
      Storage = {
        Type = "sqlite3";
        File = "${stateDir}/idp.db";
      };
      DashboardRedirectURIs = [
        "https://${cfg.domain}/nb-auth"
        "https://${cfg.domain}/nb-silent-auth"
      ];
      CLIRedirectURIs = [
        "http://localhost:53000/"
        "http://localhost:54000/"
      ];
      Owner = {
        Email = "";
        Password = "";
        Username = "";
      };
    };
  };

  managementConfig = recursiveUpdate defaultSettings cfg.settings;

  managementFile = settingsFormat.generate "config.json" managementConfig;

  cfg = config.services.netbird.server.management;
in

{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "services"
        "netbird"
        "server"
        "management"
        "singleAccountModeDomain"
      ]
      [
        "services"
        "netbird"
        "server"
        "management"
        "singleAccountMode"
        "domain"
      ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "netbird"
      "server"
      "management"
      "disableSingleAccountMode"
    ] "Use services.netbird.server.management.singleAccountMode.enable = false instead.")
  ];

  options.services.netbird.server.management = {
    enable = mkEnableOption "Netbird Management Service";

    package = mkPackageOption pkgs "netbird-management" { };

    domain = mkOption {
      type = str;
      description = "The domain under which the management API runs.";
    };

    turnDomain = mkOption {
      type = str;
      description = "The domain of the TURN server to use.";
    };

    turnPort = mkOption {
      type = port;
      default = 3478;
      description = ''
        The port of the TURN server to use.
      '';
    };

    dnsDomain = mkOption {
      type = str;
      default = "netbird.selfhosted";
      description = "Domain used for peer resolution.";
    };

    singleAccountMode = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Enable single account mode where all users are grouped under a single account.
          If the installation already has more than one account, this setting is ineffective.
        '';
      };

      domain = mkOption {
        type = str;
        default = "netbird.selfhosted";
        description = ''
          Domain used to group users in single account mode.
          Only used when `singleAccountMode.enable` is true.
        '';
      };
    };

    disableAnonymousMetrics = mkOption {
      type = bool;
      default = true;
      description = "Disables push of anonymous usage metrics to NetBird.";
    };

    port = mkOption {
      type = port;
      default = 8011;
      description = "Internal port of the management server.";
    };

    metricsPort = mkOption {
      type = port;
      default = 9090;
      description = "Internal port of the metrics server.";
    };

    extraOptions = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Additional options given to netbird-mgmt as commandline arguments.
      '';
    };

    oidcConfigEndpoint = mkOption {
      type = str;
      default = "";
      description = "The oidc discovery endpoint. Not required when using embedded IDP.";
      example = "https://example.eu.auth0.com/.well-known/openid-configuration";
    };

    # Relay configuration
    relayAddresses = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        List of relay server addresses to advertise to clients.
      '';
      example = [ "rels://relay.example.com:443" ];
    };

    relaySecretFile = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        Path to file containing the shared secret for relay authentication.
        This must match the auth-secret configured on the relay server.
      '';
    };

    # TLS configuration
    tls = {
      enable = mkEnableOption "TLS for the management server";

      letsencrypt = {
        domain = mkOption {
          type = nullOr str;
          default = null;
          description = ''
            Domain for automatic Let's Encrypt certificate.
            When set, the management server will automatically obtain and renew certificates.
          '';
        };
      };

      certFile = mkOption {
        type = nullOr path;
        default = null;
        description = "Path to the TLS certificate file.";
      };

      certKey = mkOption {
        type = nullOr path;
        default = null;
        description = "Path to the TLS certificate key file.";
      };
    };

    # Embedded IDP
    idp.embedded.enable = mkEnableOption ''
      the embedded identity provider.
      When enabled, sets IdpManagerConfig.ManagerType to "integrated" and provides
      default ProviderConfig values derived from the domain.
      Customize the embedded IDP via the `settings` freeform option
      (e.g. `settings.ProviderConfig.Owner.Email = "admin@example.com"`)
    '';

    # Database backend configuration
    store = {
      engine = mkOption {
        type = enum [
          "sqlite"
          "postgres"
          "mysql"
        ];
        default = "sqlite";
        description = ''
          Database engine for the management server.
          Use postgres or mysql for larger deployments.
        '';
      };

      postgres = {
        dsnFile = mkOption {
          type = nullOr path;
          default = null;
          description = ''
            Path to file containing the PostgreSQL connection DSN.
            Example content: postgres://user:password@localhost:5432/netbird?sslmode=disable
          '';
        };
      };

      mysql = {
        dsnFile = mkOption {
          type = nullOr path;
          default = null;
          description = ''
            Path to file containing the MySQL connection DSN.
            Example content: user:password@tcp(localhost:3306)/netbird
          '';
        };
      };
    };

    settings = mkOption {
      inherit (settingsFormat) type;

      defaultText = literalExpression ''
        defaultSettings = {
          Stuns = [
            {
              Proto = "udp";
              URI = "stun:''${cfg.turnDomain}:3478";
              Username = "";
              Password = null;
            }
          ];

          TURNConfig = {
            Turns = [
              {
                Proto = "udp";
                URI = "turn:''${cfg.turnDomain}:3478";
                Username = "netbird";
                Password = "netbird";
              }
            ];

            CredentialsTTL = "12h";
            Secret = "not-secure-secret";
            TimeBasedCredentials = false;
          };

          Relay = {
            Addresses = cfg.relayAddresses;
            CredentialsTTL = "24h";
            Secret = "";
          };

          Signal = {
            Proto = "https";
            URI = "''${cfg.domain}:443";
            Username = "";
            Password = null;
          };

          ReverseProxy = {
            TrustedHTTPProxies = [ ];
            TrustedHTTPProxiesCount = 0;
            TrustedPeers = [ "0.0.0.0/0" ];
          };

          Datadir = "''${stateDir}/data";
          DataStoreEncryptionKey = "very-insecure-key";
          StoreConfig = { Engine = "sqlite"; };

          HttpConfig = {
            Address = "127.0.0.1:''${toString cfg.port}";
            IdpSignKeyRefreshEnabled = true;
            OIDCConfigEndpoint = cfg.oidcConfigEndpoint;
          };

          IdpManagerConfig = {
            ManagerType = "none";
            ClientConfig = {
              Issuer = "";
              TokenEndpoint = "";
              ClientID = "netbird";
              ClientSecret = "";
              GrantType = "client_credentials";
            };

            ExtraConfig = { };
            Auth0ClientCredentials = null;
            AzureClientCredentials = null;
            KeycloakClientCredentials = null;
            ZitadelClientCredentials = null;
          };

          DeviceAuthorizationFlow = {
            Provider = "none";
            ProviderConfig = {
              Audience = "netbird";
              Domain = null;
              ClientID = "netbird";
              TokenEndpoint = null;
              DeviceAuthEndpoint = "";
              Scope = "openid profile email";
              UseIDToken = false;
            };
          };

          PKCEAuthorizationFlow = {
            ProviderConfig = {
              Audience = "netbird";
              ClientID = "netbird";
              ClientSecret = "";
              AuthorizationEndpoint = "";
              TokenEndpoint = "";
              Scope = "openid profile email";
              RedirectURLs = [ "http://localhost:53000" ];
              UseIDToken = false;
            };
          };
        };
      '';

      default = { };

      description = ''
        Configuration of the netbird management server.
        Options containing secret data should be set to an attribute set containing the attribute _secret
        - a string pointing to a file containing the value the option should be set to.
        See the example to get a better picture of this: in the resulting management.json file,
        the `DataStoreEncryptionKey` key will be set to the contents of the /run/agenix/netbird_mgmt-data_store_encryption_key file.
      '';

      example = {
        DataStoreEncryptionKey = {
          _secret = "/run/agenix/netbird_mgmt-data_store_encryption_key";
        };
      };
    };

    logLevel = mkOption {
      type = enum [
        "ERROR"
        "WARN"
        "INFO"
        "DEBUG"
      ];
      default = "INFO";
      description = "Log level of the netbird services.";
    };

    enableNginx = mkEnableOption "Nginx reverse-proxy for the netbird management service";
  };

  config = mkIf cfg.enable {
    warnings =
      concatMap
        (
          { check, name }:
          optional check "${name} is world-readable in the Nix Store, you should provide it as a _secret."
        )
        [
          {
            check = builtins.isString managementConfig.TURNConfig.Secret;
            name = "The TURNConfig.Secret";
          }
          {
            check = builtins.isString managementConfig.DataStoreEncryptionKey;
            name = "The DataStoreEncryptionKey";
          }
          {
            check = any (T: (T ? Password) && builtins.isString T.Password) managementConfig.TURNConfig.Turns;
            name = "A TURNConfig.Turns password";
          }
          {
            check =
              cfg.relayAddresses != [ ]
              && managementConfig ? Relay
              && builtins.isString (managementConfig.Relay.Secret or "");
            name = "The Relay.Secret";
          }
        ];

    assertions = [
      {
        assertion = cfg.port != cfg.metricsPort;
        message = "The primary listen port cannot be the same as the listen port for the metrics endpoint";
      }
      {
        assertion =
          cfg.tls.enable
          -> (cfg.tls.letsencrypt.domain != null || (cfg.tls.certFile != null && cfg.tls.certKey != null));
        message = "When TLS is enabled, either letsencrypt.domain or both certFile and certKey must be set";
      }
      {
        assertion = cfg.tls.certFile != null -> cfg.tls.certKey != null;
        message = "certKey must be set when certFile is set";
      }
      {
        assertion = cfg.tls.certKey != null -> cfg.tls.certFile != null;
        message = "certFile must be set when certKey is set";
      }
      {
        assertion = cfg.store.engine == "postgres" -> cfg.store.postgres.dsnFile != null;
        message = "store.postgres.dsnFile must be set when using postgres engine";
      }
      {
        assertion = cfg.store.engine == "mysql" -> cfg.store.mysql.dsnFile != null;
        message = "store.mysql.dsnFile must be set when using mysql engine";
      }
      {
        assertion = !cfg.idp.embedded.enable || cfg.oidcConfigEndpoint == "";
        message = "oidcConfigEndpoint should not be set when using embedded IDP";
      }
    ];

    systemd.services.netbird-management = {
      description = "The management server for Netbird, a wireguard VPN";
      documentation = [ "https://netbird.io/docs/" ];

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ managementFile ];

      preStart = genJqSecretsReplacementSnippet managementConfig "${stateDir}/management.json";

      serviceConfig = {
        ExecStart = escapeSystemdExecArgs (
          [
            (getExe' cfg.package "netbird-mgmt")
            "management"
            "--config"
            "${stateDir}/management.json"
            "--datadir"
            "${stateDir}/data"
            "--dns-domain"
            cfg.dnsDomain
            "--port"
            cfg.port
            "--metrics-port"
            cfg.metricsPort
            "--log-file"
            "console"
            "--log-level"
            cfg.logLevel
            "--idp-sign-key-refresh-enabled"
          ]
          # Single account mode
          ++ optionals cfg.singleAccountMode.enable [
            "--single-account-mode-domain"
            cfg.singleAccountMode.domain
          ]
          ++ (optional (!cfg.singleAccountMode.enable) "--disable-single-account-mode")
          ++ (optional cfg.disableAnonymousMetrics "--disable-anonymous-metrics")
          # Always disable GeoLite updates for self-hosted (privacy default)
          ++ [ "--disable-geolite-update" ]
          # TLS options
          ++ optionals (cfg.tls.letsencrypt.domain != null) [
            "--letsencrypt-domain"
            cfg.tls.letsencrypt.domain
          ]
          ++ optionals (cfg.tls.certFile != null) [
            "--cert-file"
            cfg.tls.certFile
          ]
          ++ optionals (cfg.tls.certKey != null) [
            "--cert-key"
            cfg.tls.certKey
          ]
          ++ cfg.extraOptions
        );
        Restart = "always";
        RuntimeDirectory = "netbird-mgmt";
        StateDirectory = [
          "netbird-mgmt"
          "netbird-mgmt/data"
        ];
        StateDirectoryMode = "0750";
        RuntimeDirectoryMode = "0750";
        WorkingDirectory = stateDir;

        # hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };

      stopIfChanged = false;
    };

    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        locations = {
          "/api".proxyPass = "http://localhost:${toString cfg.port}";

          "/management.ManagementService/".extraConfig = ''
            # This is necessary so that grpc connections do not get closed early
            # see https://stackoverflow.com/a/67805465
            client_body_timeout 1d;

            grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            grpc_pass grpc://localhost:${toString cfg.port};
            grpc_read_timeout 1d;
            grpc_send_timeout 1d;
            grpc_socket_keepalive on;
          '';
        };
      };
    };
  };
}
