{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    filterAttrs
    literalExpression
    maintainers
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optionalAttrs
    optionalString
    optionals
    types
    ;

  cfg = config.services.netbird-server;

  stateDir = "/var/lib/netbird-mgmt";

  settingsFormat = pkgs.formats.keyValue { };
  managementFormat = pkgs.formats.json { };

  settingsFile = settingsFormat.generate "setup.env" (
    builtins.mapAttrs
      (_: val: if builtins.isList val then ''"${builtins.concatStringsSep " " val}"'' else val)
      settings
  );

  managementFile = managementFormat.generate "config.json" cfg.managementConfig;

  settings =
    rec {
      TURN_DOMAIN = cfg.settings.NETBIRD_DOMAIN;
      TURN_PORT = 3478;
      TURN_USER = "netbird";
      TURN_MIN_PORT = 49152;
      TURN_MAX_PORT = 65535;
      TURN_PASSWORD = if cfg.secretFiles.TURN_PASSWORD != null then "$TURN_PASSWORD" else null;
      TURN_SECRET = if cfg.secretFiles.TURN_SECRET != null then "$TURN_SECRET" else "secret";

      STUN_USERNAME = "";
      STUN_PASSWORD = if cfg.secretFiles.STUN_PASSWORD != null then "$STUN_PASSWORD" else null;

      NETBIRD_DASHBOARD_ENDPOINT = "https://${cfg.settings.NETBIRD_DOMAIN}:443";
      NETBIRD_MGMT_API_ENDPOINT = "https://${cfg.settings.NETBIRD_DOMAIN}:${
        builtins.toString cfg.settings.NETBIRD_MGMT_API_PORT or NETBIRD_MGMT_API_PORT
      }";
      NETBIRD_SIGNAL_ENDPOINT = "https://${cfg.settings.NETBIRD_DOMAIN}:${
        builtins.toString cfg.settings.NETBIRD_SIGNAL_PORT or NETBIRD_SIGNAL_PORT
      }";

      NETBIRD_SIGNAL_PROTOCOL = "https";
      NETBIRD_SIGNAL_PORT = 443;

      NETBIRD_AUTH_USER_ID_CLAIM = "sub";
      NETBIRD_AUTH_CLIENT_SECRET =
        if cfg.secretFiles.AUTH_CLIENT_SECRET != null then "$AUTH_CLIENT_SECRET" else "";
      NETBIRD_AUTH_SUPPORTED_SCOPES = [
        "openid"
        "profile"
        "email"
        "offline_access"
        "api"
      ];

      NETBIRD_AUTH_REDIRECT_URI = "";
      NETBIRD_AUTH_SILENT_REDIRECT_URI = "";

      NETBIRD_AUTH_DEVICE_AUTH_PROVIDER = "none";
      NETBIRD_AUTH_DEVICE_AUTH_CLIENT_ID = cfg.settings.NETBIRD_AUTH_CLIENT_ID;
      NETBIRD_AUTH_DEVICE_AUTH_AUDIENCE = cfg.settings.NETBIRD_AUTH_AUDIENCE;
      NETBIRD_AUTH_DEVICE_AUTH_SCOPE = [
        "openid"
        "profile"
        "email"
        "offline_access"
        "api"
      ];
      NETBIRD_AUTH_DEVICE_AUTH_USE_ID_TOKEN = false;

      NETBIRD_MGMT_API_PORT = 443;

      NETBIRD_MGMT_IDP = "none";
      NETBIRD_IDP_MGMT_CLIENT_ID = cfg.settings.NETBIRD_AUTH_CLIENT_ID;
      NETBIRD_IDP_MGMT_CLIENT_SECRET =
        if cfg.secretFiles.IDP_MGMT_CLIENT_SECRET != null then
          "$IDP_MGMT_CLIENT_SECRET"
        else
          cfg.settings.NETBIRD_AUTH_CLIENT_SECRET;
      NETBIRD_IDP_MGMT_GRANT_TYPE = "client_credentials";

      NETBIRD_TOKEN_SOURCE = "accessToken";
      NETBIRD_DRAG_QUERY_PARAMS = false;

      NETBIRD_USE_AUTH0 = false;

      NETBIRD_AUTH_DEVICE_AUTH_ENDPOINT = "";

      NETBIRD_AUTH_PKCE_REDIRECT_URL_PORTS = [ "53000" ];
      NETBIRD_AUTH_PKCE_REDIRECT_URLS =
        builtins.map (p: "http://localhost:${p}")
          cfg.settings.NETBIRD_AUTH_PKCE_REDIRECT_URL_PORTS or NETBIRD_AUTH_PKCE_REDIRECT_URL_PORTS;
    }
    // (optionalAttrs cfg.setupAutoOidc {
      NETBIRD_AUTH_PKCE_AUTHORIZATION_ENDPOINT = "$NETBIRD_AUTH_PKCE_AUTHORIZATION_ENDPOINT";
      NETBIRD_AUTH_DEVICE_AUTH_ENDPOINT = "$NETBIRD_AUTH_DEVICE_AUTH_ENDPOINT";
      NETBIRD_AUTH_TOKEN_ENDPOINT = "$NETBIRD_AUTH_TOKEN_ENDPOINT";
      NETBIRD_AUTH_JWT_CERTS = "$NETBIRD_AUTH_JWT_CERTS";
      NETBIRD_AUTH_AUTHORITY = "$NETBIRD_AUTH_AUTHORITY";
    })
    // cfg.settings;
