{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.c3nav;
  format = pkgs.formats.ini { };

  configFile = format.generate "c3nav.cfg" cfg.settings;

  pythonEnv = cfg.package.pythonPackages.python.buildEnv.override {
    extraLibs = with cfg.package.pythonPackages; [
      (toPythonModule cfg.package)
      gunicorn
    ];
  };

  commonEnvironment = {
    C3NAV_CONFIG = configFile;
    C3NAV_DATA_DIR = cfg.settings.filesystem.data;
    C3NAV_VERSION = cfg.package.version;
  };

  c3navManageWrapper = pkgs.writeShellApplication {
    name = "c3nav-manage";
    runtimeInputs = with pkgs; [
      util-linux
    ];
    text = ''
      cd ${cfg.settings.filesystem.data}
      set -a
      ${lib.concatMapStringsSep "\n" (file: ''
        . ${lib.escapeShellArg file}
      '') cfg.environmentFiles}
      set +a
      ${lib.concatMapAttrsStringSep "\n" (n: v: "export ${n}=${v}") commonEnvironment}
      exec runuser ${
        lib.cli.toCommandLineShellGNU { } {
          inherit (cfg) user;
          preserve-environment = true;
        }
      } -- ${lib.getExe' pythonEnv "c3nav-manage"} "$@"
    '';
    excludeShellChecks = [
      # Not following: /run/agenix/c3nav-env was not specified as input
      "SC1091"
    ];
  };
in

{
  meta.maintainers = pkgs.c3nav.meta.maintainers;

  options.services.c3nav = {
    enable = lib.mkEnableOption "c3nav";

    package = lib.mkPackageOption pkgs "c3nav" { };

    environmentFiles = lib.mkOption {
      description = ''
        Environment files that allow passing secret configuration values.

        Each line must follow the `C3NAV_SECTION_KEY=value` pattern.
      '';
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/c3nav/env" ];
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "c3nav";
      description = "Group under which c3nav should run.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "c3nav";
      description = "User under which c3nav should run.";
    };

    gunicorn.extraArgs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "--name=c3nav"
      ];
      example = [
        "--name=c3nav"
        "--workers=4"
        "--max-requests=1200"
        "--max-requests-jitter=50"
        "--log-level=info"
      ];
      description = ''
        Extra arguments to pass to gunicorn.
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
        example = "maps.example.com";
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

                Currently only PostgreSQL gets tested, and as such we don't support any other Database.
              '';
              readOnly = true; # only postgres supported right now
            };

            host = lib.mkOption {
              type = with lib.types; nullOr types.path;
              default = if cfg.settings.database.backend == "postgresql" then "/run/postgresql" else null;
              defaultText = lib.literalExpression ''
                if config.services.c3nav.settings..database.backend == "postgresql" then "/run/postgresql"
                else null
              '';
              description = ''
                Database host or socket path.
              '';
            };

            name = lib.mkOption {
              type = lib.types.str;
              default = "c3nav";
              description = ''
                Database name.
              '';
            };

            user = lib.mkOption {
              type = lib.types.str;
              default = "c3nav";
              description = ''
                Database username.
              '';
            };
          };

          files = {
            upload_limit = lib.mkOption {
              type = lib.types.ints.positive;
              default = 10;
              example = 50;
              description = ''
                Maximum file upload size in MiB.
              '';
            };
          };

          filesystem = {
            data = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/c3nav";
              description = ''
                Base path for all other storage paths.
              '';
            };
            logs = lib.mkOption {
              type = lib.types.path;
              default = "/var/log/c3nav";
              description = ''
                Path to the log directory, that c3nav logs message to.
              '';
            };
            static = lib.mkOption {
              type = lib.types.path;
              default = "${cfg.package}/${cfg.package.pythonPackages.python.sitePackages}/c3nav/static.dist/";
              defaultText = "\${config.services.c3nav.package}/\${config.services.c3nav.package.pythonPackages.python.sitePackages}/c3nav/static.dist/";
              readOnly = true;
              description = ''
                Path to the directory that contains static files.
              '';
            };
          };

          celery = {
            backend = lib.mkOption {
              type = with lib.types; nullOr str;
              default = lib.optionalString cfg.celery.enable "redis+socket://${config.services.redis.servers.c3nav.unixSocket}?virtual_host=1";
              defaultText = lib.literalExpression ''
                optionalString config.services.c3nav.celery.enable "redis+socket://''${config.services.redis.servers.c3nav.unixSocket}?virtual_host=1"
              '';
              description = ''
                URI to the celery backend used for the asynchronous job queue.
              '';
            };

            broker = lib.mkOption {
              type = with lib.types; nullOr str;
              default = lib.optionalString cfg.celery.enable "redis+socket://${config.services.redis.servers.c3nav.unixSocket}?virtual_host=2";
              defaultText = lib.literalExpression ''
                optionalString config.services.c3nav.celery.enable "redis+socket://''${config.services.redis.servers.c3nav.unixSocket}?virtual_host=2"
              '';
              description = ''
                URI to the celery broker used for the asynchronous job queue.
              '';
            };
          };

          redis = {
            location = lib.mkOption {
              type = with lib.types; nullOr str;
              default = "unix://${config.services.redis.servers.c3nav.unixSocket}?db=0";
              defaultText = lib.literalExpression ''
                "unix://''${config.services.redis.servers.c3nav.unixSocket}?db=0"
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
              defaultText = lib.literalExpression "https://\${config.services.c3nav.nginx.domain}";
              example = "https://talks.example.com";
              description = ''
                The base URI below which your c3nav instance will be reachable.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        C3nav configuration as a Nix attribute set. All settings can also be passed
        from the environment.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      c3navManageWrapper
    ];

    services.logrotate.settings.c3nav = {
      files = "${cfg.settings.filesystem.logs}/*.log";
      su = "${cfg.user} ${cfg.group}";
      frequency = "weekly";
      rotate = "12";
      copytruncate = true;
      compress = true;
    };

    services = {
      nginx = lib.mkIf cfg.nginx.enable {
        enable = true;
        recommendedGzipSettings = lib.mkDefault true;
        recommendedOptimisation = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;
        recommendedTlsSettings = lib.mkDefault true;
        upstreams.c3nav.servers."unix:/run/c3nav/c3nav.sock" = { };
        virtualHosts.${cfg.nginx.domain} = {
          extraConfig = ''
            more_set_headers "Referrer-Policy: same-origin";
            more_set_headers "X-Content-Type-Options: nosniff";
          '';
          locations = {
            "/".proxyPass = "http://c3nav";
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

      postgresql =
        lib.mkIf (cfg.database.createLocally && cfg.settings.database.backend == "postgresql")
          {
            enable = true;
            ensureUsers = [
              {
                name = cfg.settings.database.user;
                ensureDBOwnership = true;
              }
            ];
            ensureDatabases = [ cfg.settings.database.name ];
          };

      redis.servers.c3nav.enable = true;
    };

    systemd.services =
      let
        commonUnitConfig = {
          environment = commonEnvironment;
          serviceConfig = {
            User = "c3nav";
            Group = "c3nav";
            EnvironmentFile = cfg.environmentFiles;
            StateDirectory = [ "c3nav" ];
            StateDirectoryMode = "0750";
            LogsDirectory = "c3nav";
            WorkingDirectory = cfg.settings.filesystem.data;
            SupplementaryGroups = [ "redis-c3nav" ];
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
      in
      {
        c3nav-web = lib.recursiveUpdate commonUnitConfig {
          description = "c3nav web service";
          after = [
            "network.target"
            "redis-c3nav.service"
          ]
          ++ lib.optionals (cfg.settings.database.backend == "postgresql") [
            "postgresql.target"
          ];
          wantedBy = [ "multi-user.target" ];
          preStart =
            let
              versionString = "c3nav-${cfg.package.version}";
            in
            ''
              versionFile="${cfg.settings.filesystem.data}/.version"
              version="$(cat "$versionFile" 2>/dev/null || echo 0)"

              if [[ "$version" != "${versionString}" ]]; then
                ${lib.getExe' pythonEnv "c3nav-manage"} migrate

                echo "${versionString}" > "$versionFile"
              fi
            '';
          serviceConfig = {
            ExecStart = "${lib.getExe' pythonEnv "gunicorn"} --bind unix:/run/c3nav/c3nav.sock ${cfg.gunicorn.extraArgs} c3nav.wsgi";
            RuntimeDirectory = "c3nav";
          };
        };

        c3nav-clear-sessions = lib.recursiveUpdate commonUnitConfig {
          description = "c3nav session pruning";
          startAt = [ "monthly" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${lib.getExe' pythonEnv "c3nav-manage"} clearsessions";
          };
        };

        c3nav-worker = lib.mkIf cfg.celery.enable (
          lib.recursiveUpdate commonUnitConfig {
            description = "c3nav asynchronous job runner";
            after = [
              "network.target"
              "redis-c3nav.service"
            ]
            ++ lib.optionals (cfg.settings.database.backend == "postgresql") [
              "postgresql.target"
            ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig.ExecStart = "${lib.getExe' pythonEnv "celery"} -A c3nav.celery worker ${cfg.celery.extraArgs}";
          }
        );

        nginx.serviceConfig.SupplementaryGroups = lib.mkIf cfg.nginx.enable [ "c3nav" ];
      };

    systemd.sockets.c3nav-web.socketConfig = {
      ListenStream = "/run/c3nav/c3nav.sock";
      SocketUser = "nginx";
    };

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        isSystemUser = true;
        inherit (cfg) group;
      };
    };
  };
}
