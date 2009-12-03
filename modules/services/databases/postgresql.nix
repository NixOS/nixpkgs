{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.postgresql;

  postgresql = pkgs.postgresql;

  startDependency = if config.services.gw6c.enable then 
    "gw6c" else "network-interfaces";

  run = "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} postgres";

  flags = optional cfg.enableTCPIP "-i";

  # The main PostgreSQL configuration file.
  configFile = pkgs.writeText "postgresql.conf"
    ''
      hba_file = '${pkgs.writeText "pg_hba.conf" cfg.authentication}'
      ident_file = '${pkgs.writeText "pg_ident.conf" cfg.identMap}'
      log_destination = 'syslog'
    '';  

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
        default = ''
          # Generated file; do not edit!
          local all mediawiki        ident mediawiki-users
          local all all              ident sameuser
          host  all all 127.0.0.1/32 md5
          host  all all ::1/128      md5
        '';
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
      
    };

  };


  ###### implementation
  
  config = mkIf config.services.postgresql.enable {

    users.extraUsers = singleton
      { name = "postgres";
        description = "PostgreSQL server user";
      };

    users.extraGroups = singleton
      { name = "postgres"; };

    environment.systemPackages = [postgresql];

    # !!! This should be be in the mediawiki module, obviously.
    services.postgresql.identMap =
      ''
        mediawiki-users root   mediawiki
        mediawiki-users wwwrun mediawiki
      '';

    jobs.postgresql =
      { description = "PostgreSQL server";

        startOn = "started ${startDependency}";

        environment =
          { TZ = config.time.timeZone;
            PGDATA = cfg.dataDir;
          };

        preStart =
          ''
            # Initialise the database.
            if ! test -e ${cfg.dataDir}; then
                mkdir -m 0700 -p ${cfg.dataDir}
                chown -R postgres ${cfg.dataDir}
                ${run} -c '${postgresql}/bin/initdb -U root'
                rm -f ${cfg.dataDir}/*.conf
            fi

            ln -sfn ${configFile} ${cfg.dataDir}/postgresql.conf

            # We'd like to use the `-w' flag here to wait until the
            # database is up, but it requires a `postgres' user to
            # exist.  And we can't call `createuser' before the
            # database is running.
            ${run} -c '${postgresql}/bin/pg_ctl start -o "${toString flags}"'

            # So wait until the server is running.
            while ! ${run} -c '${postgresql}/bin/pg_ctl status'; do
                sleep 1
            done
          ''; # */

        postStop =
          ''
            ${run} -c '${postgresql}/bin/pg_ctl stop -m fast'
          '';
      };

  };
  
}
