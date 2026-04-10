{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optional
    types
    ;

  cfgApi = config.services.ente.api;
  cfgWeb = config.services.ente.web;

  webPackage =
    enteApp:
    cfgWeb.package.override {
      inherit enteApp;
      enteMainUrl = "https://${cfgWeb.domains.photos}";
      extraBuildEnv = {
        NEXT_PUBLIC_ENTE_ENDPOINT = "https://${cfgWeb.domains.api}";
        NEXT_PUBLIC_ENTE_ALBUMS_ENDPOINT = "https://${cfgWeb.domains.albums}";
        NEXT_TELEMETRY_DISABLED = "1";
      };
    };

  defaultUser = "ente";
  defaultGroup = "ente";
  dataDir = "/var/lib/ente";

  yamlFormat = pkgs.formats.yaml { };
in
{
  options.services.ente = {
    web = {
      enable = mkEnableOption "Ente web frontend (Photos, Albums)";
      package = mkPackageOption pkgs "ente-web" { };

      domains = {
        api = mkOption {
          type = types.str;
          example = "api.ente.example.com";
          description = ''
            The domain under which the api is served. This will NOT serve the api itself,
            but is a required setting to host the frontends! This will automatically be set
            for you if you enable both the api server and web frontends.
          '';
        };

        accounts = mkOption {
          type = types.str;
          example = "accounts.ente.example.com";
          description = "The domain under which the accounts frontend will be served.";
        };

        cast = mkOption {
          type = types.str;
          example = "cast.ente.example.com";
          description = "The domain under which the cast frontend will be served.";
        };

        albums = mkOption {
          type = types.str;
          example = "albums.ente.example.com";
          description = "The domain under which the albums frontend will be served.";
        };

        photos = mkOption {
          type = types.str;
          example = "photos.ente.example.com";
          description = "The domain under which the photos frontend will be served.";
        };
      };
    };

    api = {
      enable = mkEnableOption "Museum (API server for ente.io)";
      package = mkPackageOption pkgs "museum" { };
      nginx.enable = mkEnableOption "nginx proxy for the API server";

      user = mkOption {
        type = types.str;
        default = defaultUser;
        description = "User under which museum runs. If you set this option you must make sure the user exists.";
      };

      group = mkOption {
        type = types.str;
        default = defaultGroup;
        description = "Group under which museum runs. If you set this option you must make sure the group exists.";
      };

      domain = mkOption {
        type = types.str;
        example = "api.ente.example.com";
        description = "The domain under which the api will be served.";
      };

      enableLocalDB = mkEnableOption "the automatic creation of a local postgres database for museum.";

      settings = mkOption {
        description = ''
          Museum yaml configuration. Refer to upstream [local.yaml](https://github.com/ente-io/ente/blob/main/server/configurations/local.yaml) for more information.
          You can specify secret values in this configuration by setting `somevalue._secret = "/path/to/file"` instead of setting `somevalue` directly.
        '';
        default = { };
        type = types.submodule {
          freeformType = yamlFormat.type;
          options = {
            apps = {
              public-albums = mkOption {
                type = types.str;
                default = "https://albums.ente.io";
                description = ''
                  If you're running a self hosted instance and wish to serve public links,
                  set this to the URL where your albums web app is running.
                '';
              };

              cast = mkOption {
                type = types.str;
                default = "https://cast.ente.io";
                description = ''
                  Set this to the URL where your cast page is running.
                  This is for browser and chromecast casting support.
                '';
              };

              accounts = mkOption {
                type = types.str;
                default = "https://accounts.ente.io";
                description = ''
                  Set this to the URL where your accounts page is running.
                  This is primarily for passkey support.
                '';
              };
            };

            db = {
              host = mkOption {
                type = types.str;
                description = "The database host";
              };

              port = mkOption {
                type = types.port;
                default = 5432;
                description = "The database port";
              };

              name = mkOption {
                type = types.str;
                description = "The database name";
              };

              user = mkOption {
                type = types.str;
                description = "The database user";
              };
            };
          };
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfgApi.enable {
      services.postgresql = mkIf cfgApi.enableLocalDB {
        enable = true;
        ensureUsers = [
          {
            name = "ente";
            ensureDBOwnership = true;
          }
        ];
        ensureDatabases = [ "ente" ];
      };

      services.ente.web.domains.api = mkIf cfgWeb.enable cfgApi.domain;
      services.ente.api.settings = {
        # This will cause logs to be written to stdout/err, which then end up in the journal
        log-file = mkDefault "";
        db = mkIf cfgApi.enableLocalDB {
          host = "/run/postgresql";
          port = 5432;
          name = "ente";
          user = "ente";
        };
      };

      systemd.services.ente = {
        description = "Ente.io Museum API Server";
        after = [ "network.target" ] ++ optional cfgApi.enableLocalDB "postgresql.service";
        requires = optional cfgApi.enableLocalDB "postgresql.service";
        wantedBy = [ "multi-user.target" ];

        preStart = ''
          # Generate config including secret values. YAML is a superset of JSON, so we can use this here.
          ${utils.genJqSecretsReplacementSnippet cfgApi.settings "/run/ente/local.yaml"}

          # Setup paths
          mkdir -p ${dataDir}/configurations
          ln -sTf /run/ente/local.yaml ${dataDir}/configurations/local.yaml
        '';

        serviceConfig = {
          ExecStart = getExe cfgApi.package;
          Type = "simple";
          Restart = "on-failure";

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

          BindReadOnlyPaths = [
            "${cfgApi.package}/share/museum/migrations:${dataDir}/migrations"
            "${cfgApi.package}/share/museum/mail-templates:${dataDir}/mail-templates"
            "${cfgApi.package}/share/museum/web-templates:${dataDir}/web-templates"
          ];

          User = cfgApi.user;
          Group = cfgApi.group;

          SyslogIdentifier = "ente";
          StateDirectory = "ente";
          WorkingDirectory = dataDir;
          RuntimeDirectory = "ente";
        };

        # Environment MUST be called local, otherwise we cannot log to stdout
        environment = {
          ENVIRONMENT = "local";
          GIN_MODE = "release";
        };
      };

      users = {
        users = mkIf (cfgApi.user == defaultUser) {
          ${defaultUser} = {
            description = "ente.io museum service user";
            inherit (cfgApi) group;
            isSystemUser = true;
            home = dataDir;
          };
        };
        groups = mkIf (cfgApi.group == defaultGroup) { ${defaultGroup} = { }; };
      };

      services.nginx = mkIf cfgApi.nginx.enable {
        enable = true;
        upstreams.museum = {
          servers."localhost:8080" = { };
          extraConfig = ''
            zone museum 64k;
            keepalive 20;
          '';
        };

        virtualHosts.${cfgApi.domain} = {
          forceSSL = mkDefault true;
          locations."/".proxyPass = "http://museum";
          extraConfig = ''
            client_max_body_size 4M;
          '';
        };
      };
    })
    (mkIf cfgWeb.enable {
      services.ente.api.settings = mkIf cfgApi.enable {
        apps = {
          accounts = "https://${cfgWeb.domains.accounts}";
          cast = "https://${cfgWeb.domains.cast}";
          public-albums = "https://${cfgWeb.domains.albums}";
        };

        webauthn = {
          rpid = cfgWeb.domains.accounts;
          rporigins = [ "https://${cfgWeb.domains.accounts}" ];
        };
      };

      services.nginx =
        let
          domainFor = app: cfgWeb.domains.${app};
        in
        {
          enable = true;
          virtualHosts.${domainFor "accounts"} = {
            forceSSL = mkDefault true;
            locations."/" = {
              root = webPackage "accounts";
              tryFiles = "$uri $uri.html /index.html";
              extraConfig = ''
                add_header Access-Control-Allow-Origin 'https://${cfgWeb.domains.api}';
              '';
            };
          };
          virtualHosts.${domainFor "cast"} = {
            forceSSL = mkDefault true;
            locations."/" = {
              root = webPackage "cast";
              tryFiles = "$uri $uri.html /index.html";
              extraConfig = ''
                add_header Access-Control-Allow-Origin 'https://${cfgWeb.domains.api}';
              '';
            };
          };
          virtualHosts.${domainFor "photos"} = {
            serverAliases = [
              (domainFor "albums") # the albums app is shared with the photos frontend
            ];
            forceSSL = mkDefault true;
            locations."/" = {
              root = webPackage "photos";
              tryFiles = "$uri $uri.html /index.html";
              extraConfig = ''
                add_header Access-Control-Allow-Origin 'https://${cfgWeb.domains.api}';
              '';
            };
          };
        };
    })
  ];

  meta.maintainers = with lib.maintainers; [ oddlama ];
}
