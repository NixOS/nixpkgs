{ lib, pkgs, config, ... } :

with lib;

let
  cfg = config.services.pgmanage;

  confFile = pkgs.writeTextFile {
    name = "pgmanage.conf";
    text =  ''
      connection_file = ${pgmanageConnectionsFile}

      allow_custom_connections = ${builtins.toJSON cfg.allowCustomConnections}

      pgmanage_port = ${toString cfg.port}

      super_only = ${builtins.toJSON cfg.superOnly}

      ${optionalString (cfg.loginGroup != null) "login_group = ${cfg.loginGroup}"}

      login_timeout = ${toString cfg.loginTimeout}

      web_root = ${cfg.package}/etc/pgmanage/web_root

      sql_root = ${cfg.sqlRoot}

      ${optionalString (cfg.tls != null) ''
      tls_cert = ${cfg.tls.cert}
      tls_key = ${cfg.tls.key}
      ''}

      log_level = ${cfg.logLevel}
    '';
  };

  pgmanageConnectionsFile = pkgs.writeTextFile {
    name = "pgmanage-connections.conf";
    text = concatStringsSep "\n"
      (mapAttrsToList (name : conn : "${name}: ${conn}") cfg.connections);
  };

  pgmanage = "pgmanage";

in {

  options.services.pgmanage = {
    enable = mkEnableOption (lib.mdDoc "PostgreSQL Administration for the web");

    package = mkPackageOption pkgs "pgmanage" { };

    connections = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        nuc-server  = "hostaddr=192.168.0.100 port=5432 dbname=postgres";
        mini-server = "hostaddr=127.0.0.1 port=5432 dbname=postgres sslmode=require";
      };
      description = lib.mdDoc ''
        pgmanage requires at least one PostgreSQL server be defined.

        Detailed information about PostgreSQL connection strings is available at:
        <https://www.postgresql.org/docs/current/libpq-connect.html>

        Note that you should not specify your user name or password. That
        information will be entered on the login screen. If you specify a
        username or password, it will be removed by pgmanage before attempting to
        connect to a database.
      '';
    };

    allowCustomConnections = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        This tells pgmanage whether or not to allow anyone to use a custom
        connection from the login screen.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        This tells pgmanage what port to listen on for browser requests.
      '';
    };

    localOnly = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        This tells pgmanage whether or not to set the listening socket to local
        addresses only.
      '';
    };

    superOnly = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        This tells pgmanage whether or not to only allow super users to
        login. The recommended value is true and will restrict users who are not
        super users from logging in to any PostgreSQL instance through
        pgmanage. Note that a connection will be made to PostgreSQL in order to
        test if the user is a superuser.
      '';
    };

    loginGroup = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        This tells pgmanage to only allow users in a certain PostgreSQL group to
        login to pgmanage. Note that a connection will be made to PostgreSQL in
        order to test if the user is a member of the login group.
      '';
    };

    loginTimeout = mkOption {
      type = types.int;
      default = 3600;
      description = lib.mdDoc ''
        Number of seconds of inactivity before user is automatically logged
        out.
      '';
    };

    sqlRoot = mkOption {
      type = types.str;
      default = "/var/lib/pgmanage";
      description = lib.mdDoc ''
        This tells pgmanage where to put the SQL file history. All tabs are saved
        to this location so that if you get disconnected from pgmanage you
        don't lose your work.
      '';
    };

    tls = mkOption {
      type = types.nullOr (types.submodule {
        options = {
          cert = mkOption {
            type = types.str;
            description = lib.mdDoc "TLS certificate";
          };
          key = mkOption {
            type = types.str;
            description = lib.mdDoc "TLS key";
          };
        };
      });
      default = null;
      description = lib.mdDoc ''
        These options tell pgmanage where the TLS Certificate and Key files
        reside. If you use these options then you'll only be able to access
        pgmanage through a secure TLS connection. These options are only
        necessary if you wish to connect directly to pgmanage using a secure TLS
        connection. As an alternative, you can set up pgmanage in a reverse proxy
        configuration. This allows your web server to terminate the secure
        connection and pass on the request to pgmanage. You can find help to set
        up this configuration in:
        <https://github.com/pgManage/pgManage/blob/master/INSTALL_NGINX.md>
      '';
    };

    logLevel = mkOption {
      type = types.enum ["error" "warn" "notice" "info"];
      default = "error";
      description = lib.mdDoc ''
        Verbosity of logs
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pgmanage = {
      description = "pgmanage - PostgreSQL Administration for the web";
      wants    = [ "postgresql.service" ];
      after    = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User         = pgmanage;
        Group        = pgmanage;
        ExecStart    = "${cfg.package}/sbin/pgmanage -c ${confFile}" +
                       optionalString cfg.localOnly " --local-only=true";
      };
    };
    users = {
      users.${pgmanage} = {
        name  = pgmanage;
        group = pgmanage;
        home  = cfg.sqlRoot;
        createHome = true;
        isSystemUser = true;
      };
      groups.${pgmanage} = {
        name = pgmanage;
      };
    };
  };
}
