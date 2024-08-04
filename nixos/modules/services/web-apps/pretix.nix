{ config
, lib
, pkgs
, utils
, ...
}:

let
  inherit (lib)
    concatMapStringsSep
    escapeShellArgs
    filter
    filterAttrs
    getExe
    getExe'
    isAttrs
    isList
    literalExpression
    mapAttrs
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionals
    optionalString
    recursiveUpdate
    types
  ;

  filterRecursiveNull = o:
    if isAttrs o then
      mapAttrs (_: v: filterRecursiveNull v) (filterAttrs (_: v: v != null) o)
    else if isList o then
      map filterRecursiveNull (filter (v: v != null) o)
    else
      o;

  cfg = config.services.pretix;
  format = pkgs.formats.ini { };

  configFile = format.generate "pretix.cfg" (filterRecursiveNull cfg.settings);

  finalPackage = cfg.package.override {
    inherit (cfg) plugins;
  };

  pythonEnv = cfg.package.python.buildEnv.override {
    extraLibs = with cfg.package.python.pkgs; [
      (toPythonModule finalPackage)
      gunicorn
    ]
    ++ lib.optionals (cfg.settings.memcached.location != null)
      cfg.package.optional-dependencies.memcached
    ;
  };

  withRedis = cfg.settings.redis.location != null;
