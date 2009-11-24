{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf singleton;

  cfg = config.services.postgresql;

  postgresql = pkgs.postgresql;

  startDependency = if config.services.gw6c.enable then 
    "gw6c" else "network-interfaces";

  run = "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} postgres";

  flags = if cfg.enableTCPIP then ["-i"] else [];

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
      
      subServices = mkOption {
        default = [];
        description = ''
          Subservices list. As it is already implememnted, 
          here is an interface...
        '';
      };
      
      authentication = mkOption {
        default = ''
          # Generated file; do not edit!
          local all all              ident sameuser
          host  all all 127.0.0.1/32 md5
          host  all all ::1/128      md5
        '';
        description = ''
          Hosts (except localhost), who you allow to connect.
        '';
      };
      
      allowedHosts = mkOption {
        default = [];
        description = ''
          Hosts (except localhost), who you allow to connect.
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
            fi
            
            cp -f ${pkgs.writeText "pg_hba.conf" cfg.authentication} ${cfg.dataDir}/pg_hba.conf

            # We'd like to use the `-w' flag here to wait until the
            # database is up, but it requires a `postgres' user to
            # exist.  And we can't call `createuser' before the
            # database is running.
            ${run} -c '${postgresql}/bin/pg_ctl start -o "${toString flags}"'

            # So wait until the server is running.
            while ! ${run} -c '${postgresql}/bin/pg_ctl status'; do
                sleep 1
            done
          '';

        postStop =
          ''
            ${run} -c '${postgresql}/bin/pg_ctl stop -m fast'
          '';
      };

  };
  
}
