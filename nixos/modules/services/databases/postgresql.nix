{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.postgresql;

  packageSetPlugins = cfg.plugins cfg.packages;
  plugins = if cfg.extraPlugins != [] then cfg.extraPlugins else packageSetPlugins;

  # see description of extraPlugins
  postgresqlAndPlugins = pg:
    # See the note about withPackages in postgresql/packages.nix for more
    let ps = import ../../../../pkgs/servers/sql/postgresql/packages.nix { inherit pkgs lib; };
    in ps.withPackages pg plugins;

  postgresql = postgresqlAndPlugins cfg.postgresqlPackage;

  # The main PostgreSQL configuration file.
  configFile = pkgs.writeText "postgresql.conf"
    ''
      hba_file = '${pkgs.writeText "pg_hba.conf" cfg.authentication}'
      ident_file = '${pkgs.writeText "pg_ident.conf" cfg.identMap}'
      log_destination = 'stderr'
      listen_addresses = '${if cfg.enableTCPIP then "*" else "localhost"}'
      port = ${toString cfg.port}
      ${cfg.extraConfig}
    '';

  # TODO: propose to move this to lib/types.nix
  # since selector functions are used in at least 6 other options in NixOS.
  selectorFunction = mkOptionType {
    name = "selectorFunction";
    description =
      "function that takes an attribute set and returns a list " +
      "containing a selection of the values of the input set";
    check = select: isFunction select;
    merge = _loc: defs:
      as: concatMap (select: select as) (getValues defs);
  };

in

{

  ###### interface

  options = {

    services.postgresql = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run PostgreSQL.
        '';
      };

      package = mkOption {
        type = types.nullOr types.package;
        example = literalExample "pkgs.postgresql96";
        default = null;
        description = ''
          PostgreSQL package to use. Deprecated. Use services.postgresql.packages instead
          to specify an entire package set (including compatible extensions) at once.
        '';
      };

      packages = mkOption {
        type = types.nullOr (types.attrsOf types.package);
        default = null;
        example = literalExample "pkgs.postgresql96Packages";
        description = ''
          The set of PostgreSQL packages to use, including the database
          server and all available extensions.
        '';
      };

      postgresqlPackage = mkOption {
        type = types.package;
        default =
          if cfg.package != null
          then cfg.package
          else cfg.packages.postgresql;
        readOnly = true;
        visible = false;
        description = ''
          A deprecated, read-only and invisible option that refers to the
          selected PostgreSQL package. This should be removed at the same time
          that the deprecated config.services.postgresql.package option is removed.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 5432;
        description = ''
          The port on which PostgreSQL listens.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        example = "/var/lib/postgresql/9.6";
        description = ''
          Data directory for PostgreSQL.
        '';
      };

      authentication = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Defines how users authenticate themselves to the server. By
          default, "trust" access to local users will always be granted
          along with any other custom options. If you do not want this,
          set this option using "lib.mkForce" to override this
          behaviour.
        '';
      };

      identMap = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Defines the mapping from system users to database users.
        '';
      };

      initialScript = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          A file containing SQL statements to execute on first startup.
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
        type = types.listOf types.path;
        default = [];
        example = literalExample "[ (pkgs.postgis.override { postgresql = pkgs.postgresql94; }) ]";
        description = ''
          Deprecated. When this list contains elements a new store path is created.
          PostgreSQL and the elements are symlinked into it. Then pg_config,
          postgres and pg_ctl are copied to make them use the new
          $out/lib directory as pkglibdir. This makes it possible to use postgis
          without patching the .sql files which reference $libdir/postgis-1.5.

          This attribute is hard to use, and is deprecated in favor of the more general
          services.postgresql.plugins attribute, which will correctly override the specified
          packages for you.
        '';
      };

      plugins = mkOption {
        default = _: [];
        type = selectorFunction;
        example = literalExample "p: with p; [ postgis timescaledb ]";
        description = ''
          A function that selects plugins to include in the PostgreSQL server.
          When this function returns a non-empty list, a new store path is created.
          PostgreSQL and the elements are symlinked into it. Then pg_config,
          postgres and pg_ctl are copied to make them use the new
          $out/lib directory as pkglibdir.

          The value provided as an argument to the function is the set of available
          PostgreSQL plugins, specified by the services.postgresql.packages argument.
        '';
        # Note: the duplication of executables is about 4MB size.
        # So a nicer solution was patching postgresql to allow setting the
        # libdir explicitely.
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional text to be appended to <filename>postgresql.conf</filename>.";
      };

      recoveryConfig = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Contents of the <filename>recovery.conf</filename> file.
        '';
      };
      superUser = mkOption {
        type = types.str;
        default= if versionAtLeast config.system.stateVersion "17.09" then "postgres" else "root";
        internal = true;
        description = ''
          NixOS traditionally used 'root' as superuser, most other distros use 'postgres'.
          From 17.09 we also try to follow this standard. Internal since changing this value
          would lead to breakage while setting up databases.
        '';
        };
    };

  };


  ###### implementation

  config = mkIf config.services.postgresql.enable {

    assertions =
      [ # The user specified both 'package' and 'packages', which are mutually exclusive
        { assertion = (cfg.package != null -> cfg.packages != null);
          message = ''
            The option services.postgresql.{package,packages} cannot both be set. Please use the 'packages' option
            to specify the entire set of PostgreSQL packages.
          '';
        }

        # The user specified the old extraPlugins attribute, but they *also* specified some 'plugins' function
        # which returned a non-empty list. These are mutually exclusive.
        { assertion = (cfg.extraPlugins != [] -> packageSetPlugins == []);
          message = ''
            The option services.postgresql.extraPlugins and .plugins cannot both be non-empty at the same time; please remove
            uses of .extraPlugins.
          '';
        }
      ];

    warnings =
      (optional (cfg.package != null)
        ''The services.postgresql.package attribute is deprecated. Please use services.postgresql.packages (with an 's') instead.
          See the NixOS manual ('nixos-help') for more information.'') ++
      (optional (cfg.extraPlugins != [])
        ''The services.postgresql.extraPlugins attribute is deprecated. Please use services.postgresql.plugins instead,
          which will correctly override PostgreSQL attributes for you and will provide a list of compatible plugins for
          the given server version.
        '');

    services.postgresql.packages =
      # Note: when changing the default, make it conditional on
      # ‘system.stateVersion’ to maintain compatibility with existing
      # systems!
      mkDefault (if versionAtLeast config.system.stateVersion "18.09" then pkgs.postgresql10Packages
            else if versionAtLeast config.system.stateVersion "17.09" then pkgs.postgresql96Packages
            else if versionAtLeast config.system.stateVersion "16.03" then pkgs.postgresql95Packages
            else pkgs.postgresql94Packages);

    services.postgresql.dataDir =
      mkDefault (if versionAtLeast config.system.stateVersion "17.09" then "/var/lib/postgresql/${cfg.postgresqlPackage.psqlSchema}"
                 else "/var/db/postgresql");

    services.postgresql.authentication = mkAfter
      ''
        # Generated file; do not edit!
        local all all              ident
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

    systemd.services.postgresql =
      { description = "PostgreSQL Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment.PGDATA = cfg.dataDir;

        path = [ postgresql ];

        preStart =
          ''
            # Create data directory.
            if ! test -e ${cfg.dataDir}/PG_VERSION; then
              mkdir -m 0700 -p ${cfg.dataDir}
              rm -f ${cfg.dataDir}/*.conf
              chown -R postgres:postgres ${cfg.dataDir}
            fi
          ''; # */

        script =
          ''
            # Initialise the database.
            if ! test -e ${cfg.dataDir}/PG_VERSION; then
              initdb -U ${cfg.superUser}
              # See postStart!
              touch "${cfg.dataDir}/.first_startup"
            fi
            ln -sfn "${configFile}" "${cfg.dataDir}/postgresql.conf"
            ${optionalString (cfg.recoveryConfig != null) ''
              ln -sfn "${pkgs.writeText "recovery.conf" cfg.recoveryConfig}" \
                "${cfg.dataDir}/recovery.conf"
            ''}

             exec postgres
          '';

        serviceConfig =
          { ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
            User = "postgres";
            Group = "postgres";
            PermissionsStartOnly = true;

            # Shut down Postgres using SIGINT ("Fast Shutdown mode").  See
            # http://www.postgresql.org/docs/current/static/server-shutdown.html
            KillSignal = "SIGINT";
            KillMode = "mixed";

            # Give Postgres a decent amount of time to clean up after
            # receiving systemd's SIGINT.
            TimeoutSec = 120;

            Type = if versionAtLeast cfg.postgresqlPackage.psqlSchema "9.6" then "notify" else "simple";
          };

        # Wait for PostgreSQL to be ready to accept connections.
        postStart =
          ''
            while ! ${pkgs.sudo}/bin/sudo -u ${cfg.superUser} psql --port=${toString cfg.port} -d postgres -c "" 2> /dev/null; do
                if ! kill -0 "$MAINPID"; then exit 1; fi
                sleep 0.1
            done

            if test -e "${cfg.dataDir}/.first_startup"; then
              ${optionalString (cfg.initialScript != null) ''
                ${pkgs.sudo}/bin/sudo -u ${cfg.superUser} psql -f "${cfg.initialScript}" --port=${toString cfg.port} -d postgres
              ''}
              rm -f "${cfg.dataDir}/.first_startup"
            fi
          '';

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";
      };

  };

  meta.doc = ./postgresql.xml;
  meta.maintainers = with lib.maintainers; [ thoughtpolice ];
}
