{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.roundcube;
  fpm = config.services.phpfpm.pools.roundcube;

  localDB = lib.hasPrefix "/" cfg.database.host;
  localPgsql = localDB && cfg.database.type == "pgsql";

  user = cfg.database.username;
  phpWithPspell = pkgs.php83.withExtensions ({ enabled, all }: [ all.pspell ] ++ enabled);

  commonEnv = {
    ASPELL_CONF = "dict-dir ${pkgs.aspellWithDicts (_: cfg.dicts)}/lib/aspell";
  };
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "roundcube" "database" "postgresql" "password" ] ''
      Use `services.roundcube.database.passwordFile` instead.

      As with all `password` options, it was insecure: the value was stored as world readable in the Nix store.
    '')
  ];

  options.services.roundcube = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable roundcube.

        Also enables nginx virtual host management.
        Further nginx configuration can be done by adapting `services.nginx.virtualHosts.<name>`.
        See [](#opt-services.nginx.virtualHosts) for further information.
      '';
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      example = "webmail.example.com";
      description = "Hostname to use for the nginx vhost";
    };

    package = lib.mkPackageOption pkgs "roundcube" {
      example = "roundcube.withPlugins (plugins: [ plugins.persistent_login ])";
    };

    database = {
      # TODO: support more DB types. The module started off as highly pgsql specific, and more work needs to be done
      #       to ensure other DB types work properly.
      type = lib.mkOption {
        type = lib.types.enum [
          "pgsql"
          "sqlite"
        ];
        default = "pgsql";
        description = ''
          The type of database to use.
        '';
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "roundcube";
        description = ''
          Username for the postgresql connection.

          If `configurePgsql` is true, a unix user and group of the same name will be created as well.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          Host of the database server, or database file path when using SQLite.

          If using PostgreSQL and the value starts with a `/`, it is interpreted as a UNIX domain socket.

          See https://github.com/roundcube/roundcubemail/wiki/Configuration#database-connection
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.path;
        example = lib.literalExpression ''
          pkgs.writeText "roundcube-postgres-passwd.txt" '''
            hostname:port:database:username:password
          '''
        '';
        description = ''
          Password file for the postgresql connection.
          Must be formatted according to PostgreSQL .pgpass standard (see <https://www.postgresql.org/docs/current/libpq-pgpass.html>)
          but only one line, no comments and readable by user `nginx`.

          Ignored if `configurePgsql` is true as peer authentication will be used.
        '';
      };

      dbname = lib.mkOption {
        type = lib.types.str;
        default = "roundcube";
        description = "Name of the postgresql database";
      };

      mode = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "0640";
        example = "0660";
        description = ''
          Mode of the database file.

          Ignored if not using an SQLite database.
        '';
      };
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of roundcube plugins to enable. Currently, only those directly shipped with Roundcube are supported.
      '';
    };

    dicts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "with pkgs.aspellDicts; [ en fr de ]";
      description = ''
        List of aspell dictionaries for spell checking. If empty, spell checking is disabled.
      '';
    };

    maxAttachmentSize = lib.mkOption {
      type = lib.types.int;
      default = 18;
      apply =
        configuredMaxAttachmentSize: "${toString (builtins.ceil (configuredMaxAttachmentSize * 1.37))}M";
      description = ''
        The maximum attachment size in MB.
        [upstream issue comment]: https://github.com/roundcube/roundcubemail/issues/7979#issuecomment-808879209
        ::: {.note}
        Since there is some overhead in base64 encoding applied to attachments, + 37% will be added
        to the value set in this option in order to offset the overhead. For example, setting
        `maxAttachmentSize` to `100` would result in `137M` being the real value in the configuration.
        See [upstream issue comment] for more details on the motivations behind this.
        :::
      '';
    };

    configureNginx = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Configure nginx as a reverse proxy for roundcube.";
    };

    configurePgsql = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Configure the PostgreSQL service and use it to store Roundcube's data.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra configuration for roundcube webmail instance";
    };
  };

  config = lib.mkIf cfg.enable {
    services.roundcube.database = lib.mkIf cfg.configurePgsql {
      type = "pgsql";
      host = "/run/postgresql";
    };

    environment.etc."roundcube/config.inc.php".text = ''
      <?php

      ${lib.optionalString (cfg.database.type != "sqlite" && !cfg.configurePgsql) ''
        $password = file('${cfg.database.passwordFile}')[0];
        $password = preg_split('~\\\\.(*SKIP)(*FAIL)|\:~s', $password);
        $password = rtrim(end($password));
        $password = str_replace("\\:", ":", $password);
        $password = str_replace("\\\\", "\\", $password);
      ''}

      $config = array();

      $config['db_dsnw'] = '${
        # https://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
        if cfg.database.type == "sqlite" then
          "sqlite:///${cfg.database.host}?mode=${cfg.database.mode}"
        else
          let
            host = if localDB then "unix(${cfg.database.host})" else cfg.database.host;
            pass = lib.optionalString (!cfg.configurePgsql) ":' . $password . '";
          in
          "pgsql://${cfg.database.username}${pass}@${host}/${cfg.database.dbname}"
      }';

      $config['log_driver'] = 'syslog';

      $config['max_message_size'] =  '${cfg.maxAttachmentSize}';

      $config['plugins'] = [${lib.concatMapStringsSep "," (p: "'${p}'") cfg.plugins}];

      $config['des_key'] = file_get_contents('/var/lib/roundcube/des_key');

      ${lib.optionalString (cfg.configureNginx or config.services.nginx.enable) ''
        $config['mime_types'] = '${config.services.nginx.package}/conf/mime.types';
      ''}

      # Roundcube uses PHP-FPM which has `PrivateTmp = true;`
      $config['temp_dir'] = '/tmp';

      $config['enable_spellcheck'] = ${if cfg.dicts == [ ] then "false" else "true"};
      # by default, spellchecking uses a third-party cloud services
      $config['spellcheck_engine'] = 'pspell';
      $config['spellcheck_languages'] = array(${
        lib.concatMapStringsSep ", " (
          dict:
          let
            p = builtins.parseDrvName dict.shortName;
          in
          "'${p.name}' => '${dict.fullName}'"
        ) cfg.dicts
      });

      ${cfg.extraConfig}
    '';

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts = {
        ${cfg.hostName} = {
          forceSSL = lib.mkDefault true;
          enableACME = lib.mkDefault true;
          root = cfg.package;
          locations."/" = {
            index = "index.php";
            priority = 1100;
            extraConfig = ''
              add_header Cache-Control 'public, max-age=604800, must-revalidate';
            '';
          };
          locations."~ ^/(SQL|bin|config|logs|temp|vendor)/" = {
            priority = 3110;
            extraConfig = ''
              return 404;
            '';
          };
          locations."~ ^/(CHANGELOG.md|INSTALL|LICENSE|README.md|SECURITY.md|UPGRADING|composer.json|composer.lock)" =
            {
              priority = 3120;
              extraConfig = ''
                return 404;
              '';
            };
          locations."~* \\.php(/|$)" = {
            priority = 3130;
            extraConfig = ''
              fastcgi_pass unix:${fpm.socket};
              fastcgi_param PATH_INFO $fastcgi_path_info;
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              include ${config.services.nginx.package}/conf/fastcgi.conf;
            '';
          };
        };
      };
    };

    assertions = [
      {
        assertion = cfg.configurePgsql -> cfg.database.username == cfg.database.dbname;
        message = ''
          When setting up a DB and its owner user, the owner and the DB name must be
          equal!
        '';
      }
      {
        assertion = cfg.database.type != "pgsql" -> !cfg.configurePgsql;
        message = ''
          When using `${cfg.database.type}` as database, you must also set disable `services.roundcube.configurePgsql`.
        '';
      }
      {
        assertion = cfg.database.type == "sqlite" -> cfg.database.host != "localhost";
        message = ''
          When using SQLite as database, you must also set `services.roundcube.database.host` to the DB file path.
        '';
      }
    ];

    services.postgresql = lib.mkIf cfg.configurePgsql {
      enable = true;
      ensureDatabases = [ cfg.database.dbname ];
      ensureUsers = [
        {
          name = cfg.database.username;
          ensureDBOwnership = true;
        }
      ];
    };

    users.users.${user} = lib.mkIf cfg.configurePgsql {
      group = user;
      isSystemUser = true;
      createHome = false;
    };
    users.groups.${user} = lib.mkIf cfg.configurePgsql { };

    services.phpfpm.pools.roundcube = {
      user = if cfg.configurePgsql then user else "nginx";
      phpOptions = ''
        error_log = '/dev/stderr'
        log_errors = on
        post_max_size = ${cfg.maxAttachmentSize}
        upload_max_filesize = ${cfg.maxAttachmentSize}
      '';
      settings = lib.mapAttrs (name: lib.mkDefault) {
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "listen.mode" = "0660";
        "pm" = "dynamic";
        "pm.max_children" = 75;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 20;
        "pm.max_requests" = 500;
        "catch_workers_output" = true;
      };
      phpPackage = phpWithPspell;
      phpEnv = commonEnv;
    };
    systemd.services.phpfpm-roundcube = {
      requires = [ "roundcube-setup.service" ];
      after = [ "roundcube-setup.service" ];
    };

    # Restart on config changes.
    systemd.services.phpfpm-roundcube.restartTriggers = [
      config.environment.etc."roundcube/config.inc.php".source
    ];

    systemd.services.roundcube-setup = lib.mkMerge [
      (lib.mkIf localPgsql {
        requires = [ "postgresql.target" ];
        after = [ "postgresql.target" ];
      })
      {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = commonEnv // {
          PGPASSFILE = lib.mkIf (
            cfg.database.type == "pgsql" && !cfg.configurePgsql
          ) cfg.database.passwordFile;
        };

        script =
          let
            dbCmd =
              {
                pgsql = lib.escapeShellArgs (
                  [
                    "${if localDB then config.services.postgresql.package else pkgs.postgresql}/bin/psql"
                    "-h"
                    cfg.database.host # interprets a / prefix as UNIX sock path
                  ]
                  ++ lib.optionals (!localDB) [
                    "-U"
                    cfg.database.username
                  ]
                  ++ [
                    cfg.database.dbname
                  ]
                );

                sqlite = lib.escapeShellArgs [
                  "${pkgs.sqlite}/bin/sqlite3"
                  cfg.database.host
                ];
              }
              .${cfg.database.type};

            initSqlFilePrefix =
              {
                pgsql = "postgres";
              }
              .${cfg.database.type} or cfg.database.type;

            truncSql =
              {
                pgsql = "TRUNCATE TABLE";
                sqlite = "DELETE FROM";
              }
              .${cfg.database.type};
          in
          ''
            version="$(${dbCmd} <<< "SELECT value FROM system WHERE name = 'roundcube-version';" || true)"
            if ! (grep -E '[a-zA-Z0-9]' <<< "$version"); then
              ${dbCmd} < ${cfg.package}/SQL/${initSqlFilePrefix}.initial.sql
            fi

            if [ ! -f /var/lib/roundcube/des_key ]; then
              base64 /dev/urandom | head -c 24 > /var/lib/roundcube/des_key;

              # we need to log out everyone in case change the des_key
              # from the default when upgrading from nixos 19.09
              ${dbCmd} <<< '${truncSql} session;'
            fi

            ${phpWithPspell}/bin/php ${cfg.package}/bin/update.sh
          '';

        serviceConfig = {
          Type = "oneshot";
          StateDirectory = "roundcube";
          User = config.services.phpfpm.pools.roundcube.user;
          # so that the des_key is not world readable
          StateDirectoryMode = "0700";
        };
      }
    ];
  };
}
