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

      ${optionalString (!isNull cfg.loginGroup) "login_group = ${cfg.loginGroup}"}

      login_timeout = ${toString cfg.loginTimeout}

      web_root = ${cfg.package}/etc/pgmanage/web_root

      data_root = ${cfg.dataRoot}

      ${optionalString (!isNull cfg.tls) ''
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
    enable = mkEnableOption "PostgreSQL Administration for the web";

    package = mkOption {
      type = types.package;
      default = pkgs.pgmanage;
      defaultText = "pkgs.pgmanage";
      description = ''
        The pgmanage package to use.
      '';
    };

    connections = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        "nuc-server"  = "hostaddr=192.168.0.100 port=5432 dbname=postgres";
        "mini-server" = "hostaddr=127.0.0.1 port=5432 dbname=postgres sslmode=require";
      };
      description = ''
        pgmanage requires at least one PostgreSQL server be defined.
        </para><para>
        Detailed information about PostgreSQL connection strings is available at:
        <link xlink:href="http://www.postgresql.org/docs/current/static/libpq-connect.html"/>
        </para><para>
        Note that you should not specify your user name or password. That
        information will be entered on the login screen. If you specify a
        username or password, it will be removed by pgmanage before attempting to
        connect to a database.
      '';
    };

    allowCustomConnections = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This tells pgmanage whether or not to allow anyone to use a custom
        connection from the login screen.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8080;
      description = ''
        This tells pgmanage what port to listen on for browser requests.
      '';
    };

    localOnly = mkOption {
      type = types.bool;
      default = true;
      description = ''
        This tells pgmanage whether or not to set the listening socket to local
        addresses only.
      '';
    };

    superOnly = mkOption {
      type = types.bool;
      default = true;
      description = ''
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
      description = ''
        This tells pgmanage to only allow users in a certain PostgreSQL group to
        login to pgmanage. Note that a connection will be made to PostgreSQL in
        order to test if the user is a member of the login group.
      '';
    };

    loginTimeout = mkOption {
      type = types.int;
      default = 3600;
      description = ''
        Number of seconds of inactivity before user is automatically logged
        out.
      '';
    };

    dataRoot = mkOption {
      type = types.str;
      default = "/var/lib/pgmanage";
      description = ''
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
            description = "TLS certificate";
          };
          key = mkOption {
            type = types.str;
            description = "TLS key";
          };
        };
      });
      default = null;
      description = ''
        These options tell pgmanage where the TLS Certificate and Key files
        reside. If you use these options then you'll only be able to access
        pgmanage through a secure TLS connection. These options are only
        necessary if you wish to connect directly to pgmanage using a secure TLS
        connection. As an alternative, you can set up pgmanage in a reverse proxy
        configuration. This allows your web server to terminate the secure
        connection and pass on the request to pgmanage. You can find help to set
        up this configuration in:
        <link xlink:href="https://github.com/pgManage/pgManage/blob/master/INSTALL_NGINX.md"/>
      '';
    };

    logLevel = mkOption {
      type = types.enum ["error" "warn" "notice" "info"];
      default = "error";
      description = ''
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
        ExecStart    = "${pkgs.pgmanage}/sbin/pgmanage -c ${confFile}" +
                       optionalString cfg.localOnly " --local-only=true";
      };
    };
    users = {
      users."${pgmanage}" = {
        name  = pgmanage;
        group = pgmanage;
        home  = cfg.dataRoot;
        createHome = true;
      };
      groups."${pgmanage}" = {
        name = pgmanage;
      };
    };
  };
}
