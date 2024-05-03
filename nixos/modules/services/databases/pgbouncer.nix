{ config, lib, utils, pkgs, ... }:
let
  cfg = config.services.pgbouncer;

  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "pgbouncer.ini" cfg.settings;
  configPath = "pgbouncer/pgbouncer.ini";
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "logFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "log_file" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "listenAddress" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "listen_addr" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "listenPort" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "listen_port" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "poolMode" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "pool_mode" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "maxClientConn" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "max_client_conn" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "defaultPoolSize" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "default_pool_size" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "maxDbConnections" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "max_db_connections" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "maxUserConnections" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "max_user_connections" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "ignoreStartupParameters" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "ignore_startup_parameters" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "databases" ]
      [ "services" "pgbouncer" "settings" "databases" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "users" ]
      [ "services" "pgbouncer" "settings" "users" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "peers" ]
      [ "services" "pgbouncer" "settings" "peers" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "authType" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "auth_type" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "authHbaFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "auth_hba_file" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "authFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "auth_file" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "authUser" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "auth_user" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "authQuery" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "auth_query" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "authDbname" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "auth_dbname" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "adminUsers" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "admin_users" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "statsUsers" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "stats_users" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "verbose" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "verbose" ])
    (lib.mkChangedOptionModule
      [ "services" "pgbouncer" "syslog" "enable" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "syslog" ]
      (config:
        let
          enable = lib.getAttrFromPath
            [ "services" "pgbouncer" "syslog" "enable" ]
            config;
        in
        if enable then 1 else 0))
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "syslog" "syslogIdent" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "syslog_ident" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "syslog" "syslogFacility" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "syslog_facility" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "tls" "client" "sslmode" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "client_tls_sslmode" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "tls" "client" "keyFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "client_tls_key_file" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "tls" "client" "certFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "client_tls_cert_file" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "tls" "client" "caFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "client_tls_ca_file" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "tls" "server" "sslmode" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "server_tls_sslmode" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "tls" "server" "keyFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "server_tls_key_file" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "tls" "server" "certFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "server_tls_cert_file" ])
    (lib.mkRenamedOptionModule
      [ "services" "pgbouncer" "tls" "server" "caFile" ]
      [ "services" "pgbouncer" "settings" "pgbouncer" "server_tls_ca_file" ])
    (lib.mkRemovedOptionModule [ "services" "pgbouncer" "extraConfig" ] "Use services.pgbouncer.settings instead.")
  ];

  options.services.pgbouncer = {
    enable = lib.mkEnableOption "PostgreSQL connection pooler";

    package = lib.mkPackageOption pkgs "pgbouncer" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to automatically open the specified TCP port in the firewall.
      '';
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Configuration for PgBouncer, see <https://www.pgbouncer.org/config.html>
        for supported values.
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

    user = lib.mkOption {
      type = lib.types.str;
      default = "pgbouncer";
      description = ''
        The user pgbouncer is run as.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "pgbouncer";
      description = ''
        The group pgbouncer is run as.
      '';
    };

    homeDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/pgbouncer";
      description = ''
        Specifies the home directory.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      description = "PgBouncer service user";
      group = cfg.group;
      home = cfg.homeDir;
      createHome = true;
      isSystemUser = true;
    };

    environment.etc.${configPath}.source = configFile;

    # Default to RuntimeDirectory instead of /tmp.
    services.pgbouncer.settings.pgbouncer.unix_socket_dir = lib.mkDefault "/run/pgbouncer";

    systemd.services.pgbouncer = {
      description = "PgBouncer - PostgreSQL connection pooler";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = [ configFile ];
      serviceConfig = {
        Type = "notify-reload";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe pkgs.pgbouncer)
          "/etc/${configPath}"
        ];
        RuntimeDirectory = "pgbouncer";
        LimitNOFILE = cfg.openFilesLimit;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        (cfg.settings.pgbouncer.listen_port or 6432)
      ];
    };
  };

  meta.maintainers = [ lib.maintainers._1000101 ];
}
