{ config
, lib
, pkgs
, utils
, ...
}:

let
  cfg = config.services.pretalx;
  format = pkgs.formats.ini { };

  configFile = format.generate "pretalx.cfg" cfg.settings;

  extras = cfg.package.optional-dependencies.redis
    ++ lib.optionals (cfg.settings.database.backend == "mysql") cfg.package.optional-dependencies.mysql
    ++ lib.optionals (cfg.settings.database.backend == "postgresql") cfg.package.optional-dependencies.postgres;

  pythonEnv = cfg.package.python.buildEnv.override {
    extraLibs = [ (cfg.package.python.pkgs.toPythonModule cfg.package) ]
      ++ (with cfg.package.python.pkgs; [ gunicorn ]
      ++ lib.optional cfg.celery.enable celery) ++ extras;
  };
in

{
  meta = with lib; {
    maintainers = with maintainers; [ hexa] ++ teams.c3d2.members;
  };

  options.services.pretalx = {
    enable = lib.mkEnableOption "pretalx";

    package = lib.mkPackageOptionMD pkgs "pretalx" {};

    group = lib.mkOption {
      type = lib.types.str;
      default = "pretalx";
      description = "Group under which pretalx should run.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "pretalx";
      description = "User under which pretalx should run.";
    };

    gunicorn.extraArgs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "--name=pretalx"
      ];
      example = [
        "--name=pretalx"
        "--workers=4"
        "--max-requests=1200"
        "--max-requests-jitter=50"
        "--log-level=info"
      ];
      description = ''
        Extra arguments to pass to gunicorn.
        See <https://docs.pretalx.org/administrator/installation.html#step-6-starting-pretalx-as-a-service> for details.
      '';
      apply = lib.escapeShellArgs;
    };

    celery = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Whether to set up celery as an asynchronous task runner.
        '';
      };

      extraArgs = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = ''
          Extra arguments to pass to celery.

          See <https://docs.celeryq.dev/en/stable/reference/cli.html#celery-worker> for more info.
        '';
        apply = utils.escapeSystemdExecArgs;
      };
    };

    nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Whether to set up an nginx virtual host.
        '';
      };

      domain = lib.mkOption {
        type = lib.types.str;
        example = "talks.example.com";
        description = ''
          The domain name under which to set up the virtual host.
        '';
      };
    };

    database.createLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to automatically set up the database on the local DBMS instance.

        Currently only supported for PostgreSQL. Not required for sqlite.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          database = {
            backend = lib.mkOption {
              type = lib.types.enum [
                "postgresql"
              ];
              default = "postgresql";
              description = ''
                Database backend to use.

                Currently only PostgreSQL gets tested, and as such we don't support any other DBMS.
              '';
              readOnly = true; # only postgres supported right now
            };

            host = lib.mkOption {
              type = with lib.types; nullOr types.path;
              default = if cfg.settings.database.backend == "postgresql" then "/run/postgresql"
                else if cfg.settings.database.backend == "mysql" then "/run/mysqld/mysqld.sock"
                else null;
              defaultText = lib.literalExpression ''
                if config.services.pretalx.settings..database.backend == "postgresql" then "/run/postgresql"
                else if config.services.pretalx.settings.database.backend == "mysql" then "/run/mysqld/mysqld.sock"
                else null
              '';
              description = ''
                Database host or socket path.
              '';
            };

            name = lib.mkOption {
              type = lib.types.str;
              default = "pretalx";
              description = ''
                Database name.
              '';
            };

            user = lib.mkOption {
              type = lib.types.str;
              default = "pretalx";
              description = ''
                Database username.
              '';
            };
          };

          filesystem = {
            data = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/pretalx";
              description = ''
                Base path for all other storage paths.
              '';
            };
            logs = lib.mkOption {
              type = lib.types.path;
              default = "/var/log/pretalx";
              description = ''
                Path to the log directory, that pretalx logs message to.
              '';
            };
            static = lib.mkOption {
              type = lib.types.path;
              default = "${cfg.package.static}/";
              defaultText = lib.literalExpression "\${config.services.pretalx.package}.static}/";
              readOnly = true;
              description = ''
                Path to the directory that contains static files.
              '';
            };
          };

          celery = {
            backend = lib.mkOption {
              type = with lib.types; nullOr str;
              default = lib.optionalString cfg.celery.enable "redis+socket://${config.services.redis.servers.pretalx.unixSocket}?virtual_host=1";
              defaultText = lib.literalExpression ''
                optionalString config.services.pretalx.celery.enable "redis+socket://''${config.services.redis.servers.pretalx.unixSocket}?virtual_host=1"
              '';
              description = ''
                URI to the celery backend used for the asynchronous job queue.
              '';
            };

            broker = lib.mkOption {
              type = with lib.types; nullOr str;
              default = lib.optionalString cfg.celery.enable "redis+socket://${config.services.redis.servers.pretalx.unixSocket}?virtual_host=2";
              defaultText = lib.literalExpression ''
                optionalString config.services.pretalx.celery.enable "redis+socket://''${config.services.redis.servers.pretalx.unixSocket}?virtual_host=2"
              '';
              description = ''
                URI to the celery broker used for the asynchronous job queue.
              '';
            };
          };

          redis = {
            location = lib.mkOption {
              type = with lib.types; nullOr str;
              default = "unix://${config.services.redis.servers.pretalx.unixSocket}?db=0";
              defaultText = lib.literalExpression ''
                "unix://''${config.services.redis.servers.pretalx.unixSocket}?db=0"
              '';
              description = ''
                URI to the redis server, used to speed up locking, caching and session storage.
              '';
            };

            session = lib.mkOption {
              type = lib.types.bool;
              default = true;
              example = false;
              description = ''
                Whether to use redis as the session storage.
              '';
            };
          };

          site = {
            url = lib.mkOption {
              type = lib.types.str;
              default = "https://${cfg.nginx.domain}";
              defaultText = lib.literalExpression "https://\${config.services.pretalx.nginx.domain}";
              example = "https://talks.example.com";
              description = ''
                The base URI below which your pretalx instance will be reachable.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        pretalx configuration as a Nix attribute set. All settings can also be passed
        from the environment.

        See <https://docs.pretalx.org/administrator/configure.html> for possible options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # https://docs.pretalx.org/administrator/installation.html

    environment.systemPackages = [
      (pkgs.writeScriptBin "pretalx-manage" ''
        cd ${cfg.settings.filesystem.data}
        sudo=exec
        if [[ "$USER" != ${cfg.user} ]]; then
          sudo='exec /run/wrappers/bin/sudo -u ${cfg.user} --preserve-env=PRETALX_CONFIG_FILE'
        fi
        export PRETALX_CONFIG_FILE=${configFile}
        $sudo ${lib.getExe' pythonEnv "pretalx-manage"} "$@"
      '')
    ];

    services = {
      nginx = lib.mkIf cfg.nginx.enable {
        enable = true;
        recommendedGzipSettings = lib.mkDefault true;
        recommendedOptimisation = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;
        recommendedTlsSettings = lib.mkDefault true;
        upstreams.pretalx.servers."unix:/run/pretalx/pretalx.sock" = { };
        virtualHosts.${cfg.nginx.domain} = {
          # https://docs.pretalx.org/administrator/installation.html#step-7-ssl
          extraConfig = ''
            more_set_headers "Referrer-Policy: same-origin";
            more_set_headers "X-Content-Type-Options: nosniff";
          '';
          locations = {
            "/".proxyPass = "http://pretalx";
            "/media/" = {
              alias = "${cfg.settings.filesystem.data}/media/";
              extraConfig = ''
                access_log off;
                more_set_headers 'Content-Disposition: attachment; filename="$1"';
                expires 7d;
              '';
            };
            "/static/" = {
              alias = cfg.settings.filesystem.static;
              extraConfig = ''
                access_log off;
                more_set_headers Cache-Control "public";
                expires 365d;
              '';
            };
          };
        };
      };

      postgresql = lib.mkIf (cfg.database.createLocally && cfg.settings.database.backend == "postgresql") {
        enable = true;
        ensureUsers = [ {
          name = cfg.settings.database.user;
          ensureDBOwnership = true;
        } ];
        ensureDatabases = [ cfg.settings.database.name ];
      };

      redis.servers.pretalx.enable = true;
    };

    systemd.services = let
      commonUnitConfig = {
        environment.PRETALX_CONFIG_FILE = configFile;
        serviceConfig = {
          User = "pretalx";
          Group = "pretalx";
          StateDirectory = [
            "pretalx"
            "pretalx/media"
          ];
          StateDirectoryMode = "0750";
          LogsDirectory = "pretalx";
          WorkingDirectory = cfg.settings.filesystem.data;
          SupplementaryGroups = [ "redis-pretalx" ];
          AmbientCapabilities = "";
          CapabilityBoundingSet = [ "" ];
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProcSubset = "pid";
          ProtectControlGroups = true;
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
            "~@privileged"
            "@chown"
          ];
          UMask = "0027";
        };
      };
    in {
      pretalx-web = lib.recursiveUpdate commonUnitConfig {
        description = "pretalx web service";
        after = [
          "network.target"
          "redis-pretalx.service"
        ] ++ lib.optionals (cfg.settings.database.backend == "postgresql") [
          "postgresql.service"
        ] ++ lib.optionals (cfg.settings.database.backend == "mysql") [
          "mysql.service"
        ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          versionFile="${cfg.settings.filesystem.data}/.version"
          version=$(cat "$versionFile" 2>/dev/null || echo 0)

          if [[ $version != ${cfg.package.version} ]]; then
            ${lib.getExe' pythonEnv "pretalx-manage"} migrate

            echo "${cfg.package.version}" > "$versionFile"
          fi
        '';
        serviceConfig = {
          ExecStart = "${lib.getExe' pythonEnv "gunicorn"} --bind unix:/run/pretalx/pretalx.sock ${cfg.gunicorn.extraArgs} pretalx.wsgi";
          RuntimeDirectory = "pretalx";
        };
      };

      pretalx-periodic = lib.recursiveUpdate commonUnitConfig {
        description = "pretalx periodic task runner";
        # every 15 minutes
        startAt = [ "*:3,18,33,48" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe' pythonEnv "pretalx-manage"} runperiodic";
        };
      };

      pretalx-clear-sessions = lib.recursiveUpdate commonUnitConfig {
        description = "pretalx session pruning";
        startAt = [ "monthly" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe' pythonEnv "pretalx-manage"} clearsessions";
        };
      };

      pretalx-worker = lib.mkIf cfg.celery.enable (lib.recursiveUpdate commonUnitConfig {
        description = "pretalx asynchronous job runner";
        after = [
          "network.target"
          "redis-pretalx.service"
        ] ++ lib.optionals (cfg.settings.database.backend == "postgresql") [
          "postgresql.service"
        ] ++ lib.optionals (cfg.settings.database.backend == "mysql") [
          "mysql.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${lib.getExe' pythonEnv "celery"} -A pretalx.celery_app worker ${cfg.celery.extraArgs}";
      });

      nginx.serviceConfig.SupplementaryGroups = lib.mkIf cfg.nginx.enable [ "pretalx" ];
    };

    systemd.sockets.pretalx-web.socketConfig = {
      ListenStream = "/run/pretalx/pretalx.sock";
      SocketUser = "nginx";
    };

    users = {
      groups.${cfg.group} = {};
      users.${cfg.user} = {
        isSystemUser = true;
        inherit (cfg) group;
      };
    };
  };
}