in
{
  meta = with lib; {
    maintainers = with maintainers; [ hexa ];
  };

  options.services.pretix = {
    enable = mkEnableOption "Pretix, a ticket shop application for conferences, festivals, concerts, etc";

    package = mkPackageOption pkgs "pretix" { };

    group = mkOption {
      type = types.str;
      default = "pretix";
      description = ''
        Group under which pretix should run.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "pretix";
      description = ''
        User under which pretix should run.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/keys/pretix-secrets.env";
      description = ''
        Environment file to pass secret configuration values.

        Each line must follow the `PRETIX_SECTION_KEY=value` pattern.
      '';
    };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression ''
        with config.services.pretix.package.plugins; [
          passbook
          pages
        ];
      '';
      description = ''
        Pretix plugins to install into the Python environment.
      '';
    };

    gunicorn.extraArgs = mkOption {
      type = with types; listOf str;
      default = [
        "--name=pretix"
      ];
      example = [
        "--name=pretix"
        "--workers=4"
        "--max-requests=1200"
        "--max-requests-jitter=50"
        "--log-level=info"
      ];
      description = ''
        Extra arguments to pass to gunicorn.
        See <https://docs.pretix.eu/en/latest/admin/installation/manual_smallscale.html#start-pretix-as-a-service> for details.
      '';
      apply = escapeShellArgs;
    };

    celery = {
      extraArgs = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = ''
          Extra arguments to pass to celery.

          See <https://docs.celeryq.dev/en/stable/reference/cli.html#celery-worker> for more info.
        '';
        apply = utils.escapeSystemdExecArgs;
      };
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether to set up an nginx virtual host.
        '';
      };

      domain = mkOption {
        type = types.str;
        example = "talks.example.com";
        description = ''
          The domain name under which to set up the virtual host.
        '';
      };
    };

    database.createLocally = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = ''
        Whether to automatically set up the database on the local DBMS instance.

        Only supported for PostgreSQL. Not required for sqlite.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
        options = {
          pretix = {
            instance_name = mkOption {
              type = types.str;
              example = "tickets.example.com";
              description = ''
                The name of this installation.
              '';
            };

            url = mkOption {
              type = types.str;
              example = "https://tickets.example.com";
              description = ''
                The installation’s full URL, without a trailing slash.
              '';
            };

            cachedir = mkOption {
              type = types.path;
              default = "/var/cache/pretix";
              description = ''
                Directory for storing temporary files.
              '';
            };

            datadir = mkOption {
              type = types.path;
              default = "/var/lib/pretix";
              description = ''
                Directory for storing user uploads and similar data.
              '';
            };

            logdir = mkOption {
              type = types.path;
              default = "/var/log/pretix";
              description = ''
                Directory for storing log files.
              '';
            };

            currency = mkOption {
              type = types.str;
              default = "EUR";
              example = "USD";
              description = ''
                Default currency for events in its ISO 4217 three-letter code.
              '';
            };

            registration = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = ''
                Whether to allow registration of new admin users.
              '';
            };
          };

          database = {
            backend = mkOption {
              type = types.enum [
                "sqlite3"
                "postgresql"
              ];
              default = "postgresql";
              description = ''
                Database backend to use.

                Only postgresql is recommended for production setups.
              '';
            };

            host = mkOption {
              type = with types; nullOr path;
              default = if cfg.settings.database.backend == "postgresql" then "/run/postgresql" else null;
              defaultText = literalExpression ''
                if config.services.pretix.settings..database.backend == "postgresql" then "/run/postgresql"
                else null
              '';
              description = ''
                Database host or socket path.
              '';
            };

            name = mkOption {
              type = types.str;
              default = "pretix";
              description = ''
                Database name.
              '';
            };

            user = mkOption {
              type = types.str;
              default = "pretix";
              description = ''
                Database username.
              '';
            };
          };

          mail = {
            from = mkOption {
              type = types.str;
              example = "tickets@example.com";
              description = ''
                E-Mail address used in the `FROM` header of outgoing mails.
              '';
            };

            host = mkOption {
              type = types.str;
              default = "localhost";
              example = "mail.example.com";
              description = ''
                Hostname of the SMTP server use for mail delivery.
              '';
            };

            port = mkOption {
              type = types.port;
              default = 25;
              example = 587;
              description = ''
                Port of the SMTP server to use for mail delivery.
              '';
            };
          };

          celery = {
            backend = mkOption {
              type = types.str;
              default = "redis+socket://${config.services.redis.servers.pretix.unixSocket}?virtual_host=1";
              defaultText = literalExpression ''
                redis+socket://''${config.services.redis.servers.pretix.unixSocket}?virtual_host=1
              '';
              description = ''
                URI to the celery backend used for the asynchronous job queue.
              '';
            };

            broker = mkOption {
              type = types.str;
              default = "redis+socket://${config.services.redis.servers.pretix.unixSocket}?virtual_host=2";
              defaultText = literalExpression ''
                redis+socket://''${config.services.redis.servers.pretix.unixSocket}?virtual_host=2
              '';
              description = ''
                URI to the celery broker used for the asynchronous job queue.
              '';
            };
          };

          redis = {
            location = mkOption {
              type = with types; nullOr str;
              default = "unix://${config.services.redis.servers.pretix.unixSocket}?db=0";
              defaultText = literalExpression ''
                "unix://''${config.services.redis.servers.pretix.unixSocket}?db=0"
              '';
              description = ''
                URI to the redis server, used to speed up locking, caching and session storage.
              '';
            };

            sessions = mkOption {
              type = types.bool;
              default = true;
              example = false;
              description = ''
                Whether to use redis as the session storage.
              '';
            };
          };

          memcached = {
            location = mkOption {
              type = with types; nullOr str;
              default = null;
              example = "127.0.0.1:11211";
              description = ''
                The `host:port` combination or the path to the UNIX socket of a memcached instance.

                Can be used instead of Redis for caching.
              '';
            };
          };

          tools = {
            pdftk = mkOption {
              type = types.path;
              default = getExe pkgs.pdftk;
              defaultText = literalExpression ''
                lib.getExe pkgs.pdftk
              '';
              description = ''
                Path to the pdftk executable.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        pretix configuration as a Nix attribute set. All settings can also be passed
        from the environment.

        See <https://docs.pretix.eu/en/latest/admin/config.html> for possible options.
      '';
    };
  };

  config = mkIf cfg.enable {
    # https://docs.pretix.eu/en/latest/admin/installation/index.html

    environment.systemPackages = [
      (pkgs.writeScriptBin "pretix-manage" ''
        cd ${cfg.settings.pretix.datadir}
        sudo=exec
        if [[ "$USER" != ${cfg.user} ]]; then
          sudo='exec /run/wrappers/bin/sudo -u ${cfg.user} ${optionalString withRedis "-g redis-pretix"} --preserve-env=PRETIX_CONFIG_FILE'
        fi
        export PRETIX_CONFIG_FILE=${configFile}
        $sudo ${getExe' pythonEnv "pretix-manage"} "$@"
      '')
    ];

    services = {
      nginx = mkIf cfg.nginx.enable {
        enable = true;
        recommendedGzipSettings = mkDefault true;
        recommendedOptimisation = mkDefault true;
        recommendedProxySettings = mkDefault true;
        recommendedTlsSettings = mkDefault true;
        upstreams.pretix.servers."unix:/run/pretix/pretix.sock" = { };
        virtualHosts.${cfg.nginx.domain} = {
          # https://docs.pretix.eu/en/latest/admin/installation/manual_smallscale.html#ssl
          extraConfig = ''
            more_set_headers Referrer-Policy same-origin;
            more_set_headers X-Content-Type-Options nosniff;
          '';
          locations = {
            "/".proxyPass = "http://pretix";
            "/media/" = {
              alias = "${cfg.settings.pretix.datadir}/media/";
              extraConfig = ''
                access_log off;
                expires 7d;
              '';
            };
            "^~ /media/(cachedfiles|invoices)" = {
              extraConfig = ''
                deny all;
                return 404;
              '';
            };
            "/static/" = {
              alias = "${finalPackage}/${cfg.package.python.sitePackages}/pretix/static.dist/";
              extraConfig = ''
                access_log off;
                more_set_headers Cache-Control "public";
                expires 365d;
              '';
            };
          };
        };
      };

      postgresql = mkIf (cfg.database.createLocally && cfg.settings.database.backend == "postgresql") {
        enable = true;
        ensureUsers = [ {
          name = cfg.settings.database.user;
          ensureDBOwnership = true;
        } ];
        ensureDatabases = [ cfg.settings.database.name ];
      };

      redis.servers.pretix.enable = withRedis;
    };

    systemd.services = let
      commonUnitConfig = {
        environment.PRETIX_CONFIG_FILE = configFile;
        serviceConfig = {
          User = "pretix";
          Group = "pretix";
          EnvironmentFile = optionals (cfg.environmentFile != null) [
            cfg.environmentFile
          ];
          StateDirectory = [
            "pretix"
          ];
          StateDirectoryMode = "0750";
          CacheDirectory = "pretix";
          LogsDirectory = "pretix";
          WorkingDirectory = cfg.settings.pretix.datadir;
          SupplementaryGroups = optionals withRedis [
            "redis-pretix"
          ];
          AmbientCapabilities = "";
          CapabilityBoundingSet = [ "" ];
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = false; # required by pdftk
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
      pretix-web = recursiveUpdate commonUnitConfig {
        description = "pretix web service";
        after = [
          "network.target"
          "redis-pretix.service"
          "postgresql.service"
        ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          versionFile="${cfg.settings.pretix.datadir}/.version"
          version=$(cat "$versionFile" 2>/dev/null || echo 0)

          pluginsFile="${cfg.settings.pretix.datadir}/.plugins"
          plugins=$(cat "$pluginsFile" 2>/dev/null || echo "")
          configuredPlugins="${concatMapStringsSep "|" (package: package.name) cfg.plugins}"

          if [[ $version != ${cfg.package.version} || $plugins != $configuredPlugins ]]; then
            ${getExe' pythonEnv "pretix-manage"} migrate

            echo "${cfg.package.version}" > "$versionFile"
            echo "$configuredPlugins" > "$pluginsFile"
          fi
        '';
        serviceConfig = {
          TimeoutStartSec = "15min";
          ExecStart = "${getExe' pythonEnv "gunicorn"} --bind unix:/run/pretix/pretix.sock ${cfg.gunicorn.extraArgs} pretix.wsgi";
          RuntimeDirectory = "pretix";
        };
      };

      pretix-periodic = recursiveUpdate commonUnitConfig {
        description = "pretix periodic task runner";
        # every 15 minutes
        startAt = [ "*:3,18,33,48" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${getExe' pythonEnv "pretix-manage"} runperiodic";
        };
      };

      pretix-worker = recursiveUpdate commonUnitConfig {
        description = "pretix asynchronous job runner";
        after = [
          "network.target"
          "redis-pretix.service"
          "postgresql.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${getExe' pythonEnv "celery"} -A pretix.celery_app worker ${cfg.celery.extraArgs}";
      };

      nginx.serviceConfig.SupplementaryGroups = mkIf cfg.nginx.enable [ "pretix" ];
    };

    systemd.sockets.pretix-web.socketConfig = {
      ListenStream = "/run/pretix/pretix.sock";
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
