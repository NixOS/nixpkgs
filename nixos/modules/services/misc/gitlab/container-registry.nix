{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gitlab.registry;

  jsonFmt = pkgs.formats.json { };
  blobCache = if cfg.enableRedisCache then "redis" else "inmemory";

  enableDatabase = cfg.settings.database.enabled == true || cfg.settings.database.enabled == "prefer";
  # We only want to create a database if we're actually going to connect to it.
  databaseActuallyCreateLocally = cfg.databaseCreateLocally && cfg.settings.database.host == "";
  enableDatabaseLocally = enableDatabase && cfg.settings.database.host == "";
  configFile = jsonFmt.generate "gitlab-container-registry-config.json" cfg.settings;
in
{
  options.services.gitlab.registry = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GitLab container registry.";
    };
    package = lib.mkPackageOption pkgs "gitlab-container-registry" {
      extraDescription = ''
        External container registries such as `pkgs.distribution` are not supported
        anymore since GitLab 16.0.0.
      '';
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = config.services.gitlab.host;
      defaultText = lib.literalExpression "config.services.gitlab.host";
      description = "Address of the GitLab, Gitlab Contianer Registry connects to.";
    };
    certFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to GitLab container registry certificate.";
    };
    keyFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to GitLab container registry certificate-key.";
    };
    defaultForProjects = lib.mkOption {
      type = lib.types.bool;
      default = cfg.registry.enable;
      defaultText = lib.literalExpression "config.\${config.services.gitlab.registry.enable}";
      description = "If GitLab container registry should be enabled by default for projects.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "gitlab-container-registry";
      description = "User the registry runs in";
    };

    externalAddress = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "External address used to access registry from the internet";
    };
    externalPort = lib.mkOption {
      type = lib.types.port;
      description = "External port used to access registry from the internet";
    };

    databaseCreateLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether a database should be automatically created on the
        local host. Set this to `false` if you plan
        on provisioning a local database yourself. This has no effect
        if {option}`services.gitlab.registry.settings.database.host` is customized.
      '';
    };

    storagePath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default =
        if lib.versionAtLeast config.system.stateVersion "27.05" then
          "/var/lib/gitlab-conntainer-registry"
        else
          "/var/lib/docker-registry";
      defaultText = lib.literalExpression ''
        if lib.versionAtLeast config.system.stateVersion "27.05" then
        "/var/lib/gitlab-conntainer-registry"
        else
        "/var/lib/docker-registry"
      '';
      description = ''
        GitLab container registry storage path for the filesystem storage backend. Set to
        null to configure another backend via settings.
      '';
    };

    enableDelete = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable delete for manifests and blobs.";
    };

    enableRedisCache = lib.mkEnableOption "redis as blob cache";

    redisUrl = lib.mkOption {
      type = lib.types.str;
      default = "localhost:6379";
      description = "Set redis host and port.";
    };

    redisPassword = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Set redis password.";
    };

    settings = lib.mkOption {
      description = ''
        GitLab container registry configuration.
      '';
      default = { };
      type = lib.types.submodule {
        freeformType = jsonFmt.type;

        options = {
          version = lib.mkOption {
            type = lib.types.str;
            default = "0.1";
            description = "Version of the configuration file";
          };

          auth.token = {
            realm = lib.mkOption {
              type = lib.types.str;
              description = "The realm in which the registry server authenticates.";
              default = "http${
                lib.optionalString (config.services.gitlab.https == true) "s"
              }://${cfg.host}/jwt/auth";
              defaultText = lib.literalExpression "http\${
                lib.optionalString (config.services.gitlab.https == true) 's'
              }://\${cfg.host}/jwt/auth";
            };
            service = lib.mkOption {
              type = lib.types.str;
              description = "The service being authenticated";
              default = "container_registry";
            };
            issuer = lib.mkOption {
              type = lib.types.str;
              description = "The name of the token issuer. The issuer inserts this into the token so it must match the value configured for the issuer.";
              default = "gitlab-issuer";
            };
            rootcertbundle = lib.mkOption {
              type = lib.types.path;
              default = cfg.certFile;
              defaultText = lib.literalExpression "config.services.gitlab.registry.certFile";
              readOnly = true;
              description = "The absolute path to the root certificate bundle. This bundle contains the public part of the certificates used to sign authentication tokens.";
            };
          };
          database = {
            enabled = lib.mkOption {
              type = lib.types.oneOf [
                lib.types.bool
                (lib.types.enum [ "prefer" ])
              ];
              default = "prefer";
              description = ''
                Whether to enable the database metadata store.

                "prefer" is a mode that uses the database as metadata store, but falls back to the filesystem store when it has not been imported yet into the database.
              '';
            };
            dbname = lib.mkOption {
              type = lib.types.str;
              default = "gitlab-container-registry";
              description = "The database name that is used.";
            };
            host = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "The database host GitLab container registry connects to. An empty string means 'use local unix socket connection'";
            };
          };
          health.storagedriver = {
            enabled = lib.mkEnableOption "storage driver health checks" // {
              default = true;
            };
            threshold = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 3;
              description = "The number of times the check must fail before the state is marked as unhealthy";
            };
          };
          http = {
            addr = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1:4567";
              description = "Address the contianer registry listens on.";
            };
            headers.X-Content-Type-Options = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "nosniff" ];
              description = "Value the X-Content-Type-Options HTTP header should be set to. 'nosniff' is recommended by GitLab.";
            };
          };
          log.fields.service = lib.mkOption {
            type = lib.types.str;
            default = "gitlab-container-registry";
            description = "The service name added to log messages";
          };
          storage.cache.blobdescriptor = lib.mkOption {
            type = lib.types.str;
            default = blobCache;
            defaultText = lib.literalExpression "if config.services.gitlab.registry.enableRedisCache then \"redis\" else \"inmemory\"";
            description = "Backend to use for caching.";
          };
        };
      };
    };

    enableGarbageCollect = lib.mkEnableOption "garbage collect";

    garbageCollectDates = lib.mkOption {
      default = "daily";
      type = lib.types.str;
      description = ''
        Specification (in the format described by
        {manpage}`systemd.time(7)`) of the time at
        which the garbage collect will occur.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."gitlab-container-registry-config.json".source = configFile;
    services.gitlab.registry.settings = {
      # This must be true, otherwise GitLab won't manage it correctly
      delete.enabled = true;
      # GitLab container registry enables the redis cache as soon as the redis key exists in the config file.
      redis = lib.mkIf cfg.enableRedisCache (
        {
          addr = "${cfg.redisUrl}";
          password = "${cfg.redisPassword}";
        }
        // (builtins.mapAttrs (_: lib.mkDefault) {
          db = 0;
          dialtimeout = "10ms";
          readtimeout = "10ms";
          writetimeout = "10ms";
          pool = {
            maxidle = 16;
            maxactive = 64;
            idletimeout = "300s";
          };
        })
      );
      storage.filesystem.rootdirectory = lib.mkIf (cfg.storagePath != null) cfg.storagePath;
    };

    systemd.services.gitlab-registry-cert = {
      path = with pkgs; [ openssl ];

      script =
        let
          user = config.services.gitlab.user;
          group = config.services.gitlab.group;
        in
        ''
          mkdir -p $(dirname ${cfg.keyFile})
          mkdir -p $(dirname ${cfg.certFile})
          openssl req -nodes -newkey rsa:4096 -keyout ${cfg.keyFile} -out /tmp/registry-auth.csr -subj "/CN=${cfg.settings.auth.token.issuer}"
          openssl x509 -in /tmp/registry-auth.csr -out ${cfg.certFile} -req -signkey ${cfg.keyFile} -days 3650
          chown ${user}:${group} $(dirname ${cfg.keyFile})
          chown ${user}:${group} $(dirname ${cfg.certFile})
          chown ${user}:${group} ${cfg.keyFile}
          chown ${user}:${group} ${cfg.certFile}
        '';

      unitConfig = {
        ConditionPathExists = "!${cfg.certFile}";
      };
      serviceConfig = {
        Type = "oneshot";
        Slice = "system-gitlab.slice";
      };
    };

    systemd.services.gitlab-container-registry = {
      description = "GitLab Container Registry";
      wantedBy = [ "multi-user.target" ];
      # Ensure Docker Registry launches after the certificate generation job
      wants = [ "gitlab-registry-cert.service" ];
      after = [
        "network.target"
        "gitlab-registry-cert.service"
      ]
      ++ lib.optionals enableDatabaseLocally [ "postgresql.target" ];
      requires = lib.optionals enableDatabaseLocally [ "postgresql.target" ];

      preStart = lib.mkIf enableDatabaseLocally "${lib.getExe cfg.package} database migrate up --skip-post-deployment ${configFile}";

      postStart = lib.mkIf enableDatabaseLocally "${lib.getExe cfg.package} database migrate up ${configFile}";

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve ${configFile}";
        User = cfg.user;
        WorkingDirectory = cfg.storagePath;
        AmbientCapabilities = "cap_net_bind_service";
      };
    };

    # This is only required for legacy metadata, database metadata backend does online garbage collection
    systemd.services.gitlab-container-registry-garbage-collect = {
      description = "Run Garbage Collection for GitLab container registry";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      serviceConfig.Type = "oneshot";

      script = ''
        ${lib.getExe cfg.package} garbage-collect ${configFile}
        /run/current-system/systemd/bin/systemctl restart gitlab-container-registry.service
      '';

      startAt = lib.optional cfg.enableGarbageCollect cfg.garbageCollectDates;
    };

    services.postgresql = lib.mkIf databaseActuallyCreateLocally {
      ensureDatabases = [ "gitlab-container-registry" ];
      ensureUsers = [
        {
          name = "gitlab-container-registry";
          ensureDBOwnership = true;
        }
      ];
    };

    users.users.gitlab-container-registry = lib.mkIf (cfg.user == "gitlab-container-registry") (
      (lib.optionalAttrs (cfg.storagePath != null) {
        createHome = true;
        home = cfg.storagePath;
      })
      // {
        group = "gitlab-container-registry";
        isSystemUser = true;
      }
    );
    users.groups.gitlab-container-registry = lib.mkIf (cfg.user == "gitlab-container-registry") { };
  };
}
