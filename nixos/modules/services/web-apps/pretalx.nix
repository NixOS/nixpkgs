{ config
, options
, lib
, pkgs
, ...
}:

let
  cfg = config.services.pretalx;
  opt = options.services.pretalx;

  inherit (lib)
    escapeShellArgs
    literalExpression
    mdDoc
    mkDefault
    mkEnableOption
    mkIf
    mkPackageOptionMD
    mkOption
    optionalString
    recursiveUpdate
    types;

  format = pkgs.formats.ini {};

  extras = cfg.package.optional-dependencies.redis
    ++ lib.optionals (cfg.settings.database.backend == "mysql") cfg.package.optional-dependencies.mysql
    ++ lib.optionals (cfg.settings.database.backend == "postgresql") cfg.package.optional-dependencies.postgres;

  PYTHONPATH = "${cfg.package.PYTHONPATH}:${cfg.package.python.pkgs.makePythonPath extras}";
in

{
  meta = with lib; {
    maintainers = with maintainers; [ hexa ];
  };

  options.services.pretalx = with types; {
    enable = mkEnableOption (mdDoc "pretalx");

    package = mkPackageOptionMD pkgs "pretalx" {};

    gunicorn.extraArgs = mkOption {
      type = listOf str;
      default = [
        "--name=pretalx"
      ];
      example = [
        # https://docs.pretalx.org/administrator/installation.html#step-6-starting-pretalx-as-a-service
        "--name=pretalx"
        "--worker=4"
        "--max-requests=1200"
        "--max-requests-jitter=50"
        "--log-level=info"
      ];
      description = mdDoc ''
        Extra arguments to pass to gunicorn.
      '';
      apply = escapeShellArgs;
    };

    celery = {
      enable = mkOption {
        type = bool;
        default = true;
        example = false;
        description = mdDoc ''
          Whether to set up celery as an asynchronous task runner.
        '';
      };

      extraArgs = mkOption {
        type = listOf str;
        default = [ ];
        description = mdDoc ''
          Extra arguments to pass to celery.

          See <https://docs.celeryq.dev/en/stable/reference/cli.html#celery-worker> for more info.
        '';
        apply = escapeShellArgs;
      };
    };

    nginx = {
      enable = mkOption {
        type = bool;
        default = true;
        example = false;
        description = mdDoc ''
          Whether to set up an nginx virtual host.
        '';
      };

      domain = mkOption {
        type = str;
        example = "talks.example.com";
        description = mdDoc ''
          The domain name under which to set up the virtual host.
        '';
      };
    };

    database.createLocally = mkOption {
      type = bool;
      default = true;
      example = false;
      description = mdDoc ''
        Whether to automatically set up the database on the local DBMS instance.

        Currently only supported for PostgreSQL. Not required for sqlite.
      '';
    };

    settings = mkOption {
      type = submodule {
        freeformType = format.type;
        options = {
          database = {
            backend = mkOption {
              type = enum [
                "postgresql"
              ];
              default = "postgresql";
              description = mdDoc ''
                Database backend to use.

                Currently only PostgreSQL gets tested, and as such we don't support any other DBMS.
              '';
              readOnly = true; # only postgres supported right now
            };

            host = mkOption {
              type = nullOr types.path;
              default = if cfg.settings.database.backend == "postgresql" then "/run/postgresql"
                else if cfg.settings.database.backend == "mysql" then "/run/mysqld/mysqld.sock"
                else null;
              defaultText = literalExpression ''
                if config.${opt.settings}.database.backend == "postgresql" then "/run/postgresql"
                else if config.${opt.settings}.database.backend == "mysql" then "/run/mysqld/mysqld.sock"
                else null
              '';
              description = mdDoc ''
                Database host or socket path.
              '';
            };

            name = mkOption {
              type = str;
              default = "pretalx";
              description = mdDoc ''
                Database name.
              '';
            };

            user = mkOption {
              type = str;
              default = "pretalx";
              description = mdDoc ''
                Database username.
              '';
            };
          };

          filesystem = {
            data = mkOption {
              type = types.path;
              default = "/var/lib/pretalx";
              description = mdDoc ''
                Base path for all other storage paths.
              '';
            };
            logs = mkOption {
              type = types.path;
              default = "/var/log/pretalx";
              description = mdDoc ''
                Path to the log directory, that pretalx logs message to.
              '';
            };
            static = mkOption {
              type = types.path;
              default = "${cfg.package.static}/";
              defaultText = literalExpression "\${config.${opt.package}}.static}/";
              readOnly = true;
              description = mdDoc ''
                Path to the directory that contains static files.
              '';
            };
          };

          celery = {
            backend = mkOption {
              type = nullOr str;
              default = optionalString cfg.celery.enable "redis+socket://${config.services.redis.servers.pretalx.unixSocket}?virtual_host=1";
              defaultText = literalExpression ''
                optionalString config.${opt.celery.enable} "redis+socket://''${config.${options.services.redis.servers}.pretalx.unixSocket}?virtual_host=1"
              '';
              description = mdDoc ''
                URI to the celery backend used for the asynchronous job queue.
              '';
            };

            broker = mkOption {
              type = nullOr str;
              default = optionalString cfg.celery.enable "redis+socket://${config.services.redis.servers.pretalx.unixSocket}?virtual_host=2";
              defaultText = literalExpression ''
                optionalString config.${opt.celery.enable} "redis+socket://''${config.${options.services.redis.servers}.pretalx.unixSocket}?virtual_host=2"
              '';
              description = mdDoc ''
                URI to the celery broker used for the asynchronous job queue.
              '';
            };
          };

          redis = {
            location = mkOption {
              type = nullOr str;
              default = "unix://${config.services.redis.servers.pretalx.unixSocket}?db=0";
              defaultText = literalExpression ''
                "unix://''${config.${options.services.redis.servers}.pretalx.unixSocket}?db=0"
              '';
              description = mdDoc ''
                URI to the redis server, used to speed up locking, caching and session storage.
              '';
            };

            session = mkOption {
              type = bool;
              default = true;
              example = false;
              description = mdDoc ''
                Whether to use redis as the session storage.
              '';
            };
          };

          site = {
            url = mkOption {
              type = types.str;
              example = "https://talks.example.com";
              description = mdDoc ''
                The base URI below which your pretalx instance will be reachable.
              '';
            };
          };
        };
      };
      default = {};
      description = mdDoc ''
        pretalx configuration as a Nix attribute set. All settings can also be passed
        from the environment.

        See <https://docs.pretalx.org/administrator/configure.html> for possible options.
      '';
    };
  };

  config = mkIf cfg.enable {
    # https://docs.pretalx.org/administrator/installation.html

    services.postgresql = mkIf (cfg.database.createLocally && cfg.settings.database.backend == "postgresql") {
      ensureUsers = [ {
        name = cfg.settings.database.user;
        ensurePermissions = {
          "DATABASE ${cfg.settings.database.name}" = "ALL PRIVILEGES"; };
      } ];
      ensureDatabases = [ cfg.settings.database.name ];
    };

    services.redis.servers.pretalx.enable = true;

    services.nginx = mkIf cfg.nginx.enable {
      additionalModules = with pkgs.nginxModules; [
        moreheaders
      ];
      recommendedGzipSettings = mkDefault true;
      recommendedOptimisation = mkDefault true;
      recommendedProxySettings = mkDefault true;
      recommendedTlsSettings = mkDefault true;
      virtualHosts.${cfg.nginx.domain} = {
        # https://docs.pretalx.org/administrator/installation.html#step-7-ssl
        extraConfig = ''
          gzip off;
          more_set_headers Referrer-Policy same-origin;
          more_set_headers X-Content-Type-Options nosniff;
        '';
        locations."/" = {
          proxyPass = "http://unix:/run/pretalx/pretalx.sock";
        };
        locations."/media/" = {
          alias = "/var/lib/pretalx/data/media/";
          extraConfig = ''
            access_log off;
            more_set_headers Content-Disposition 'attachment; filename="$1"';
            expires 7d;
            gzip on;
          '';
        };
        locations."/static/" = {
          alias = cfg.settings.filesystem.static;
          extraConfig = ''
            access_log off;
            more_set_headers Cache-Control "public";
            expires 365d;
            gzip on;
          '';
        };
      };
    };

    systemd.services = let
      commonUnitConfig = {
        environment = {
          inherit PYTHONPATH;
          PRETALX_CONFIG_FILE = format.generate "pretalx.cfg" cfg.settings;
        };
        serviceConfig = {
          DynamicUser = true;
          User = "pretalx";
          Group = "pretalx";
          StateDirectory = "pretalx";
          LogsDirectory = "pretalx";
          WorkingDirectory = "/var/lib/pretalx";
          RuntimeDirectory = "pretalx";
          SupplementaryGroups = [
            "redis-pretalx"
          ];
        };
      };
    in {
      pretalx-web = recursiveUpdate {
        description = "pretalx web service";
        after = [
          "network.target"
          "redis-pretalx.service"
        ] ++ lib.optionals (cfg.settings.database.backend == "postgresql") [
          "postgresql.service"
        ] ++ lib.optionals (cfg.settings.database.backend == "mysql") [
          "mysql.service"
        ];
        wantedBy = [
          "multi-user.target"
        ];
        preStart = ''
          mkdir -p $STATE_DIRECTORY/media
          ln -sf ${cfg.package}/bin/pretalx-manage $STATE_DIRECTORY/pretalx-manage

          versionFile="$STATE_DIRECTORY/.version"
          version=$(cat "$versionFile" 2>/dev/null || echo 0)

          if [[ $version != ${cfg.package.version} ]]; then
            ${cfg.package.python.interpreter} -m pretalx migrate

            echo "${cfg.package.version}" > "$versionFile"
          fi

          echo "Run 'pretalx-manage init' to initialize your instance! Then log in at ${cfg.settings.site.url}/orga/."
        '';
        serviceConfig = {
          ExecStart = "${cfg.package.python.pkgs.gunicorn}/bin/gunicorn --bind unix:/run/pretalx/pretalx.sock ${cfg.gunicorn.extraArgs} pretalx.wsgi";
        };
      } commonUnitConfig;

      pretalx-periodic = recursiveUpdate {
        description = "pretalx periodic task runner";
        startAt = [
          # every 15 minutes
          "*:3,18,33,48"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package.python.interpreter} -m pretalx runperiodic";
        };
      } commonUnitConfig;

      pretalx-clear-sessions = recursiveUpdate {
        description = "pretalx session pruning";
        startAt = [
          "monthly"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package.python.interpreter} -m pretalx clearsessions";
        };
      } commonUnitConfig;

      pretalx-worker = mkIf cfg.celery.enable (recursiveUpdate {
        description = "pretalx asynchronous job runner";
        after = [
          "network.target"
          "redis-pretalx.service"
        ] ++ lib.optionals (cfg.settings.database.backend == "postgresql") [
          "postgresql.service"
        ] ++ lib.optionals (cfg.settings.database.backend == "mysql") [
          "mysql.service"
        ];
        wantedBy = [
          "multi-user.target"
        ];
        serviceConfig = {
          ExecStart = "${cfg.package.python.pkgs.celery}/bin/celery -A pretalx.celery_app worker ${cfg.celery.extraArgs}";
        };
      } commonUnitConfig);
    };
  };
}