in
{
  meta = {
    maintainers = with maintainers; [ thubrecht ];
    doc = ./netbird-server.md;
  };

  options.services.netbird-server = {
    enable = mkEnableOption (lib.mdDoc "netbird management service.");

    package = mkOption {
      type = types.package;
      default = pkgs.netbird;
      defaultText = literalExpression "pkgs.netbird";
      description = lib.mdDoc "The package to use for netbird";
    };

    dashboard = mkPackageOption pkgs "netbird-dashboard" { };

    settings = mkOption {
      type =
        with types;
        attrsOf (
          nullOr (
            oneOf [
              (listOf str)
              bool
              int
              float
              str
            ]
          )
        );
      defaultText = lib.literalExpression ''
        {
          TURN_DOMAIN = cfg.settings.NETBIRD_DOMAIN;
          TURN_PORT = 3478;
          TURN_USER = "netbird";
          TURN_MIN_PORT = 49152;
          TURN_MAX_PORT = 65535;
          TURN_PASSWORD = if cfg.secretFiles.TURN_PASSWORD != null then "$TURN_PASSWORD" else null;
          TURN_SECRET = if cfg.secretFiles.TURN_SECRET != null then "$TURN_SECRET" else "secret";

          STUN_USERNAME = "";
          STUN_PASSWORD = if cfg.secretFiles.STUN_PASSWORD != null then "$STUN_PASSWORD" else null;

          NETBIRD_DASHBOARD_ENDPOINT = "https://''${cfg.settings.NETBIRD_DOMAIN}:443";
          NETBIRD_MGMT_API_ENDPOINT = "https://''${cfg.settings.NETBIRD_DOMAIN}:''${builtins.toString cfg.settings.NETBIRD_MGMT_API_PORT or NETBIRD_MGMT_API_PORT}";
          NETBIRD_SIGNAL_ENDPOINT = "https://''${cfg.settings.NETBIRD_DOMAIN}:''${builtins.toString cfg.settings.NETBIRD_SIGNAL_PORT or NETBIRD_SIGNAL_PORT}";

          NETBIRD_SIGNAL_PROTOCOL = "https";
          NETBIRD_SIGNAL_PORT = 443;

          NETBIRD_AUTH_USER_ID_CLAIM = "sub";
          NETBIRD_AUTH_CLIENT_SECRET = if cfg.secretFiles.AUTH_CLIENT_SECRET != null then "$AUTH_CLIENT_SECRET" else "";
          NETBIRD_AUTH_SUPPORTED_SCOPES = [ "openid" "profile" "email" "offline_access" "api" ];

          NETBIRD_AUTH_REDIRECT_URI = "";
          NETBIRD_AUTH_SILENT_REDIRECT_URI = "";

          NETBIRD_AUTH_DEVICE_AUTH_PROVIDER = "none";
          NETBIRD_AUTH_DEVICE_AUTH_CLIENT_ID = cfg.settings.NETBIRD_AUTH_CLIENT_ID;
          NETBIRD_AUTH_DEVICE_AUTH_AUDIENCE = cfg.settings.NETBIRD_AUTH_AUDIENCE;
          NETBIRD_AUTH_DEVICE_AUTH_SCOPE = [ "openid" "profile" "email" "offline_access" "api" ];
          NETBIRD_AUTH_DEVICE_AUTH_USE_ID_TOKEN = false;

          NETBIRD_MGMT_API_PORT = 443;

          NETBIRD_MGMT_IDP = "none";
          NETBIRD_IDP_MGMT_CLIENT_ID = cfg.settings.NETBIRD_AUTH_CLIENT_ID;
          NETBIRD_IDP_MGMT_CLIENT_SECRET = if cfg.secretFiles.IDP_MGMT_CLIENT_SECRET != null then "$IDP_MGMT_CLIENT_SECRET" else cfg.settings.NETBIRD_AUTH_CLIENT_SECRET;
          NETBIRD_IDP_MGMT_GRANT_TYPE = "client_credentials";

          NETBIRD_TOKEN_SOURCE = "accessToken";
          NETBIRD_DRAG_QUERY_PARAMS = false;

          NETBIRD_USE_AUTH0 = false;

          NETBIRD_AUTH_DEVICE_AUTH_ENDPOINT = "";

          NETBIRD_AUTH_PKCE_REDIRECT_URL_PORTS = [ "53000" ];
          NETBIRD_AUTH_PKCE_REDIRECT_URLS = builtins.map (p: "http://localhost:''${p}") cfg.settings.NETBIRD_AUTH_PKCE_REDIRECT_URL_PORTS or NETBIRD_AUTH_PKCE_REDIRECT_URL_PORTS;
        }
      '';
      description = lib.mdDoc ''
        Configuration settings for netbird.
        Example config values can be found in [setup.env.example](https://github.com/netbirdio/netbird/blob/main/infrastructure_files/setup.env.example)
        List of strings [ a b ] will be concatenated as "a b", useful for setting the supported scopes.
      '';
    };

    managementConfig = mkOption {
      inherit (managementFormat) type;
      description = lib.mdDoc "Configuration of the netbird management server.";
    };

    idpManagerExtraConfig = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = lib.mdDoc "Extra options passed to the IdpManagerConfig.";
    };

    ports.management = mkOption {
      type = types.port;
      default = 8011;
      description = lib.mdDoc "Internal port of the management server.";
    };

    ports.signal = mkOption {
      type = types.port;
      default = 8012;
      description = lib.mdDoc "Internal port of the signal server.";
    };

    logLevel = mkOption {
      type = types.enum [
        "ERROR"
        "WARN"
        "INFO"
        "DEBUG"
      ];
      default = "INFO";
      description = lib.mdDoc "Log level of the netbird services.";
    };

    enableDeviceAuthorizationFlow = mkEnableOption "device authorization flow for netbird." // {
      default = true;
    };

    enableNginx = mkEnableOption "NGINX reverse-proxy for the netbird server.";

    enableCoturn = mkEnableOption "a Coturn server used for Netbird.";

    setupAutoOidc = mkEnableOption "the automatic setup of the OIDC.";

    management = {
      dnsDomain = mkOption {
        type = types.str;
        default = "netbird.selfhosted";
        description = lib.mdDoc "Domain used for peer resolution.";
      };

      singleAccountModeDomain = mkOption {
        type = types.str;
        default = "netbird.selfhosted";
        description = lib.mdDoc ''
          Enables single account mode.
          This means that all the users will be under the same account grouped by the specified domain.
          If the installation has more than one account, the property is ineffective.
        '';
      };

      disableAnonymousMetrics = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Disables push of anonymous usage metrics to NetBird.";
      };

      disableSingleAccountMode = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If set to true, disables single account mode.
          The `singleAccountModeDomain` property will be ignored and every new user will have a separate NetBird account.
        '';
      };
    };

    secretFiles = {
      TURN_PASSWORD = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc "Path to a file containing the secret TURN_PASSWORD.";
      };

      TURN_SECRET = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc "Path to a file containing the secret TURN_SECRET.";
      };

      STUN_PASSWORD = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc "Path to a file containing the secret STUN_PASSWORD.";
      };

      AUTH_CLIENT_SECRET = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc "Path to a file containing the secret NETBIRD_AUTH_CLIENT_SECRET.";
      };

      IDP_MGMT_CLIENT_SECRET = mkOption {
        type = with types; nullOr path;
        default = cfg.secretFiles.AUTH_CLIENT_SECRET;
        defaultText = lib.literalExpression "cfg.secretFiles.AUTH_CLIENT_SECRET;";
        description = lib.mdDoc "Path to a file containing the secret NETBIRD_IDP_MGMT_CLIENT_SECRET.";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.netbird-server.managementConfig = with settings; {
        Stuns = mkDefault [
          {
            Proto = "udp";
            URI = "stun:${TURN_DOMAIN}:${builtins.toString TURN_PORT}";
            Username = STUN_USERNAME;
            Password = STUN_PASSWORD;
          }
        ];
        TURNConfig = {
          Turns = [
            {
              Proto = "udp";
              URI = "turn:${TURN_DOMAIN}:${builtins.toString TURN_PORT}";
              Username = TURN_USER;
              Password = TURN_PASSWORD;
            }
          ];
          CredentialsTTL = "12h";
          Secret = TURN_SECRET;
          TimeBasedCredentials = false;
        };
        Signal = {
          Proto = NETBIRD_SIGNAL_PROTOCOL;
          URI = "${NETBIRD_DOMAIN}:${builtins.toString NETBIRD_SIGNAL_PORT}";
          Username = "";
          Password = null;
        };
        Datadir = "${stateDir}/data";
        HttpConfig = {
          Address = "127.0.0.1:${builtins.toString cfg.ports.management}";
          AuthIssuer = NETBIRD_AUTH_AUTHORITY;
          AuthAudience = NETBIRD_AUTH_AUDIENCE;
          AuthKeysLocation = NETBIRD_AUTH_JWT_CERTS;
          AuthUserIDClaim = NETBIRD_AUTH_USER_ID_CLAIM;
          OIDCConfigEndpoint = NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT;
        };
        IdpManagerConfig = {
          ManagerType = NETBIRD_MGMT_IDP;
          ClientConfig = {
            Issuer = NETBIRD_AUTH_AUTHORITY;
            TokenEndpoint = NETBIRD_AUTH_TOKEN_ENDPOINT;
            ClientID = NETBIRD_IDP_MGMT_CLIENT_ID;
            ClientSecret = NETBIRD_IDP_MGMT_CLIENT_SECRET;
            GrantType = NETBIRD_IDP_MGMT_GRANT_TYPE;
          };
          ExtraConfig = cfg.idpManagerExtraConfig;
        };
        DeviceAuthorizationFlow = mkIf cfg.enableDeviceAuthorizationFlow {
          Provider = NETBIRD_AUTH_DEVICE_AUTH_PROVIDER;
          ProviderConfig = {
            Audience = NETBIRD_AUTH_DEVICE_AUTH_AUDIENCE;
            Domain = NETBIRD_AUTH_AUTHORITY;
            ClientID = NETBIRD_AUTH_DEVICE_AUTH_CLIENT_ID;
            TokenEndpoint = NETBIRD_AUTH_TOKEN_ENDPOINT;
            DeviceAuthEndpoint = NETBIRD_AUTH_DEVICE_AUTH_ENDPOINT;
            Scope = builtins.concatStringsSep " " NETBIRD_AUTH_DEVICE_AUTH_SCOPE;
            UseIDToken = NETBIRD_AUTH_DEVICE_AUTH_USE_ID_TOKEN;
          };
        };
        PKCEAuthorizationFlow = {
          ProviderConfig = {
            Audience = NETBIRD_AUTH_AUDIENCE;
            ClientID = NETBIRD_AUTH_CLIENT_ID;
            ClientSecret = NETBIRD_AUTH_CLIENT_SECRET;
            AuthorizationEndpoint = NETBIRD_AUTH_PKCE_AUTHORIZATION_ENDPOINT;
            TokenEndpoint = NETBIRD_AUTH_TOKEN_ENDPOINT;
            Scope = builtins.concatStringsSep " " NETBIRD_AUTH_SUPPORTED_SCOPES;
            RedirectURLs = NETBIRD_AUTH_PKCE_REDIRECT_URLS;
            UseIDToken = NETBIRD_AUTH_PKCE_USE_ID_TOKEN;
          };
        };
      };

      services.nginx.virtualHosts = mkIf cfg.enableNginx {
        ${cfg.settings.NETBIRD_DOMAIN} = {
          forceSSL = true;
          enableACME = true;

          locations = {
            "/" = {
              root = "${stateDir}/web-ui/";
              tryFiles = "$uri /index.html";
            };

            "/signalexchange.SignalExchange/".extraConfig = ''
              grpc_pass grpc://localhost:${builtins.toString cfg.ports.signal};
              grpc_read_timeout 1d;
              grpc_send_timeout 1d;
              grpc_socket_keepalive on;
            '';

            "/api".proxyPass = "http://localhost:${builtins.toString cfg.ports.management}";

            "/management.ManagementService/".extraConfig = ''
              grpc_pass grpc://localhost:${builtins.toString cfg.ports.management};
              grpc_read_timeout 1d;
              grpc_send_timeout 1d;
              grpc_socket_keepalive on;
            '';
          };
        };
      };

      systemd.services = {
        netbird-setup = {
          wantedBy = [
            "netbird-management.service"
            "netbird-signal.service"
            "multi-user.target"
          ];
          serviceConfig = {
            Type = "oneshot";
            RuntimeDirectory = "netbird-mgmt";
            StateDirectory = "netbird-mgmt";
            WorkingDirectory = stateDir;
            EnvironmentFile = [ settingsFile ];
          };
          unitConfig = {
            StartLimitInterval = 5;
            StartLimitBurst = 10;
          };

          path =
            [
              pkgs.coreutils
              pkgs.findutils
              pkgs.gettext
              pkgs.gnused
            ]
            ++ (optionals cfg.setupAutoOidc [
              pkgs.curl
              pkgs.jq
            ]);

          script =
            ''
              cp ${managementFile} ${stateDir}/management.json.copy
            ''
            + (optionalString cfg.setupAutoOidc ''
              mv ${stateDir}/management.json.copy ${stateDir}/management.json
              echo "loading OpenID configuration from $NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT to the openid-configuration.json file"
              curl "$NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT" -q -o ${stateDir}/openid-configuration.json

              export NETBIRD_AUTH_AUTHORITY=$(jq -r '.issuer' ${stateDir}/openid-configuration.json)
              export NETBIRD_AUTH_JWT_CERTS=$(jq -r '.jwks_uri' ${stateDir}/openid-configuration.json)
              export NETBIRD_AUTH_TOKEN_ENDPOINT=$(jq -r '.token_endpoint' ${stateDir}/openid-configuration.json)
              export NETBIRD_AUTH_DEVICE_AUTH_ENDPOINT=$(jq -r '.device_authorization_endpoint' ${stateDir}/openid-configuration.json)
              export NETBIRD_AUTH_PKCE_AUTHORIZATION_ENDPOINT=$(jq -r '.authorization_endpoint' ${stateDir}/openid-configuration.json)

              envsubst '$NETBIRD_AUTH_AUTHORITY $NETBIRD_AUTH_JWT_CERTS $NETBIRD_AUTH_TOKEN_ENDPOINT $NETBIRD_AUTH_DEVICE_AUTH_ENDPOINT $NETBIRD_AUTH_PKCE_AUTHORIZATION_ENDPOINT' < ${stateDir}/management.json > ${stateDir}/management.json.copy
            '')
            + ''
              # Update secrets in management.json
              ${builtins.concatStringsSep "\n" (
                builtins.attrValues (
                  builtins.mapAttrs (name: path: "export ${name}=$(cat ${path})") (
                    filterAttrs (_: p: p != null) cfg.secretFiles
                  )
                )
              )}

              envsubst '$TURN_PASSWORD $TURN_SECRET $STUN_PASSWORD $AUTH_CLIENT_SECRET $IDP_MGMT_CLIENT_SECRET' < ${stateDir}/management.json.copy > ${stateDir}/management.json

              rm -rf ${stateDir}/web-ui
              mkdir -p ${stateDir}/web-ui
              cp -R ${cfg.dashboard}/* ${stateDir}/web-ui

              export AUTH_AUTHORITY="$NETBIRD_AUTH_AUTHORITY"
              export AUTH_CLIENT_ID="$NETBIRD_AUTH_CLIENT_ID"
              ${optionalString (cfg.secretFiles.AUTH_CLIENT_SECRET == null)
                ''export AUTH_CLIENT_SECRET="$NETBIRD_AUTH_CLIENT_SECRET"''}
              export AUTH_AUDIENCE="$NETBIRD_AUTH_AUDIENCE"
              export AUTH_REDIRECT_URI="$NETBIRD_AUTH_REDIRECT_URI"
              export AUTH_SILENT_REDIRECT_URI="$NETBIRD_AUTH_SILENT_REDIRECT_URI"
              export USE_AUTH0="$NETBIRD_USE_AUTH0"
              export AUTH_SUPPORTED_SCOPES=$(echo $NETBIRD_AUTH_SUPPORTED_SCOPES | sed -E 's/"//g')

              export NETBIRD_MGMT_API_ENDPOINT=$(echo $NETBIRD_MGMT_API_ENDPOINT | sed -E 's/(:80|:443)$//')

              MAIN_JS=$(find ${stateDir}/web-ui/static/js/main.*js)
              OIDC_TRUSTED_DOMAINS=${stateDir}/web-ui/OidcTrustedDomains.js
              mv "$MAIN_JS" "$MAIN_JS".copy
              envsubst '$USE_AUTH0 $AUTH_AUTHORITY $AUTH_CLIENT_ID $AUTH_CLIENT_SECRET $AUTH_SUPPORTED_SCOPES $AUTH_AUDIENCE $NETBIRD_MGMT_API_ENDPOINT $NETBIRD_MGMT_GRPC_API_ENDPOINT $NETBIRD_HOTJAR_TRACK_ID $AUTH_REDIRECT_URI $AUTH_SILENT_REDIRECT_URI $NETBIRD_TOKEN_SOURCE $NETBIRD_DRAG_QUERY_PARAMS' < "$MAIN_JS".copy > "$MAIN_JS"
              envsubst '$NETBIRD_MGMT_API_ENDPOINT' < "$OIDC_TRUSTED_DOMAINS".tmpl > "$OIDC_TRUSTED_DOMAINS"
            '';
        };

        netbird-signal = {
          after = [ "network.target" ];
          wantedBy = [ "netbird-management.service" ];
          restartTriggers = [
            settingsFile
            managementFile
          ];

          serviceConfig = {
            ExecStart = ''
              ${cfg.package}/bin/netbird-signal run \
                --port ${builtins.toString cfg.ports.signal} \
                --log-file console \
                --log-level ${cfg.logLevel}
            '';
            Restart = "always";
            RuntimeDirectory = "netbird-mgmt";
            StateDirectory = "netbird-mgmt";
            WorkingDirectory = stateDir;
          };
          unitConfig = {
            StartLimitInterval = 5;
            StartLimitBurst = 10;
          };
          stopIfChanged = false;
        };

        netbird-management = {
          description = "The management server for Netbird, a wireguard VPN";
          documentation = [ "https://netbird.io/docs/" ];
          after = [
            "network.target"
            "netbird-setup.service"
          ];
          wantedBy = [ "multi-user.target" ];
          wants = [
            "netbird-signal.service"
            "netbird-setup.service"
          ];
          restartTriggers = [
            settingsFile
            managementFile
          ];

          serviceConfig = {
            ExecStart = ''
              ${cfg.package}/bin/netbird-mgmt management \
                --config ${stateDir}/management.json \
                --datadir ${stateDir}/data \
                ${optionalString cfg.management.disableAnonymousMetrics "--disable-anonymous-metrics"} \
                ${optionalString cfg.management.disableSingleAccountMode "--disable-single-account-mode"} \
                --dns-domain ${cfg.management.dnsDomain} \
                --single-account-mode-domain ${cfg.management.singleAccountModeDomain} \
                --idp-sign-key-refresh-enabled \
                --port ${builtins.toString cfg.ports.management} \
                --log-file console \
                --log-level ${cfg.logLevel}
            '';
            Restart = "always";
            RuntimeDirectory = "netbird-mgmt";
            StateDirectory = [
              "netbird-mgmt"
              "netbird-mgmt/data"
            ];
            WorkingDirectory = stateDir;
          };
          unitConfig = {
            StartLimitInterval = 5;
            StartLimitBurst = 10;
          };
          stopIfChanged = false;
        };
      };
    })

    (mkIf cfg.enableCoturn {
      services.coturn = {
        enable = true;

        realm = settings.NETBIRD_DOMAIN;
        lt-cred-mech = true;
        no-cli = true;

        extraConfig = ''
          fingerprint

          user=${settings.TURN_USER}:${builtins.toString settings.TURN_PASSWORD}
          no-software-attribute
        '';
      };

      networking.firewall = {
        allowedUDPPorts = with settings; [
          TURN_PORT
          (TURN_PORT + 1)
          5349
          5350
        ];
        allowedTCPPorts = with settings; [
          TURN_PORT
          (TURN_PORT + 1)
        ];
        allowedUDPPortRanges = [
          {
            from = settings.TURN_MIN_PORT;
            to = settings.TURN_MAX_PORT;
          }
        ];
      };
    })

    (mkIf (cfg.enableNginx && cfg.enableCoturn) {
      services.coturn =
        let
          cert = config.security.acme.certs.${settings.TURN_DOMAIN};
        in
        {
          cert = "${cert.directory}/fullchain.pem";
          pkey = "${cert.directory}/key.pem";
        };

      users.users.nginx.extraGroups = [ "turnserver" ];

      # share certs with coturn and restart on renewal
      security.acme.certs.${settings.TURN_DOMAIN} = {
        group = "turnserver";
        postRun = "systemctl reload nginx.service; systemctl restart coturn.service";
      };
    })
  ];
}
