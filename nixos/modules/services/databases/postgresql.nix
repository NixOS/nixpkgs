{ config, lib, pkgs, ... }:

let
  inherit (lib)
    attrValues
    concatMapStrings
    concatStringsSep
    const
    elem
    filterAttrs
    isString
    literalExpression
    mapAttrs
    mapAttrsToList
    mkAfter
    mkBefore
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    optionalString
    types
    versionAtLeast
    ;

  cfg = config.services.postgresql;

  postgresql =
    let
      # ensure that
      #   services.postgresql = {
      #     enableJIT = true;
      #     package = pkgs.postgresql_<major>;
      #   };
      # works.
      base = if cfg.enableJIT then cfg.package.withJIT else cfg.package.withoutJIT;
    in
    if cfg.extraPlugins == []
      then base
      else base.withPackages cfg.extraPlugins;

  toStr = value:
    if true == value then "yes"
    else if false == value then "no"
    else if isString value then "'${lib.replaceStrings ["'"] ["''"] value}'"
    else builtins.toString value;

  # The main PostgreSQL configuration file.
  configFile = pkgs.writeTextDir "postgresql.conf" (concatStringsSep "\n" (mapAttrsToList (n: v: "${n} = ${toStr v}") (filterAttrs (const (x: x != null)) cfg.settings)));

  configFileCheck = pkgs.runCommand "postgresql-configfile-check" {} ''
    ${cfg.package}/bin/postgres -D${configFile} -C config_file >/dev/null
    touch $out
  '';

  groupAccessAvailable = versionAtLeast postgresql.version "11.0";

in

