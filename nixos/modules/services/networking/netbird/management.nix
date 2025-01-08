{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib.types)
    bool
    enum
    listOf
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
          URI = "turn:${cfg.turnDomain}:${builtins.toString cfg.turnPort}";
          Username = "netbird";
          Password = "netbird";
        }
      ];

      CredentialsTTL = "12h";
      Secret = "not-secure-secret";
      TimeBasedCredentials = false;
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
      Engine = "sqlite";
    };

    HttpConfig = {
      Address = "127.0.0.1:${builtins.toString cfg.port}";
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

  managementConfig = lib.recursiveUpdate defaultSettings cfg.settings;

  managementFile = settingsFormat.generate "config.json" managementConfig;

  cfg = config.services.netbird.server.management;
in

{
  options.services.netbird.server.management = {
    enable = lib.mkEnableOption "Netbird Management Service";

    package = lib.mkPackageOption pkgs "netbird" { };

    domain = lib.mkOption {
      type = str;
      description = "The domain under which the management API runs.";
    };

    turnDomain = lib.mkOption {
      type = str;
      description = "The domain of the TURN server to use.";
    };

    turnPort = lib.mkOption {
      type = port;
      default = 3478;
      description = ''
        The port of the TURN server to use.
      '';
    };

    dnsDomain = lib.mkOption {
      type = str;
      default = "netbird.selfhosted";
      description = "Domain used for peer resolution.";
    };

    singleAccountModeDomain = lib.mkOption {
      type = str;
      default = "netbird.selfhosted";
      description = ''
        Enables single account mode.
        This means that all the users will be under the same account grouped by the specified domain.
        If the installation has more than one account, the property is ineffective.
      '';
    };

    disableAnonymousMetrics = lib.mkOption {
      type = bool;
      default = true;
      description = "Disables push of anonymous usage metrics to NetBird.";
    };

    disableSingleAccountMode = lib.mkOption {
      type = bool;
      default = false;
      description = ''
        If set to true, disables single account mode.
        The `singleAccountModeDomain` property will be ignored and every new user will have a separate NetBird account.
      '';
    };

    port = lib.mkOption {
      type = port;
      default = 8011;
      description = "Internal port of the management server.";
    };

    metricsPort = lib.mkOption {
      type = port;
      default = 9090;
      description = "Internal port of the metrics server.";
    };

    extraOptions = lib.mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Additional options given to netbird-mgmt as commandline arguments.
      '';
    };

    oidcConfigEndpoint = lib.mkOption {
      type = str;
      description = "The oidc discovery endpoint.";
      example = "https://example.eu.auth0.com/.well-known/openid-configuration";
    };

    settings = lib.mkOption {
      inherit (settingsFormat) type;

      defaultText = lib.literalExpression ''
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
          DataStoreEncryptionKey = "genEVP6j/Yp2EeVujm0zgqXrRos29dQkpvX0hHdEUlQ=";
          StoreConfig = { Engine = "sqlite"; };

          HttpConfig = {
            Address = "127.0.0.1:''${builtins.toString cfg.port}";
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
              Scope = "openid profile email offline_access api";
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
              Scope = "openid profile email offline_access api";
              RedirectURLs = "http://localhost:53000";
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

    logLevel = lib.mkOption {
      type = enum [
        "ERROR"
        "WARN"
        "INFO"
        "DEBUG"
      ];
      default = "INFO";
      description = "Log level of the netbird services.";
    };

    enableNginx = lib.mkEnableOption "Nginx reverse-proxy for the netbird management service";
  };

  config = lib.mkIf cfg.enable {
    warnings =
      lib.concatMap
        (
          { check, name }:
          lib.optional check "${name} is world-readable in the Nix Store, you should provide it as a _secret."
        )
        [
          {
            check = builtins.isString managementConfig.TURNConfig.Secret;
            name = "The TURNConfig.secret";
          }
          {
            check = builtins.isString managementConfig.DataStoreEncryptionKey;
            name = "The DataStoreEncryptionKey";
          }
          {
            check = lib.any (T: (T ? Password) && builtins.isString T.Password) managementConfig.TURNConfig.Turns;
            name = "A Turn configuration's password";
          }
        ];

    assertions = [
      {
        assertion = cfg.port != cfg.metricsPort;
        message = "The primary listen port cannot be the same as the listen port for the metrics endpoint";
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
            (lib.getExe' cfg.package "netbird-mgmt")
            "management"
            # Config file
            "--config"
            "${stateDir}/management.json"
            # Data directory
            "--datadir"
            "${stateDir}/data"
            # DNS domain
            "--dns-domain"
            cfg.dnsDomain
            # Port to listen on
            "--port"
            cfg.port
            # Port the internal prometheus server listens on
            "--metrics-port"
            cfg.metricsPort
            # Log to stdout
            "--log-file"
            "console"
            # Log level
            "--log-level"
            cfg.logLevel
            #
            "--idp-sign-key-refresh-enabled"
            # Domain for internal resolution
            "--single-account-mode-domain"
            cfg.singleAccountModeDomain
          ]
          ++ (lib.optional cfg.disableAnonymousMetrics "--disable-anonymous-metrics")
          ++ (lib.optional cfg.disableSingleAccountMode "--disable-single-account-mode")
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
        ProtectSystem = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };

      stopIfChanged = false;
    };

    services.nginx = lib.mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        locations = {
          "/api".proxyPass = "http://localhost:${builtins.toString cfg.port}";

          "/management.ManagementService/".extraConfig = ''
            # This is necessary so that grpc connections do not get closed early
            # see https://stackoverflow.com/a/67805465
            client_body_timeout 1d;

            grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            grpc_pass grpc://localhost:${builtins.toString cfg.port};
            grpc_read_timeout 1d;
            grpc_send_timeout 1d;
            grpc_socket_keepalive on;
          '';
        };
      };
    };
  };
}
