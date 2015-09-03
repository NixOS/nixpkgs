{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.grafana;

  b2s = val: if val then "true" else "false";

  cfgFile = pkgs.writeText "grafana.ini" ''
    app_name = grafana
    app_mode = production

    [server]
    ; protocol (http or https)
    protocol = ${cfg.protocol}
    ; the ip address to bind to, empty will bind to all interfaces
    http_addr = ${cfg.addr}
    ; the http port  to use
    http_port = ${toString cfg.port}
    ; The public facing domain name used to access grafana from a browser
    domain = ${cfg.domain}
    ; the full public facing url
    root_url = ${cfg.rootUrl}
    router_logging = false
    ; the path relative to the binary where the static (html/js/css) files are placed
    static_root_path = ${cfg.staticRootPath}
    ; enable gzip
    enable_gzip = false
    ; https certs & key file
    cert_file = ${cfg.certFile}
    cert_key = ${cfg.certKey}

    [analytics]
    # Server reporting, sends usage counters to stats.grafana.org every 24 hours.
    # No ip addresses are being tracked, only simple counters to track
    # running instances, dashboard and error counts. It is very helpful to us.
    # Change this option to false to disable reporting.
    reporting_enabled = true
    ; Google Analytics universal tracking code, only enabled if you specify an id here
    google_analytics_ua_id =

    [database]
    ; Either "mysql", "postgres" or "sqlite3", it's your choice
    type = ${cfg.database.type}
    host = ${cfg.database.host}
    name = ${cfg.database.name}
    user = ${cfg.database.user}
    password = ${cfg.database.password}
    ; For "postgres" only, either "disable", "require" or "verify-full"
    ssl_mode = disable
    ; For "sqlite3" only
    path = ${cfg.database.path}

    [session]
    ; Either "memory", "file", "redis", "mysql", default is "memory"
    provider = file
    ; Provider config options
    ; memory: not have any config yet
    ; file: session file path, e.g. `data/sessions`
    ; redis: config like redis server addr, poolSize, password, e.g. `127.0.0.1:6379,100,grafana`
    ; mysql: go-sql-driver/mysql dsn config string, e.g. `user:password@tcp(127.0.0.1)/database_name`
    provider_config = data/sessions
    ; Session cookie name
    cookie_name = grafana_sess
    ; If you use session in https only, default is false
    cookie_secure = false
    ; Session life time, default is 86400
    session_life_time = 86400
    ; session id hash func, Either "sha1", "sha256" or "md5" default is sha1
    session_id_hashfunc = sha1
    ; Session hash key, default is use random string
    session_id_hashkey =

    [security]
    ; default admin user, created on startup
    admin_user = ${cfg.security.adminUser}
    ; default admin password, can be changed before first start of grafana,  or in profile settings
    admin_password = ${cfg.security.adminPassword}
    ; used for signing
    secret_key = ${cfg.security.secretKey}
    ; Auto-login remember days
    login_remember_days = 7
    cookie_username = grafana_user
    cookie_remember_name = grafana_remember

    [users]
    ; disable user signup / registration
    allow_sign_up = ${b2s cfg.users.allowSignUp}
    ; Allow non admin users to create organizations
    allow_org_create = ${b2s cfg.users.allowOrgCreate}
    # Set to true to automatically assign new users to the default organization (id 1)
    auto_assign_org = ${b2s cfg.users.autoAssignOrg}
    ; Default role new users will be automatically assigned (if disabled above is set to true)
    auto_assign_org_role = ${cfg.users.autoAssignOrgRole}

    [auth.anonymous]
    ; enable anonymous access
    enabled = ${b2s cfg.auth.anonymous.enable}
    ; specify organization name that should be used for unauthenticated users
    org_name = Main Org.
    ; specify role for unauthenticated users
    org_role = Viewer

    [auth.github]
    enabled = false
    client_id = some_id
    client_secret = some_secret
    scopes = user:email
    auth_url = https://github.com/login/oauth/authorize
    token_url = https://github.com/login/oauth/access_token

    [auth.google]
    enabled = false
    client_id = some_client_id
    client_secret = some_client_secret
    scopes = https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email
    auth_url = https://accounts.google.com/o/oauth2/auth
    token_url = https://accounts.google.com/o/oauth2/token

    [log]
    root_path = data/log
    ; Either "console", "file", default is "console"
    ; Use comma to separate multiple modes, e.g. "console, file"
    mode = console
    ; Buffer length of channel, keep it as it is if you don't know what it is.
    buffer_len = 10000
    ; Either "Trace", "Debug", "Info", "Warn", "Error", "Critical", default is "Trace"
    level = Info

    ; For "console" mode only
    [log.console]
    level =

    ; For "file" mode only
    [log.file]
    level =
    ; This enables automated log rotate(switch of following options), default is true
    log_rotate = true
    ; Max line number of single file, default is 1000000
    max_lines = 1000000
    ; Max size shift of single file, default is 28 means 1 << 28, 256MB
    max_lines_shift = 28
    ; Segment log daily, default is true
    daily_rotate = true
    ; Expired days of log file(delete after max days), default is 7
    max_days = 7

    [event_publisher]
    enabled = false
    rabbitmq_url = amqp://localhost/
    exchange = grafana_events
  '';

in {
  options.services.grafana = {
    enable = mkEnableOption "grafana";

    protocol = mkOption {
      description = "Which protocol to listen.";
      default = "http";
      type = types.enum ["http" "https"];
    };

    addr = mkOption {
      description = "Listening address.";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = "Listening port.";
      default = 3000;
      type = types.int;
    };

    domain = mkOption {
      description = "The public facing domain name used to access grafana from a browser.";
      default = "localhost";
      type = types.str;
    };

    rootUrl = mkOption {
      description = "Full public facing url.";
      default = "%(protocol)s://%(domain)s:%(http_port)s/";
      type = types.str;
    };

    certFile = mkOption {
      description = "Cert file for ssl.";
      default = "";
      type = types.str;
    };

    certKey = mkOption {
      description = "Cert key for ssl.";
      default = "";
      type = types.str;
    };

    staticRootPath = mkOption {
      description = "Root path for static assets.";
      default = "${cfg.package.out}/share/go/src/github.com/grafana/grafana/public";
      type = types.str;
    };

    package = mkOption {
      description = "Package to use.";
      default = pkgs.grafana-backend;
      type = types.package;
    };

    dataDir = mkOption {
      description = "Data directory.";
      default = "/var/lib/grafana";
      type = types.path;
    };

    database = {
      type = mkOption {
        description = "Database type.";
        default = "sqlite3";
        type = types.enum ["mysql" "sqlite3" "postgresql"];
      };

      host = mkOption {
        description = "Database host.";
        default = "127.0.0.1:3306";
        type = types.str;
      };

      name = mkOption {
        description = "Database name.";
        default = "grafana";
        type = types.str;
      };

      user = mkOption {
        description = "Database user.";
        default = "root";
        type = types.str;
      };

      password = mkOption {
        description = "Database password.";
        default = "";
        type = types.str;
      };

      path = mkOption {
        description = "Database path.";
        default = "${cfg.dataDir}/data/grafana.db";
        type = types.path;
      };
    };

    security = {
      adminUser = mkOption {
        description = "Default admin username.";
        default = "admin";
        type = types.str;
      };

      adminPassword = mkOption {
        description = "Default admin password.";
        default = "admin";
        type = types.str;
      };

      secretKey = mkOption {
        description = "Secret key used for signing.";
        default = "SW2YcwTIb9zpOOhoPsMm";
        type = types.str;
      };
    };

    users = {
      allowSignUp = mkOption {
        description = "Disable user signup / registration";
        default = false;
        type = types.bool;
      };

      allowOrgCreate = mkOption {
        description = "Whether user is allowed to create organizations.";
        default = false;
        type = types.bool;
      };

      autoAssignOrg = mkOption {
        description = "Whether to automatically assign new users to default org.";
        default = true;
        type = types.bool;
      };

      autoAssignOrgRole = mkOption {
        description = "Default role new users will be auto assigned.";
        default = "Viewer";
        type = types.enum ["Viewer" "Editor"];
      };
    };

    auth.anonymous = {
      enable = mkOption {
        description = "Whether to allow anonymous access";
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = [
      "Grafana passwords will be stored as plaintext in nix store!"
    ];

    systemd.services.grafana = {
      description = "Grafana Service Daemon";
      wantedBy = ["multi-user.target"];
      after = ["networking.target"];
      serviceConfig = {
        ExecStart = "${cfg.package-backend}/bin/grafana --config ${cfgFile} web";
        WorkingDirectory = cfg.dataDir;
        User = "grafana";
      };
    };

    users.extraUsers.grafana = {
      uid = config.ids.uids.grafana;
      description = "Grafana user";
      home = cfg.dataDir;
      createHome = true;
    };
  };
}