{
  imports = [
    (mkRemovedOptionModule [ "services" "postgresql" "extraConfig" ] "Use services.postgresql.settings instead.")

    (mkRenamedOptionModule [ "services" "postgresql" "logLinePrefix" ] [ "services" "postgresql" "settings" "log_line_prefix" ])
    (mkRenamedOptionModule [ "services" "postgresql" "port" ] [ "services" "postgresql" "settings" "port" ])
  ];

  ###### interface

  options = {

    services.postgresql = {

      enable = mkEnableOption "PostgreSQL Server";

      enableJIT = mkEnableOption "JIT support";

      package = mkPackageOption pkgs "postgresql" {
        example = "postgresql_15";
      };

      checkConfig = mkOption {
        type = types.bool;
        default = true;
        description = "Check the syntax of the configuration file at compile time";
      };

      dataDir = mkOption {
        type = types.path;
        defaultText = literalExpression ''"/var/lib/postgresql/''${config.services.postgresql.package.psqlSchema}"'';
        example = "/var/lib/postgresql/15";
        description = ''
          The data directory for PostgreSQL. If left as the default value
          this directory will automatically be created before the PostgreSQL server starts, otherwise
          the sysadmin is responsible for ensuring the directory exists with appropriate ownership
          and permissions.
        '';
      };

      authentication = mkOption {
        type = types.lines;
        default = "";
        description = ''
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
        example = ''
          map-name-0 system-username-0 database-username-0
          map-name-1 system-username-1 database-username-1
        '';
        description = ''
          Defines the mapping from system users to database users.

          See the [auth doc](https://postgresql.org/docs/current/auth-username-maps.html).
        '';
      };

      initdbArgs = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "--data-checksums" "--allow-group-access" ];
        description = ''
          Additional arguments passed to `initdb` during data dir
          initialisation.
        '';
      };

      initialScript = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = literalExpression ''
          pkgs.writeText "init-sql-script" '''
            alter user postgres with password 'myPassword';
          ''';'';

        description = ''
          A file containing SQL statements to execute on first startup.
        '';
      };

      ensureDatabases = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
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
              description = ''
                Name of the user to ensure.
              '';
            };

            ensureDBOwnership = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Grants the user ownership to a database with the same name.
                This database must be defined manually in
                [](#opt-services.postgresql.ensureDatabases).
              '';
            };

            ensureClauses = mkOption {
              description = ''
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
                    description = ''
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
                    description = ''
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
                    description = ''
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
                    description = ''
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
                    description = ''
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
                    description = ''
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
                    description = ''
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
        description = ''
          Ensures that the specified users exist.
          The PostgreSQL users will be identified using peer authentication. This authenticates the Unix user with the
          same name only, and that without the need for a password.
          This option will never delete existing users or remove DB ownership of databases
          once granted with `ensureDBOwnership = true;`. This means that this must be
          cleaned up manually when changing after changing the config in here.
        '';
        example = literalExpression ''
          [
            {
              name = "nextcloud";
            }
            {
              name = "superuser";
              ensureDBOwnership = true;
            }
          ]
        '';
      };

      enableTCPIP = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether PostgreSQL should listen on all network interfaces.
          If disabled, the database can only be accessed via its Unix
          domain socket or via TCP connections to localhost.
        '';
      };

      extraPlugins = mkOption {
        type = with types; coercedTo (listOf path) (path: _ignorePg: path) (functionTo (listOf path));
        default = _: [];
        example = literalExpression "ps: with ps; [ postgis pg_repack ]";
        description = ''
          List of PostgreSQL plugins.
        '';
      };

      settings = mkOption {
        type = with types; submodule {
          freeformType = attrsOf (oneOf [ bool float int str ]);
          options = {
            shared_preload_libraries = mkOption {
              type = nullOr (coercedTo (listOf str) (concatStringsSep ", ") str);
              default = null;
              example = literalExpression ''[ "auto_explain" "anon" ]'';
              description = ''
                List of libraries to be preloaded.
              '';
            };

            log_line_prefix = mkOption {
              type = types.str;
              default = "[%p] ";
              example = "%m [%p] ";
              description = ''
                A printf-style string that is output at the beginning of each log line.
                Upstream default is `'%m [%p] '`, i.e. it includes the timestamp. We do
                not include the timestamp, because journal has it anyway.
              '';
            };

            port = mkOption {
              type = types.port;
              default = 5432;
              description = ''
                The port on which PostgreSQL listens.
              '';
            };
          };
        };
        default = {};
        description = ''
          PostgreSQL configuration. Refer to
          <https://www.postgresql.org/docs/current/config-setting.html#CONFIG-SETTING-CONFIGURATION-FILE>
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
            logging_collector = true;
            log_disconnections = true;
            log_destination = lib.mkForce "syslog";
          }
        '';
      };

      recoveryConfig = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Contents of the {file}`recovery.conf` file.
        '';
      };

      superUser = mkOption {
        type = types.str;
        default = "postgres";
        internal = true;
        readOnly = true;
        description = ''
          PostgreSQL superuser account to use for various operations. Internal since changing
          this value would lead to breakage while setting up databases.
        '';
        };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = map ({ name, ensureDBOwnership, ... }: {
      assertion = ensureDBOwnership -> elem name cfg.ensureDatabases;
      message = ''
        For each database user defined with `services.postgresql.ensureUsers` and
        `ensureDBOwnership = true;`, a database with the same name must be defined
        in `services.postgresql.ensureDatabases`.

        Offender: ${name} has not been found among databases.
      '';
    }) cfg.ensureUsers;

    services.postgresql.settings =
      {
        hba_file = "${pkgs.writeText "pg_hba.conf" cfg.authentication}";
        ident_file = "${pkgs.writeText "pg_ident.conf" cfg.identMap}";
        log_destination = "stderr";
        listen_addresses = if cfg.enableTCPIP then "*" else "localhost";
        jit = mkDefault (if cfg.enableJIT then "on" else "off");
      };

    services.postgresql.package = let
        mkThrow = ver: throw "postgresql_${ver} was removed, please upgrade your postgresql version.";
        base = if versionAtLeast config.system.stateVersion "24.11" then pkgs.postgresql_16
            else if versionAtLeast config.system.stateVersion "23.11" then pkgs.postgresql_15
            else if versionAtLeast config.system.stateVersion "22.05" then pkgs.postgresql_14
            else if versionAtLeast config.system.stateVersion "21.11" then pkgs.postgresql_13
            else if versionAtLeast config.system.stateVersion "20.03" then mkThrow "11"
            else if versionAtLeast config.system.stateVersion "17.09" then mkThrow "9_6"
            else mkThrow "9_5";
    in
      # Note: when changing the default, make it conditional on
      # ‘system.stateVersion’ to maintain compatibility with existing
      # systems!
      mkDefault (if cfg.enableJIT then base.withJIT else base);

    services.postgresql.dataDir = mkDefault "/var/lib/postgresql/${cfg.package.psqlSchema}";

    services.postgresql.authentication = mkMerge [
      (mkBefore "# Generated file; do not edit!")
      (mkAfter
      ''
        # default value of services.postgresql.authentication
        local all all              peer
        host  all all 127.0.0.1/32 md5
        host  all all ::1/128      md5
      '')
    ];

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

    system.checks = lib.optional (cfg.checkConfig && pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform) configFileCheck;

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
            PSQL="psql --port=${builtins.toString cfg.settings.port}"

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
                  dbOwnershipStmt = optionalString
                    user.ensureDBOwnership
                    ''$PSQL -tAc 'ALTER DATABASE "${user.name}" OWNER TO "${user.name}";' '';

                  filteredClauses = filterAttrs (name: value: value != null) user.ensureClauses;

                  clauseSqlStatements = attrValues (mapAttrs (n: v: if v then n else "no${n}") filteredClauses);

                  userClauses = ''$PSQL -tAc 'ALTER ROLE "${user.name}" ${concatStringsSep " " clauseSqlStatements}' '';
                in ''
                  $PSQL -tAc "SELECT 1 FROM pg_roles WHERE rolname='${user.name}'" | grep -q 1 || $PSQL -tAc 'CREATE USER "${user.name}"'
                  ${userClauses}

                  ${dbOwnershipStmt}
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
            # https://www.postgresql.org/docs/current/server-shutdown.html
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

  meta.doc = ./postgresql.md;
  meta.maintainers = with lib.maintainers; [ thoughtpolice danbst ];
}
