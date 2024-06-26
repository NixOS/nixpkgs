{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.services.pgbouncer;

  confFile = pkgs.writeTextFile {
    name = "pgbouncer.ini";
    text = ''
      [databases]
      ${concatStringsSep "\n" (
        mapAttrsToList (dbname: settings: "${dbname} = ${settings}") cfg.databases
      )}

      [users]
      ${concatStringsSep "\n" (
        mapAttrsToList (username: settings: "${username} = ${settings}") cfg.users
      )}

      [peers]
      ${concatStringsSep "\n" (mapAttrsToList (peerid: settings: "${peerid} = ${settings}") cfg.peers)}

      [pgbouncer]
      # general
      ${optionalString (
        cfg.ignoreStartupParameters != null
      ) "ignore_startup_parameters = ${cfg.ignoreStartupParameters}"}
      listen_port = ${toString cfg.listenPort}
      ${optionalString (cfg.listenAddress != null) "listen_addr = ${cfg.listenAddress}"}
      pool_mode = ${cfg.poolMode}
      max_client_conn = ${toString cfg.maxClientConn}
      default_pool_size = ${toString cfg.defaultPoolSize}
      max_user_connections = ${toString cfg.maxUserConnections}
      max_db_connections = ${toString cfg.maxDbConnections}

      #auth
      auth_type = ${cfg.authType}
      ${optionalString (cfg.authHbaFile != null) "auth_hba_file = ${cfg.authHbaFile}"}
      ${optionalString (cfg.authFile != null) "auth_file = ${cfg.authFile}"}
      ${optionalString (cfg.authUser != null) "auth_user = ${cfg.authUser}"}
      ${optionalString (cfg.authQuery != null) "auth_query = ${cfg.authQuery}"}
      ${optionalString (cfg.authDbname != null) "auth_dbname = ${cfg.authDbname}"}

      # TLS
      ${optionalString (cfg.tls.client != null) ''
        client_tls_sslmode = ${cfg.tls.client.sslmode}
        client_tls_key_file = ${cfg.tls.client.keyFile}
        client_tls_cert_file = ${cfg.tls.client.certFile}
        client_tls_ca_file = ${cfg.tls.client.caFile}
      ''}
      ${optionalString (cfg.tls.server != null) ''
        server_tls_sslmode = ${cfg.tls.server.sslmode}
        server_tls_key_file = ${cfg.tls.server.keyFile}
        server_tls_cert_file = ${cfg.tls.server.certFile}
        server_tls_ca_file = ${cfg.tls.server.caFile}
      ''}

      # log
      ${optionalString (cfg.logFile != null) "logfile = ${cfg.homeDir}/${cfg.logFile}"}
      ${optionalString (cfg.syslog != null) ''
        syslog = ${if cfg.syslog.enable then "1" else "0"}
        syslog_ident = ${cfg.syslog.syslogIdent}
        syslog_facility = ${cfg.syslog.syslogFacility}
      ''}
      ${optionalString (cfg.verbose != null) "verbose = ${toString cfg.verbose}"}

      # console access
      ${optionalString (cfg.adminUsers != null) "admin_users = ${cfg.adminUsers}"}
      ${optionalString (cfg.statsUsers != null) "stats_users = ${cfg.statsUsers}"}

      # extra
      ${cfg.extraConfig}
    '';
  };

in
{

  options.services.pgbouncer = {

    # NixOS settings

    enable = mkEnableOption "PostgreSQL connection pooler";

    package = mkPackageOption pkgs "pgbouncer" { };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to automatically open the specified TCP port in the firewall.
      '';
    };

    # Generic settings

    logFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Specifies a log file in addition to journald.
      '';
    };

    listenAddress = mkOption {
      type = types.nullOr types.commas;
      example = "*";
      default = null;
      description = ''
        Specifies a list (comma-separated) of addresses where to listen for TCP connections.
        You may also use * meaning “listen on all addresses”.
        When not set, only Unix socket connections are accepted.

        Addresses can be specified numerically (IPv4/IPv6) or by name.
      '';
    };

    listenPort = mkOption {
      type = types.port;
      default = 6432;
      description = ''
        Which port to listen on. Applies to both TCP and Unix sockets.
      '';
    };

    poolMode = mkOption {
      type = types.enum [
        "session"
        "transaction"
        "statement"
      ];
      default = "session";
      description = ''
        Specifies when a server connection can be reused by other clients.

        session
            Server is released back to pool after client disconnects. Default.
        transaction
            Server is released back to pool after transaction finishes.
        statement
            Server is released back to pool after query finishes.
            Transactions spanning multiple statements are disallowed in this mode.
      '';
    };

    maxClientConn = mkOption {
      type = types.int;
      default = 100;
      description = ''
        Maximum number of client connections allowed.

        When this setting is increased, then the file descriptor limits in the operating system
        might also have to be increased. Note that the number of file descriptors potentially
        used is more than maxClientConn. If each user connects under its own user name to the server,
        the theoretical maximum used is:
        maxClientConn + (max pool_size * total databases * total users)

        If a database user is specified in the connection string (all users connect under the same user name),
        the theoretical maximum is:
        maxClientConn + (max pool_size * total databases)

        The theoretical maximum should never be reached, unless somebody deliberately crafts a special load for it.
        Still, it means you should set the number of file descriptors to a safely high number.
      '';
    };

    defaultPoolSize = mkOption {
      type = types.int;
      default = 20;
      description = ''
        How many server connections to allow per user/database pair.
        Can be overridden in the per-database configuration.
      '';
    };

    maxDbConnections = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Do not allow more than this many server connections per database (regardless of user).
        This considers the PgBouncer database that the client has connected to,
        not the PostgreSQL database of the outgoing connection.

        This can also be set per database in the [databases] section.

        Note that when you hit the limit, closing a client connection to one pool will
        not immediately allow a server connection to be established for another pool,
        because the server connection for the first pool is still open.
        Once the server connection closes (due to idle timeout),
        a new server connection will immediately be opened for the waiting pool.

        0 = unlimited
      '';
    };

    maxUserConnections = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Do not allow more than this many server connections per user (regardless of database).
        This considers the PgBouncer user that is associated with a pool,
        which is either the user specified for the server connection
        or in absence of that the user the client has connected as.

        This can also be set per user in the [users] section.

        Note that when you hit the limit, closing a client connection to one pool
        will not immediately allow a server connection to be established for another pool,
        because the server connection for the first pool is still open.
        Once the server connection closes (due to idle timeout), a new server connection
        will immediately be opened for the waiting pool.

        0 = unlimited
      '';
    };

    ignoreStartupParameters = mkOption {
      type = types.nullOr types.commas;
      example = "extra_float_digits";
      default = null;
      description = ''
        By default, PgBouncer allows only parameters it can keep track of in startup packets:
        client_encoding, datestyle, timezone and standard_conforming_strings.

        All others parameters will raise an error.
        To allow others parameters, they can be specified here, so that PgBouncer knows that
        they are handled by the admin and it can ignore them.

        If you need to specify multiple values, use a comma-separated list.

        IMPORTANT: When using prometheus-pgbouncer-exporter, you need:
        extra_float_digits
        <https://github.com/prometheus-community/pgbouncer_exporter#pgbouncer-configuration>
      '';
    };

    # Section [databases]
    databases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        exampledb = "host=/run/postgresql/ port=5432 auth_user=exampleuser dbname=exampledb sslmode=require";
        bardb = "host=localhost dbname=bazdb";
        foodb = "host=host1.example.com port=5432";
      };
      description = ''
        Detailed information about PostgreSQL database definitions:
        <https://www.pgbouncer.org/config.html#section-databases>
      '';
    };

    # Section [users]
    users = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        user1 = "pool_mode=session";
      };
      description = ''
        Optional.

        Detailed information about PostgreSQL user definitions:
        <https://www.pgbouncer.org/config.html#section-users>
      '';
    };

    # Section [peers]
    peers = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        "1" = "host=host1.example.com";
        "2" = "host=/tmp/pgbouncer-2 port=5555";
      };
      description = ''
        Optional.

        Detailed information about PostgreSQL database definitions:
        <https://www.pgbouncer.org/config.html#section-peers>
      '';
    };

    # Authentication settings
    authType = mkOption {
      type = types.enum [
        "cert"
        "md5"
        "scram-sha-256"
        "plain"
        "trust"
        "any"
        "hba"
        "pam"
      ];
      default = "md5";
      description = ''
        How to authenticate users.

        cert
            Client must connect over TLS connection with a valid client certificate.
            The user name is then taken from the CommonName field from the certificate.
        md5
            Use MD5-based password check. This is the default authentication method.
            authFile may contain both MD5-encrypted and plain-text passwords.
            If md5 is configured and a user has a SCRAM secret, then SCRAM authentication is used automatically instead.
        scram-sha-256
            Use password check with SCRAM-SHA-256. authFile has to contain SCRAM secrets or plain-text passwords.
        plain
            The clear-text password is sent over the wire. Deprecated.
        trust
            No authentication is done. The user name must still exist in authFile.
        any
            Like the trust method, but the user name given is ignored.
            Requires that all databases are configured to log in as a specific user.
            Additionally, the console database allows any user to log in as admin.
        hba
            The actual authentication type is loaded from authHbaFile.
            This allows different authentication methods for different access paths,
            for example: connections over Unix socket use the peer auth method, connections over TCP must use TLS.
        pam
            PAM is used to authenticate users, authFile is ignored.
            This method is not compatible with databases using the authUser option.
            The service name reported to PAM is “pgbouncer”. pam is not supported in the HBA configuration file.
      '';
    };

    authHbaFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/secrets/pgbouncer_hba";
      description = ''
        HBA configuration file to use when authType is hba.

        See HBA file format details:
        <https://www.pgbouncer.org/config.html#hba-file-format>
      '';
    };

    authFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/secrets/pgbouncer_authfile";
      description = ''
        The name of the file to load user names and passwords from.

        See section Authentication file format details:
        <https://www.pgbouncer.org/config.html#authentication-file-format>

        Most authentication types require that either authFile or authUser be set;
        otherwise there would be no users defined.
      '';
    };

    authUser = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "pgbouncer";
      description = ''
        If authUser is set, then any user not specified in authFile will be queried
        through the authQuery query from pg_shadow in the database, using authUser.
        The password of authUser will be taken from authFile.
        (If the authUser does not require a password then it does not need to be defined in authFile.)

        Direct access to pg_shadow requires admin rights.
        It's preferable to use a non-superuser that calls a SECURITY DEFINER function instead.
      '';
    };

    authQuery = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "SELECT usename, passwd FROM pg_shadow WHERE usename=$1";
      description = ''
        Query to load user's password from database.

        Direct access to pg_shadow requires admin rights.
        It's preferable to use a non-superuser that calls a SECURITY DEFINER function instead.

        Note that the query is run inside the target database.
        So if a function is used, it needs to be installed into each database.
      '';
    };

    authDbname = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "authdb";
      description = ''
        Database name in the [database] section to be used for authentication purposes.
        This option can be either global or overriden in the connection string if this parameter is specified.
      '';
    };

    # TLS settings
    tls.client = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            sslmode = mkOption {
              type = types.enum [
                "disable"
                "allow"
                "prefer"
                "require"
                "verify-ca"
                "verify-full"
              ];
              default = "disable";
              description = ''
                TLS mode to use for connections from clients.
                TLS connections are disabled by default.

                When enabled, tls.client.keyFile and tls.client.certFile
                must be also configured to set up the key and certificate
                PgBouncer uses to accept client connections.

                disable
                    Plain TCP. If client requests TLS, it's ignored. Default.
                allow
                    If client requests TLS, it is used. If not, plain TCP is used.
                    If the client presents a client certificate, it is not validated.
                prefer
                    Same as allow.
                require
                    Client must use TLS. If not, the client connection is rejected.
                    If the client presents a client certificate, it is not validated.
                verify-ca
                    Client must use TLS with valid client certificate.
                verify-full
                    Same as verify-ca
              '';
            };
            certFile = mkOption {
              type = types.path;
              example = "/secrets/pgbouncer.key";
              description = "Path to certificate for private key. Clients can validate it";
            };
            keyFile = mkOption {
              type = types.path;
              example = "/secrets/pgbouncer.crt";
              description = "Path to private key for PgBouncer to accept client connections";
            };
            caFile = mkOption {
              type = types.path;
              example = "/secrets/pgbouncer.crt";
              description = "Path to root certificate file to validate client certificates";
            };
          };
        }
      );
      default = null;
      description = ''
        <https://www.pgbouncer.org/config.html#tls-settings>
      '';
    };

    tls.server = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            sslmode = mkOption {
              type = types.enum [
                "disable"
                "allow"
                "prefer"
                "require"
                "verify-ca"
                "verify-full"
              ];
              default = "disable";
              description = ''
                TLS mode to use for connections to PostgreSQL servers.
                TLS connections are disabled by default.

                disable
                    Plain TCP. TLS is not even requested from the server. Default.
                allow
                    FIXME: if server rejects plain, try TLS?
                prefer
                    TLS connection is always requested first from PostgreSQL.
                    If refused, the connection will be established over plain TCP.
                    Server certificate is not validated.
                require
                    Connection must go over TLS. If server rejects it, plain TCP is not attempted.
                    Server certificate is not validated.
                verify-ca
                    Connection must go over TLS and server certificate must be valid according to tls.server.caFile.
                    Server host name is not checked against certificate.
                verify-full
                    Connection must go over TLS and server certificate must be valid according to tls.server.caFile.
                    Server host name must match certificate information.
              '';
            };
            certFile = mkOption {
              type = types.path;
              example = "/secrets/pgbouncer_server.key";
              description = "Certificate for private key. PostgreSQL server can validate it.";
            };
            keyFile = mkOption {
              type = types.path;
              example = "/secrets/pgbouncer_server.crt";
              description = "Private key for PgBouncer to authenticate against PostgreSQL server.";
            };
            caFile = mkOption {
              type = types.path;
              example = "/secrets/pgbouncer_server.crt";
              description = "Root certificate file to validate PostgreSQL server certificates.";
            };
          };
        }
      );
      default = null;
      description = ''
        <https://www.pgbouncer.org/config.html#tls-settings>
      '';
    };

    # Log settings
    syslog = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Toggles syslog on/off.
              '';
            };
            syslogIdent = mkOption {
              type = types.str;
              default = "pgbouncer";
              description = ''
                Under what name to send logs to syslog.
              '';
            };
            syslogFacility = mkOption {
              type = types.enum [
                "auth"
                "authpriv"
                "daemon"
                "user"
                "local0"
                "local1"
                "local2"
                "local3"
                "local4"
                "local5"
                "local6"
                "local7"
              ];
              default = "daemon";
              description = ''
                Under what facility to send logs to syslog.
              '';
            };
          };
        }
      );
      default = null;
      description = ''
        <https://www.pgbouncer.org/config.html#log-settings>
      '';
    };

    verbose = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = ''
        Increase verbosity. Mirrors the “-v” switch on the command line.
      '';
    };

    # Console access control
    adminUsers = mkOption {
      type = types.nullOr types.commas;
      default = null;
      description = ''
        Comma-separated list of database users that are allowed to connect and run all commands on the console.
        Ignored when authType is any, in which case any user name is allowed in as admin.
      '';
    };

    statsUsers = mkOption {
      type = types.nullOr types.commas;
      default = null;
      description = ''
        Comma-separated list of database users that are allowed to connect and run read-only queries on the console.
        That means all SHOW commands except SHOW FDS.
      '';
    };

    # Linux settings
    openFilesLimit = lib.mkOption {
      type = lib.types.int;
      default = 65536;
      description = ''
        Maximum number of open files.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "pgbouncer";
      description = ''
        The user pgbouncer is run as.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "pgbouncer";
      description = ''
        The group pgbouncer is run as.
      '';
    };

    homeDir = mkOption {
      type = types.path;
      default = "/var/lib/pgbouncer";
      description = ''
        Specifies the home directory.
      '';
    };

    # Extra settings
    extraConfig = mkOption {
      type = types.lines;
      description = ''
        Any additional text to be appended to config.ini
         <https://www.pgbouncer.org/config.html>.
      '';
      default = "";
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      description = "PgBouncer service user";
      group = cfg.group;
      home = cfg.homeDir;
      createHome = true;
      isSystemUser = true;
    };

    systemd.services.pgbouncer = {
      description = "PgBouncer - PostgreSQL connection pooler";
      wants = [
        "network-online.target"
      ] ++ lib.optional config.services.postgresql.enable "postgresql.service";
      after = [
        "network-online.target"
      ] ++ lib.optional config.services.postgresql.enable "postgresql.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe pkgs.pgbouncer} ${confFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        RuntimeDirectory = "pgbouncer";
        LimitNOFILE = cfg.openFilesLimit;
      };
    };

    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.listenPort;

  };

  meta.maintainers = [ maintainers._1000101 ];

}
