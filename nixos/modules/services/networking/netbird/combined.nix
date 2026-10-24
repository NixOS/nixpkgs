{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils) genJqSecretsReplacement;

  cfg = config.services.netbird.server.combined;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "netbird-server-config.yaml" cfg.settings;
  listenPort = lib.toInt (lib.last (lib.splitString ":" cfg.settings.server.listenAddress));

  runtimeConfigFile = genJqSecretsReplacement {
    loadCredential = true;
  } cfg.settings "/run/netbird-server/config.yaml";
in
{
  options.services.netbird.server.combined = {
    enable = lib.mkEnableOption "Netbird Combined Server";

    package = lib.mkPackageOption pkgs "netbird-combined" { };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = ''
        Service environnment.

        https://docs.netbird.io/selfhosted/environment-variables
      '';
      default = { };
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      description = "Environment files";
      default = [ ];
    };

    openSTUNPorts = lib.mkEnableOption "Open firewall ports for STUN";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          server = {
            listenAddress = lib.mkOption {
              type = lib.types.str;
              description = "Server listen address";
              default = ":8100";
            };

            dataDir = lib.mkOption {
              type = lib.types.str;
              description = "Server data directory";
              default = "/var/lib/netbird-server";
              internal = true;
            };

            stunPorts = lib.mkOption {
              type = lib.types.listOf lib.types.int;
              description = "STUN Ports";
              default = [ 3478 ];
            };
          };
        };
        config = { };
      };
      description = ''
        Combined Server config.yaml

        Options containing secret data should be set to an attribute set containing the attribute _secret
        - a string pointing to a file containing the value the option should be set to.

        https://docs.netbird.io/selfhosted/maintenance/configuration-files#config-yaml
        https://github.com/netbirdio/netbird/blob/4a6efbb5fc043a8cd3fe5c6a8eea0473c26e9512/combined/config.yaml.example
      '';
      example = {
        server = {
          listenAddress = ":7100";
          # port is required on exposedAddress
          exposedAddress = "https://mynetbird.server:443";
          authSecret._secret = "/path/to/secret/outside/store";
          disableAnonymousMetrics = true;
          disableGeoliteUpdate = false;
          auth = {
            issuer = "https://mynetbird.server/oauth2";
            localAuthDisabled = true;
            signKeyRefreshEnabled = true;
            dashboardRedirectURIs = [
              "https://mynetbird.server/nb-auth"
              "https://mynetbird.server/nb-silent-auth"
            ];
            # openssl rand -base64 32
            sessionCookieEncryptionKey._secret = "/path/to/secret/outside/store";
            staticConnectors = [
              {
                type = "oidc";
                id = "myidp";
                name = "My IDP";
                config = {
                  issuer = "https://myidp.server/oauth2/openid/netbird";
                  clientID = "netbird";
                  clientSecret._secret = "/path/to/secret/outside/store";
                  redirectURI = "https://mynetbird.server/oauth2/callback";
                  scopes = [
                    "openid"
                    "profile"
                    "email"
                    "groups"
                  ];
                };
              }
            ];
          };

          reverseProxy.trustedHTTPProxies = [ "127.0.0.1" ];

          store.encryptionKey._secret = "/path/to/secret/outside/store";
        };
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    networking.firewall.allowedUDPPorts = lib.optionals cfg.openSTUNPorts cfg.settings.server.stunPorts;

    systemd.services.netbird-server = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];

      restartTriggers = [ configFile ];
      preStart = runtimeConfigFile.script;

      inherit (cfg) environment;

      confinement = {
        enable = true;
        mode = "full-apivfs";
        binSh = null;
      };

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config /run/netbird-server/config.yaml";
        EnvironmentFile = cfg.environmentFiles;

        LoadCredential = runtimeConfigFile.credentials;

        DynamicUser = true;
        StateDirectory = "netbird-server";
        StateDirectoryMode = "0700";
        RuntimeDirectory = [ "netbird-server" ];
        RuntimeDirectoryMode = "0700";

        BindReadOnlyPaths = [
          "/etc/ssl/certs"
          "/etc/static/ssl/certs"
          config.environment.etc."ssl/certs/ca-certificates.crt".source
          "/etc/hosts"
          "/etc/nsswitch.conf"
          "/etc/resolv.conf"
        ];

        Restart = "on-failure";
        RestartSec = 5;

        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ] ++ lib.optionals (listenPort < 1024) [ "CAP_NET_BIND_SERVICE" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
        ];
        UMask = "0077";
      };
    };
  };
}
