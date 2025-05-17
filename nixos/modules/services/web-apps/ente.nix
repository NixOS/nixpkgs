{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mapAttrsRecursive
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optional
    recursiveUpdate
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
        NEXT_PUBLIC_ENTE_ENDPOINT = "https://${cfgApi.domain}";
        NEXT_PUBLIC_ENTE_ALBUMS_ENDPOINT = cfgApi.settings.apps.public-albums;
        NEXT_TELEMETRY_DISABLED = "1";
      };
    };

  defaultUser = "ente";
  defaultGroup = "ente";
  dataDir = "/var/lib/ente";

  yamlFormat = pkgs.formats.yaml { };

  # Generate settings yaml with empty strings at any position where a secret
  # will be used, this is required by museum.
  settingsYaml = yamlFormat.generate "museum.yaml" (
    recursiveUpdate cfgApi.settings (mapAttrsRecursive (_: _: "") cfgApi.settingsSecret)
  );

  # Generate a secret settings yaml which associates the file containing the
  # secret for each setting.
  secretFilesYaml = yamlFormat.generate "museum-secrets.yaml" cfgApi.settingsSecret;
in
{
  options.services.ente = {
    web = {
      enable = mkEnableOption "Ente web frontend (Photos, Albums)";
      package = mkPackageOption pkgs "ente-web" { };

      domains = {
        accounts = mkOption {
          type = types.str;
          description = "The domain under which the accounts frontend will be served. Must be https.";
        };

        cast = mkOption {
          type = types.str;
          description = "The domain under which the cast frontend will be served. Must be https.";
        };

        albums = mkOption {
          type = types.str;
          description = "The domain under which the albums frontend will be served. Must be https.";
        };

        photos = mkOption {
          type = types.str;
          description = "The domain under which the photos frontend will be served. Must be https.";
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
        description = "User under which museum runs.";
      };

      group = mkOption {
        type = types.str;
        default = defaultGroup;
        description = "Group under which museum runs.";
      };

      domain = mkOption {
        type = types.str;
        description = "The domain under which the api will be served.";
      };

      enableLocalDB = mkEnableOption "the automatic creation of a local postgres database for museum.";

      settings = mkOption {
        description = ''
          Museum yaml configuration.
          Refer to upstream [local.yaml](https://github.com/ente-io/ente/blob/main/server/configurations/local.yaml) for more information.
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

      settingsSecret = mkOption {
        description = ''
          Museum yaml configuration overrides. Similar to
          {option}`services.ente.api.settings`, but values specified here must
          be files. The file content will automatically be loaded at runtime and
          used to set/override the associated yaml setting. Useful to specify
          secrets. Values will always be strings.

          Refer to upstream [local.yaml](https://github.com/ente-io/ente/blob/main/server/configurations/local.yaml) for more information.
        '';
        default = { };
        type = types.submodule {
          freeformType =
            let
              recursiveAttrsOrPath = types.lazyAttrsOf (types.either types.path recursiveAttrsOrPath) // {
                description = "recursive attrs or path";
              };
            in
            recursiveAttrsOrPath;
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

      services.ente.api.settings = {
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
          # Load secret values and merge over base settings
          BASE_FILE=${settingsYaml} \
            ${getExe pkgs.yq-go} 'load(strenv(BASE_FILE)) * ((.. | select(kind == "scalar")) |= load_str(.))' ${secretFilesYaml} \
            > /run/ente/local.yaml

          mkdir -p ${dataDir}/configurations
          ln -sTf /run/ente/local.yaml ${dataDir}/configurations/local.yaml
        '';

        serviceConfig = {
          ExecStart = getExe cfgApi.package;
          Type = "simple";
          Restart = "on-failure";

          AmbientCapablities = [ ];
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
      services.ente.api.settings = {
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
            };
          };
          virtualHosts.${domainFor "cast"} = {
            forceSSL = mkDefault true;
            locations."/" = {
              root = webPackage "cast";
              tryFiles = "$uri $uri.html /index.html";
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
            };
          };
        };
    })
  ];

  meta.maintainers = with lib.maintainers; [ oddlama ];
}
