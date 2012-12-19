{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.postgresql;

  # see description of extraPlugins
  postgresqlAndPlugins = pg:
    if cfg.extraPlugins == [] then pg
    else pkgs.buildEnv {
      name = "postgresql-and-plugins-${(builtins.parseDrvName pg.name).version}";
      paths = [ pg ] ++ cfg.extraPlugins;
      postBuild =
        ''
          mkdir -p $out/bin
          rm $out/bin/{pg_config,postgres,pg_ctl}
          cp --target-directory=$out/bin ${pg}/bin/{postgres,pg_config,pg_ctl}
        '';
    };

  postgresql = postgresqlAndPlugins cfg.package;

  flags = optional cfg.enableTCPIP "-i";

  # The main PostgreSQL configuration file.
  configFile = pkgs.writeText "postgresql.conf"
    ''
      hba_file = '${pkgs.writeText "pg_hba.conf" cfg.authentication}'
      ident_file = '${pkgs.writeText "pg_ident.conf" cfg.identMap}'
      log_destination = 'syslog'
      ${cfg.extraConfig}
    '';

  pre84 = versionOlder (builtins.parseDrvName postgresql.name).version "8.4";

in

{

  ###### interface

  options = {

    services.postgresql = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run PostgreSQL.
        '';
      };

      package = mkOption {
        default = pkgs.postgresql;
        description = ''
          PostgreSQL package to use.
        '';
      };

      port = mkOption {
        default = "5432";
        description = ''
          Port for PostgreSQL.
        '';
      };

      logDir = mkOption {
        default = "/var/log/postgresql";
        description = ''
          Log directory for PostgreSQL.
        '';
      };

      dataDir = mkOption {
        default = "/var/db/postgresql";
        description = ''
          Data directory for PostgreSQL.
        '';
      };

      authentication = mkOption {
        default = "";
        description = ''
          Defines how users authenticate themselves to the server.
        '';
      };

      identMap = mkOption {
        default = "";
        description = ''
          Defines the mapping from system users to database users.
        '';
      };

      authMethod = mkOption {
        default = " ident sameuser ";
        description = ''
          How to authorize users.
          Note: ident needs absolute trust to all allowed client hosts.
        '';
      };

      enableTCPIP = mkOption {
        default = false;
        description = ''
          Whether to run PostgreSQL with -i flag to enable TCP/IP connections.
        '';
      };

      extraPlugins = mkOption {
        default = [];
        example = "pkgs.postgis"; # of course don't use a string here!
        description = ''
          When this list contains elements a new store path is created.
          PostgreSQL and the elments are symlinked into it. Then pg_config,
          postgres and pc_ctl are copied to make them use the new
          $out/lib directory as pkglibdir. This makes it possible to use postgis
          without patching the .sql files which reference $libdir/postgis-1.5.
        '';
        # Note: the duplication of executables is about 4MB size.
        # So a nicer solution was patching postgresql to allow setting the
        # libdir explicitely.
      };

      extraConfig = mkOption {
        default = "";
        description = "Additional text to be appended to <filename>postgresql.conf</filename>.";
      };
    };

  };


  ###### implementation

  config = mkIf config.services.postgresql.enable {

    services.postgresql.authentication =
      ''
        # Generated file; do not edit!
        local all all              ident ${optionalString pre84 "sameuser"}
        host  all all 127.0.0.1/32 md5
        host  all all ::1/128      md5
      '';

    users.extraUsers = singleton
      { name = "postgres";
        description = "PostgreSQL server user";
      };

    users.extraGroups = singleton
      { name = "postgres"; };

    environment.systemPackages = [postgresql];

    boot.systemd.services.postgresql =
      { description = "PostgreSQL Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment =
          { TZ = config.time.timeZone;
            PGDATA = cfg.dataDir;
          };

        path = [ pkgs.su postgresql ];

        preStart =
          ''
            # Initialise the database.
            if ! test -e ${cfg.dataDir}; then
                mkdir -m 0700 -p ${cfg.dataDir}
                chown -R postgres ${cfg.dataDir}
                su -s ${pkgs.stdenv.shell} postgres -c 'initdb -U root'
                rm -f ${cfg.dataDir}/*.conf
            fi

            ln -sfn ${configFile} ${cfg.dataDir}/postgresql.conf
          ''; # */

        serviceConfig =
          { ExecStart = "@${postgresql}/bin/postgres postgres ${toString flags}";
            User = "postgres";
            Group = "postgres";
            PermissionsStartOnly = true;

            # Shut down Postgres using SIGINT ("Fast Shutdown mode").  See
            # http://www.postgresql.org/docs/current/static/server-shutdown.html
            KillSignal = "SIGINT";

            # Give Postgres a decent amount of time to clean up after
            # receiving systemd's SIGINT.
            TimeoutSec = 60;
          };

        # Wait for PostgreSQL to be ready to accept connections.
        postStart =
          ''
            while ! psql postgres -c "" 2> /dev/null; do
                if ! kill -0 "$MAINPID"; then exit 1; fi
                sleep 0.1
            done
          '';

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";
      };

  };

}
