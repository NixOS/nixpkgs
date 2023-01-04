{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.postgresql;

  postgresql =
    if cfg.extraPlugins == []
      then cfg.package
      else cfg.package.withPackages (_: cfg.extraPlugins);

  toStr = value:
    if true == value then "yes"
    else if false == value then "no"
    else if isString value then "'${lib.replaceStrings ["'"] ["''"] value}'"
    else toString value;

  # The main PostgreSQL configuration file.
  configFile = pkgs.writeTextDir "postgresql.conf" (concatStringsSep "\n" (mapAttrsToList (n: v: "${n} = ${toStr v}") cfg.settings));

  configFileCheck = pkgs.runCommand "postgresql-configfile-check" {} ''
    ${cfg.package}/bin/postgres -D${configFile} -C config_file >/dev/null
    touch $out
  '';

  groupAccessAvailable = versionAtLeast postgresql.version "11.0";

in

{
  imports = [
    (mkRemovedOptionModule [ "services" "postgresql" "extraConfig" ] "Use services.postgresql.settings instead.")
  ];

  ###### interface

  options = {

    services.postgresql = {

      enable = mkEnableOption (lib.mdDoc "PostgreSQL Server");

      package = mkOption {
        type = types.package;
        example = literalExpression "pkgs.postgresql_11";
        description = lib.mdDoc ''
          PostgreSQL package to use.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 5432;
        description = lib.mdDoc ''
          The port on which PostgreSQL listens.
        '';
      };

      checkConfig = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Check the syntax of the configuration file at compile time";
      };

      dataDir = mkOption {
        type = types.path;
        defaultText = literalExpression ''"/var/lib/postgresql/''${config.services.postgresql.package.psqlSchema}"'';
        example = "/var/lib/postgresql/11";
        description = lib.mdDoc ''
          The data directory for PostgreSQL. If left as the default value
          this directory will automatically be created before the PostgreSQL server starts, otherwise
          the sysadmin is responsible for ensuring the directory exists with appropriate ownership
          and permissions.
        '';
      };

      authentication = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Defines how users authenticate themselves to the server. See the
          [PostgreSQL documentation for pg_hba.conf](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html)
          for details on the expected format of this option. By default,
          peer based authentication will be used for users connecting
          via the Unix socket, and md5 password authentication will be
          used for users connecting via TCP. Any added rules will be
          inserted above the default rules. If you'd like to replace the
          default rules entirely, you can use `lib.mkForce` in your
          module.
        '';
      };

      identMap = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Defines the mapping from system users to database users.

          The general form is:

          map-name system-username database-username
        '';
      };

      initdbArgs = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "--data-checksums" "--allow-group-access" ];
        description = lib.mdDoc ''
          Additional arguments passed to `initdb` during data dir
          initialisation.
        '';
      };

      initialScript = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          A file containing SQL statements to execute on first startup.
        '';
      };

      ensureDatabases = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Ensures that the specified databases exist.
          This option will never delete existing databases, especially not when the value of this
          option is changed. This means that databases created once through this option or
          otherwise have to be removed manually.
        '';
        example = [
          "gitea"
          "nextcloud"
        ];
      };

      ensureUsers = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Name of the user to ensure.
              '';
            };

            ensurePermissions = mkOption {
              type = types.attrsOf types.str;
              default = {};
              description = lib.mdDoc ''
                Permissions to ensure for the user, specified as an attribute set.
                The attribute names specify the database and tables to grant the permissions for.
                The attribute values specify the permissions to grant. You may specify one or
                multiple comma-separated SQL privileges here.

                For more information on how to specify the target
                and on which privileges exist, see the
                [GRANT syntax](https://www.postgresql.org/docs/current/sql-grant.html).
                The attributes are used as `GRANT ''${attrValue} ON ''${attrName}`.
              '';
              example = literalExpression ''
                {
                  "DATABASE \"nextcloud\"" = "ALL PRIVILEGES";
                  "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
                }
              '';
            };

            ensureClauses = mkOption {
              description = lib.mdDoc ''
                An attrset of clauses to grant to the user. Under the hood this uses the
                [ALTER USER syntax](https://www.postgresql.org/docs/current/sql-alteruser.html) for each attrName where
                the attrValue is true in the attrSet:
                `ALTER USER user.name WITH attrName`
              '';
              example = literalExpression ''
                {
                  superuser = true;
                  createrole = true;
                  createdb = true;
                }
              '';
              default = {};
              defaultText = lib.literalMD ''
                The default, `null`, means that the user created will have the default permissions assigned by PostgreSQL. Subsequent server starts will not set or unset the clause, so imperative changes are preserved.
              '';
              type = types.submodule {
                options = let
                  defaultText = lib.literalMD ''
                    `null`: do not set. For newly created roles, use PostgreSQL's default. For existing roles, do not touch this clause.
                  '';
                in {
                  superuser = mkOption {
                    type = types.nullOr types.bool;
                    description = lib.mdDoc ''
                      Grants the user, created by the ensureUser attr, superuser permissions. From the postgres docs:

                      A database superuser bypasses all permission checks,
                      except the right to log in. This is a dangerous privilege
                      and should not be used carelessly; it is best to do most
                      of your work as a role that is not a superuser. To create
                      a new database superuser, use CREATE ROLE name SUPERUSER.
                      You must do this as a role that is already a superuser.

                      More information on postgres roles can be found [here](https://www.postgresql.org/docs/current/role-attributes.html)
                    '';
                    default = null;
                    inherit defaultText;
                  };
                  createrole = mkOption {
                    type = types.nullOr types.bool;
                    description = lib.mdDoc ''
                      Grants the user, created by the ensureUser attr, createrole permissions. From the postgres docs:

                      A role must be explicitly given permission to create more
                      roles (except for superusers, since those bypass all
                      permission checks). To create such a role, use CREATE
                      ROLE name CREATEROLE. A role with CREATEROLE privilege
                      can alter and drop other roles, too, as well as grant or
                      revoke membership in them. However, to create, alter,
                      drop, or change membership of a superuser role, superuser
                      status is required; CREATEROLE is insufficient for that.

                      More information on postgres roles can be found [here](https://www.postgresql.org/docs/current/role-attributes.html)
                    '';
                    default = null;
                    inherit defaultText;
                  };
                  createdb = mkOption {
                    type = types.nullOr types.bool;
                    description = lib.mdDoc ''
                      Grants the user, created by the ensureUser attr, createdb permissions. From the postgres docs:

                      A role must be explicitly given permission to create
                      databases (except for superusers, since those bypass all
                      permission checks). To create such a role, use CREATE
                      ROLE name CREATEDB.

                      More information on postgres roles can be found [here](https://www.postgresql.org/docs/current/role-attributes.html)
                    '';
                    default = null;
                    inherit defaultText;
                  };
                  "inherit" = mkOption {
                    type = types.nullOr types.bool;
                    description = lib.mdDoc ''
                      Grants the user created inherit permissions. From the postgres docs:

                      A role is given permission to inherit the privileges of
                      roles it is a member of, by default. However, to create a
                      role without the permission, use CREATE ROLE name
                      NOINHERIT.

                      More information on postgres roles can be found [here](https://www.postgresql.org/docs/current/role-attributes.html)
                    '';
                    default = null;
                    inherit defaultText;
                  };
                  login = mkOption {
                    type = types.nullOr types.bool;
                    description = lib.mdDoc ''
                      Grants the user, created by the ensureUser attr, login permissions. From the postgres docs:

                      Only roles that have the LOGIN attribute can be used as
                      the initial role name for a database connection. A role
                      with the LOGIN attribute can be considered the same as a
                      “database user”. To create a role with login privilege,
                      use either:

                      CREATE ROLE name LOGIN; CREATE USER name;

                      (CREATE USER is equivalent to CREATE ROLE except that
                      CREATE USER includes LOGIN by default, while CREATE ROLE
                      does not.)

                      More information on postgres roles can be found [here](https://www.postgresql.org/docs/current/role-attributes.html)
                    '';
                    default = null;
                    inherit defaultText;
                  };
                  replication = mkOption {
                    type = types.nullOr types.bool;
                    description = lib.mdDoc ''
                      Grants the user, created by the ensureUser attr, replication permissions. From the postgres docs:

                      A role must explicitly be given permission to initiate
                      streaming replication (except for superusers, since those
                      bypass all permission checks). A role used for streaming
                      replication must have LOGIN permission as well. To create
                      such a role, use CREATE ROLE name REPLICATION LOGIN.

                      More information on postgres roles can be found [here](https://www.postgresql.org/docs/current/role-attributes.html)
                    '';
                    default = null;
                    inherit defaultText;
                  };
                  bypassrls = mkOption {
                    type = types.nullOr types.bool;
                    description = lib.mdDoc ''
                      Grants the user, created by the ensureUser attr, replication permissions. From the postgres docs:

                      A role must be explicitly given permission to bypass
                      every row-level security (RLS) policy (except for
                      superusers, since those bypass all permission checks). To
                      create such a role, use CREATE ROLE name BYPASSRLS as a
                      superuser.

                      More information on postgres roles can be found [here](https://www.postgresql.org/docs/current/role-attributes.html)
                    '';
                    default = null;
                    inherit defaultText;
                  };
                };
              };
            };
          };
        });
        default = [];
        description = lib.mdDoc ''
          Ensures that the specified users exist and have at least the ensured permissions.
          The PostgreSQL users will be identified using peer authentication. This authenticates the Unix user with the
          same name only, and that without the need for a password.
          This option will never delete existing users or remove permissions, especially not when the value of this
          option is changed. This means that users created and permissions assigned once through this option or
          otherwise have to be removed manually.
        '';
        example = literalExpression ''
          [
            {
              name = "nextcloud";
              ensurePermissions = {
                "DATABASE nextcloud" = "ALL PRIVILEGES";
              };
            }
            {
              name = "superuser";
              ensurePermissions = {
                "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
              };
            }
          ]
        '';
      };

      enableTCPIP = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether PostgreSQL should listen on all network interfaces.
          If disabled, the database can only be accessed via its Unix
          domain socket or via TCP connections to localhost.
        '';
      };

      logLinePrefix = mkOption {
        type = types.str;
        default = "[%p] ";
        example = "%m [%p] ";
        description = lib.mdDoc ''
          A printf-style string that is output at the beginning of each log line.
          Upstream default is `'%m [%p] '`, i.e. it includes the timestamp. We do
          not include the timestamp, because journal has it anyway.
        '';
      };

      extraPlugins = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExpression "with pkgs.postgresql_11.pkgs; [ postgis pg_repack ]";
        description = lib.mdDoc ''
          List of PostgreSQL plugins. PostgreSQL version for each plugin should
          match version for `services.postgresql.package` value.
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ bool float int str ]);
        default = {};
        description = lib.mdDoc ''
          PostgreSQL configuration. Refer to
          <https://www.postgresql.org/docs/11/config-setting.html#CONFIG-SETTING-CONFIGURATION-FILE>
          for an overview of `postgresql.conf`.

          ::: {.note}
          String values will automatically be enclosed in single quotes. Single quotes will be
          escaped with two single quotes as described by the upstream documentation linked above.
          :::
        '';
        example = literalExpression ''
          {
            log_connections = true;
            log_statement = "all";
            logging_collector = true
            log_disconnections = true
            log_destination = lib.mkForce "syslog";
          }
        '';
      };

      recoveryConfig = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = lib.mdDoc ''
          Contents of the {file}`recovery.conf` file.
        '';
      };

      superUser = mkOption {
        type = types.str;
        default = "postgres";
        internal = true;
        readOnly = true;
        description = lib.mdDoc ''
          PostgreSQL superuser account to use for various operations. Internal since changing
          this value would lead to breakage while setting up databases.
        '';
        };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.postgresql.settings =
      {
        hba_file = "${pkgs.writeText "pg_hba.conf" cfg.authentication}";
        ident_file = "${pkgs.writeText "pg_ident.conf" cfg.identMap}";
        log_destination = "stderr";
        log_line_prefix = cfg.logLinePrefix;
        listen_addresses = if cfg.enableTCPIP then "*" else "localhost";
        port = cfg.port;
      };

    services.postgresql.package = let
        mkThrow = ver: throw "postgresql_${ver} was removed, please upgrade your postgresql version.";
    in
      # Note: when changing the default, make it conditional on
      # ‘system.stateVersion’ to maintain compatibility with existing
      # systems!
      mkDefault (if versionAtLeast config.system.stateVersion "22.05" then pkgs.postgresql_14
            else if versionAtLeast config.system.stateVersion "21.11" then pkgs.postgresql_13
            else if versionAtLeast config.system.stateVersion "20.03" then pkgs.postgresql_11
            else if versionAtLeast config.system.stateVersion "17.09" then mkThrow "9_6"
            else mkThrow "9_5");

    services.postgresql.dataDir = mkDefault "/var/lib/postgresql/${cfg.package.psqlSchema}";

    services.postgresql.authentication = mkAfter
      ''
        # Generated file; do not edit!
        local all all              peer
        host  all all 127.0.0.1/32 md5
        host  all all ::1/128      md5
      '';

    users.users.postgres =
      { name = "postgres";
        uid = config.ids.uids.postgres;
        group = "postgres";
        description = "PostgreSQL server user";
        home = "${cfg.dataDir}";
        useDefaultShell = true;
      };

    users.groups.postgres.gid = config.ids.gids.postgres;

    environment.systemPackages = [ postgresql ];

    environment.pathsToLink = [
     "/share/postgresql"
    ];

    system.extraDependencies = lib.optional (cfg.checkConfig && pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform) configFileCheck;

    systemd.services.postgresql =
      { description = "PostgreSQL Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment.PGDATA = cfg.dataDir;

        path = [ postgresql ];

        preStart =
          ''
            if ! test -e ${cfg.dataDir}/PG_VERSION; then
              # Cleanup the data directory.
              rm -f ${cfg.dataDir}/*.conf

              # Initialise the database.
              initdb -U ${cfg.superUser} ${concatStringsSep " " cfg.initdbArgs}

              # See postStart!
              touch "${cfg.dataDir}/.first_startup"
            fi

            ln -sfn "${configFile}/postgresql.conf" "${cfg.dataDir}/postgresql.conf"
            ${optionalString (cfg.recoveryConfig != null) ''
              ln -sfn "${pkgs.writeText "recovery.conf" cfg.recoveryConfig}" \
                "${cfg.dataDir}/recovery.conf"
            ''}
          '';

        # Wait for PostgreSQL to be ready to accept connections.
        postStart =
          ''
            PSQL="psql --port=${toString cfg.port}"

            while ! $PSQL -d postgres -c "" 2> /dev/null; do
                if ! kill -0 "$MAINPID"; then exit 1; fi
                sleep 0.1
            done

            if test -e "${cfg.dataDir}/.first_startup"; then
              ${optionalString (cfg.initialScript != null) ''
                $PSQL -f "${cfg.initialScript}" -d postgres
              ''}
              rm -f "${cfg.dataDir}/.first_startup"
            fi
          '' + optionalString (cfg.ensureDatabases != []) ''
            ${concatMapStrings (database: ''
              $PSQL -tAc "SELECT 1 FROM pg_database WHERE datname = '${database}'" | grep -q 1 || $PSQL -tAc 'CREATE DATABASE "${database}"'
            '') cfg.ensureDatabases}
          '' + ''
            ${
              concatMapStrings
              (user:
                let
                  userPermissions = concatStringsSep "\n"
                    (mapAttrsToList
                      (database: permission: ''$PSQL -tAc 'GRANT ${permission} ON ${database} TO "${user.name}"' '')
                      user.ensurePermissions
                    );

                  filteredClauses = filterAttrs (name: value: value != null) user.ensureClauses;

                  clauseSqlStatements = attrValues (mapAttrs (n: v: if v then n else "no${n}") filteredClauses);

                  userClauses = ''$PSQL -tAc 'ALTER ROLE "${user.name}" ${concatStringsSep " " clauseSqlStatements}' '';
                in ''
                  $PSQL -tAc "SELECT 1 FROM pg_roles WHERE rolname='${user.name}'" | grep -q 1 || $PSQL -tAc 'CREATE USER "${user.name}"'
                  ${userPermissions}
                  ${userClauses}
                ''
              )
              cfg.ensureUsers
            }
          '';

        serviceConfig = mkMerge [
          { ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
            User = "postgres";
            Group = "postgres";
            RuntimeDirectory = "postgresql";
            Type = if versionAtLeast cfg.package.version "9.6"
                   then "notify"
                   else "simple";

            # Shut down Postgres using SIGINT ("Fast Shutdown mode").  See
            # http://www.postgresql.org/docs/current/static/server-shutdown.html
            KillSignal = "SIGINT";
            KillMode = "mixed";

            # Give Postgres a decent amount of time to clean up after
            # receiving systemd's SIGINT.
            TimeoutSec = 120;

            ExecStart = "${postgresql}/bin/postgres";
          }
          (mkIf (cfg.dataDir == "/var/lib/postgresql/${cfg.package.psqlSchema}") {
            StateDirectory = "postgresql postgresql/${cfg.package.psqlSchema}";
            StateDirectoryMode = if groupAccessAvailable then "0750" else "0700";
          })
        ];

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";
      };

  };

  # Don't edit the docbook xml directly, edit the md and generate it:
  # `pandoc postgresql.md -t docbook --top-level-division=chapter --extract-media=media -f markdown+smart --lua-filter ../../../../doc/build-aux/pandoc-filters/myst-reader/roles.lua --lua-filter ../../../../doc/build-aux/pandoc-filters/docbook-writer/rst-roles.lua > postgresql.xml`
  meta.doc = ./postgresql.xml;
  meta.maintainers = with lib.maintainers; [ thoughtpolice danbst ];
}
