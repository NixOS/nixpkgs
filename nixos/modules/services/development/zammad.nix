{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.zammad;
  settingsFormat = pkgs.formats.yaml { };
  filterNull = lib.filterAttrs (_: v: v != null);
  serviceConfig = {
    Type = "simple";
    Restart = "always";

    User = cfg.user;
    Group = cfg.group;
    PrivateTmp = true;
    StateDirectory = "zammad";
    WorkingDirectory = package;
  };
  environment = {
    RAILS_ENV = "production";
    NODE_ENV = "production";
    RAILS_SERVE_STATIC_FILES = "true";
    RAILS_LOG_TO_STDOUT = "true";
    REDIS_URL = "redis://${cfg.redis.host}:${toString cfg.redis.port}";
  };
  databaseConfig = settingsFormat.generate "database.yml" cfg.database.settings;
  package = cfg.package.override {
    dataDir = cfg.dataDir;
  };
in
{
  options = {
    services.zammad = {
      enable = lib.mkEnableOption "Zammad, a web-based, open source user support/ticketing solution";

      package = lib.mkPackageOption pkgs "zammad" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "zammad";
        description = ''
          Name of the Zammad user.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "zammad";
        description = ''
          Name of the Zammad group.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/zammad";
        description = ''
          Path to a folder that will contain Zammad working directory.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "192.168.23.42";
        description = "Host address.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Web service port.";
      };

      websocketPort = lib.mkOption {
        type = lib.types.port;
        default = 6042;
        description = "Websocket service port.";
      };

      redis = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to create a local redis automatically.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "zammad";
          description = ''
            Name of the redis server. Only used if `createLocally` is set to true.
          '';
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = ''
            Redis server address.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 6379;
          description = "Port of the redis server.";
        };
      };

      database = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "/run/postgresql";
          description = ''
            Database host address.
          '';
        };

        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = null;
          description = "Database port. Use `null` for default port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "zammad";
          description = ''
            Database name.
          '';
        };

        user = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "zammad";
          description = "Database user.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/zammad-dbpassword";
          description = ''
            A file containing the password for {option}`services.zammad.database.user`.
          '';
        };

        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
        };

        settings = lib.mkOption {
          type = settingsFormat.type;
          default = { };
          example = lib.literalExpression ''
            {
            }
          '';
          description = ''
            The {file}`database.yml` configuration file as key value set.
            See \<TODO\>
            for list of configuration parameters.
          '';
        };
      };

      nginx = {
        configure = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to configure a local nginx for Zammad.";
        };

        domain = lib.mkOption {
          type = lib.types.str;
          description = "The domain under which zammad will be reachable.";
        };
      };

      secretKeyBaseFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/secret_key_base";
        description = ''
          The path to a file containing the
          `secret_key_base` secret.

          Zammad uses `secret_key_base` to encrypt
          the cookie store, which contains session data, and to digest
          user auth tokens.

          Needs to be a 64 byte long string of hexadecimal
          characters. You can generate one by running

          ```
          openssl rand -hex 64 >/path/to/secret_key_base_file
          ```

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "zammad"
      "openPorts"
    ] "The openPorts option was removed in favor of the nginx.configure option.")
  ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # we try to eumulate parts of the pkgr script that are relevant to NixOS
      (pkgs.writeShellScriptBin "zammad" ''
        if [[ ''${1:-} != run ]]; then
          echo "This script only supports the run subcommand".
          exit 1
        fi
        shift

        prog="$1"
        shift
        sudo -u ${cfg.user} -- env ${
          lib.concatMapAttrsStringSep " " (n: v: "${n}=${v}") environment
        } bash -c "cd ${cfg.package}; ${cfg.package}/bin/$prog $(printf " %q" "$@")"
      '')
    ];

    services.zammad.database.settings = {
      production = lib.mapAttrs (_: v: lib.mkDefault v) (filterNull {
        adapter = "postgresql";
        database = cfg.database.name;
        pool = 50;
        timeout = 5000;
        encoding = "utf8";
        username = cfg.database.user;
        host = cfg.database.host;
        port = cfg.database.port;
      });
    };

    users.users.${cfg.user} = {
      group = "${cfg.group}";
      isSystemUser = true;
    };

    users.groups.${cfg.group} = { };

    assertions = [
      {
        assertion =
          cfg.database.createLocally -> cfg.database.user == "zammad" && cfg.database.name == "zammad";
        message = "services.zammad.database.user must be set to \"zammad\" if services.zammad.database.createLocally is set to true";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.zammad.database.createLocally is set to true";
      }
      {
        assertion = cfg.redis.createLocally -> cfg.redis.host == "localhost";
        message = "the redis host must be localhost if services.zammad.redis.createLocally is set to true";
      }
    ];

    services = {
      nginx = lib.mkIf cfg.nginx.configure {
        enable = true;
        virtualHosts."${cfg.nginx.domain}" = {
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.zammad.port}";
              root = "${config.services.zammad.package}/public/";
              extraConfig = # nginx
                ''
                  proxy_set_header CLIENT_IP $remote_addr;
                '';
            };
            "/cable" = {
              proxyPass = "http://127.0.0.1:${toString config.services.zammad.port}";
              proxyWebsockets = true;
              extraConfig = # nginx
                ''
                  proxy_set_header CLIENT_IP $remote_addr;
                '';
            };
            "/ws" = {
              proxyPass = "http://127.0.0.1:${toString config.services.zammad.websocketPort}";
              proxyWebsockets = true;
              extraConfig = # nginx
                ''
                  proxy_set_header CLIENT_IP $remote_addr;
                '';
            };
          };
        };
      };

      postgresql = lib.optionalAttrs cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensureDBOwnership = true;
          }
        ];
      };

      redis = lib.optionalAttrs cfg.redis.createLocally {
        servers."${cfg.redis.name}" = {
          enable = true;
          port = cfg.redis.port;
        };
      };
    };

    systemd.services.zammad-web = {
      inherit environment;
      serviceConfig = serviceConfig // {
        # loading all the gems takes time
        TimeoutStartSec = 1200;
      };
      after = [
        "network.target"
        "systemd-tmpfiles-setup.service"
      ]
      ++ lib.optionals cfg.database.createLocally [
        "postgresql.target"
      ]
      ++ lib.optionals cfg.redis.createLocally [
        "redis-${cfg.redis.name}.service"
      ];
      requires = lib.optionals cfg.database.createLocally [
        "postgresql.target"
      ];
      description = "Zammad web";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        # config file
        cat ${databaseConfig} > ${cfg.dataDir}/config/database.yml
        ${lib.optionalString (cfg.database.passwordFile != null) ''
          {
            echo -n "  password: "
            cat ${cfg.database.passwordFile}
          } >> ${cfg.dataDir}/config/database.yml
        ''}
        ${lib.optionalString (cfg.secretKeyBaseFile != null) ''
          {
            echo "production: "
            echo -n "  secret_key_base: "
            cat ${cfg.secretKeyBaseFile}
          } > ${cfg.dataDir}/config/secrets.yml
        ''}

        # needed for cleanup
        shopt -s extglob

        # cleanup state directory from module before refactoring in
        # https://github.com/NixOS/nixpkgs/pull/277456
        if [[ -e ${cfg.dataDir}/node_modules ]]; then
          rm -rf ${cfg.dataDir}/!("tmp"|"config"|"log"|"state_dir_migrated"|"db_seeded"|"storage")
          rm -rf ${cfg.dataDir}/config/!("database.yml"|"secrets.yml")
          # state directory cleanup required --> zammad was already installed --> do not seed db
          echo true > ${cfg.dataDir}/db_seeded
        fi

        SEEDED=$(cat ${cfg.dataDir}/db_seeded)
        if [[ $SEEDED != "true" ]]; then
          echo "Initialize database"
          ./bin/rake --no-system db:migrate
          ./bin/rake --no-system db:seed
          echo true > ${cfg.dataDir}/db_seeded
        else
          echo "Migrate database"
          ./bin/rake --no-system db:migrate
        fi
        echo "Done"
      '';
      script = "./script/rails server -b ${cfg.host} -p ${toString cfg.port}";
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                               0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/config                        0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/log                           0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage                       0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/tmp                           0750 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/config/secrets.yml            0640 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/config/database.yml           0640 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/db_seeded                     0640 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.zammad-websocket = {
      inherit serviceConfig environment;
      after = [ "zammad-web.service" ];
      requires = [ "zammad-web.service" ];
      description = "Zammad websocket";
      wantedBy = [ "multi-user.target" ];
      script = "./script/websocket-server.rb -b ${cfg.host} -p ${toString cfg.websocketPort} start";
    };

    systemd.services.zammad-worker = {
      inherit serviceConfig environment;
      after = [ "zammad-web.service" ];
      requires = [ "zammad-web.service" ];
      description = "Zammad background worker";
      wantedBy = [ "multi-user.target" ];
      script = "./script/background-worker.rb start";
    };
  };

  meta.maintainers = with lib.maintainers; [
    taeer
    netali
  ];
}
