{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.spacetimedb;

  listenAddr = "${cfg.server.bindAddress}:${toString cfg.server.port}";

  executable = "${lib.getExe cfg.package} --root-dir=${cfg.rootDir} start --listen-addr='${listenAddr}' ${lib.optionalString cfg.server.enableTracy "--enable-tracy"} ${
    lib.optionalString (
      cfg.server.jwtPublicKeyPath != null
    ) "--jwt-pub-key-path=${cfg.server.jwtPublicKeyPath}"
  } ${
    lib.optionalString (
      cfg.server.jwtPrivateKeyPath != null
    ) "--jwt-priv-key-path=${cfg.server.jwtPrivateKeyPath}"
  } ${lib.optionalString cfg.server.inMemory "--in-memory"}";
in
{
  options.services.spacetimedb = {
    enable = lib.mkEnableOption "spacetimedb";

    package = lib.mkPackageOption pkgs "spacetimedb" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "spacetimedb";
      description = "The user to run SpacetimeDB as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "spacetimedb";
      description = "The group to run SpacetimeDB as.";
    };

    rootDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/spacetime";
      description = "The root directory for SpacetimeDB.";
    };

    openFirewall = lib.mkEnableOption "" // {
      description = "Whether to open the firewall for the SpacetimeDB server.";
    };

    server = {
      bindAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address to listen on";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "The port to listen on.";
      };

      enableTracy = lib.mkEnableOption "tracy profiling";

      jwtPublicKeyPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "The path to the public jwt key for verifying identities";
      };

      jwtPrivateKeyPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "The path to the private jwt key for issuing identities";
      };

      inMemory = lib.mkEnableOption "" // {
        description = "If enabled the database will run entirely in memory. After the process exits, all data will be lost.";
      };
    };

    nginx = {
      enable = lib.mkEnableOption "Nginx";

      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The domain used by the nginx virtualHost.
        '';
      };

      forceSSL = lib.mkEnableOption "" // {
        description = "Whether to force the use of SSL.";
      };

      useACMEHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          A host of an existing Let's Encrypt certificate to use.

          *Note that this still requires services.spacetimedb.nginx.domain to be set.
        '';
      };

      restrictPublish = lib.mkEnableOption "" // {
        description = "Whether to restrict the publish database route to local connections.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.nginx.enable || (cfg.nginx.domain != null);
        message = "To use services.spacetimedb.nginx, you need to set services.spacetimedb.nginx.domain";
      }
    ];

    users.groups = lib.mkIf (cfg.group == "spacetimedb") { spacetimedb = { }; };

    users.users = lib.mkIf (cfg.user == "spacetimedb") {
      spacetimedb = {
        group = cfg.group;
        home = cfg.rootDir;
        description = "SpacetimeDB Daemon user";
        isSystemUser = true;
      };
    };

    systemd.tmpfiles.settings."10-spacetimedb" = {
      ${cfg.rootDir}.d = {
        inherit (cfg) user group;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services.spacetimedb = {
      description = "SpacetimeDB Server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig.RequiresMountsFor = cfg.rootDir;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        ExecStart = executable;
        Restart = "always";
        RestartSec = "15";

        WorkingDirectory = cfg.rootDir;

        # Capabilities
        CapabilityBoundingSet = "";

        # Security
        NoNewPrivileges = true;

        # Filesystem Protection
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = true;

        # Device and System Protection
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        # Network Restriction
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];

        # Security Hardening
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;

        # System Call Filtering
        SystemCallArchitectures = "native";
      };
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

      virtualHosts.${cfg.nginx.domain} = {
        forceSSL = cfg.nginx.forceSSL;

        enableACME = lib.mkDefault (cfg.nginx.forceSSL && cfg.nginx.useACMEHost == null);
        useACMEHost = cfg.nginx.useACMEHost;

        locations = {
          "/" = {
            proxyPass = "http://${listenAddr}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          "/v1/publish" = lib.mkIf cfg.nginx.restrictPublish {
            proxyPass = "http://${listenAddr}";
            recommendedProxySettings = true;
            proxyWebsockets = true;

            extraConfig = ''
              allow 127.0.0.1;
              deny all;
            '';
          };
        };
      };
    };
  };

  meta.maintainers = [
    lib.maintainers.akotro
  ];
}
