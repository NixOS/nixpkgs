{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.grafana2;

  b2s = val: if val then "true" else "false";

  cfgFile = pkgs.writeText "grafana.ini" ''
    app_mode = production

    [paths]
    data = ${cfg.dataDir}
    logs = ${cfg.dataDir}/log

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
    static_root_path = ${cfg.package}/public
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
    org_role = ${cfg.auth.anonymous.role}

    [log]
    ; Either "console", "file", default is "console"
    ; Use comma to separate multiple modes, e.g. "console, file"
    mode = console
    ; Buffer length of channel, keep it as it is if you don't know what it is.
    buffer_len = 10000
    ; Either "Trace", "Debug", "Info", "Warn", "Error", "Critical", default is "Trace"
    level = Info
  '';

in {
  options.services.grafana2 = {
    enable = mkEnableOption "Whether to enable grafana.";

    protocol = mkOption {
      description = "Which protocol to listen.";
      default = "http";
      type = types.enum ["http" "https"];
    };

    addr = mkOption {
      description = "Listening address.";
      default = "0.0.0.0";
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

    package = mkOption {
      description = "Package to use.";
      default = pkgs.grafana2;
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

      role = mkOption {
        description = "The role of anonymous users";
        default = "Viewer";
        type = types.enum ["Viewer" "Editor" "Admin"];
      };
    };

    datasource = {
      name = mkOption {
        description = "The name of the datasource to create, if any";
        default = null;
        type = types.nullOr types.str;
      };

      type = mkOption {
        description = "The backend type of the datasource";
        default = "influxdb_08";
        type = types.enum ["elasticsearch" "grafana" "graphite" "influxdb" "influxdb_08" "opentsdb"];
      };

      url = mkOption {
        description = "The URL of the datasource backend";
        default = "";
        type = types.str;
      };

      access = mkOption {
        description = "The access type for the datasource";
        default = "proxy";
        type = types.enum ["direct" "proxy"];
      };

      user = mkOption {
        description = "The username for the datasource's backend";
        default = "root";
        type = types.str;
      };

      password = mkOption {
        description = "The password for the datasource's backend";
        default = "root";
        type = types.str;
      };

      database = mkOption {
        description = "The database for the datasource's backend";
        default = "";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = [
      "Grafana passwords will be stored as plaintext in nix store!"
    ];

    systemd.services.grafana2 = {
      description = "Grafana Service Daemon";
      wantedBy = ["multi-user.target"];
      after = ["networking.target"];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/grafana-server --config ${cfgFile} web";
        WorkingDirectory = cfg.package;
      };
      postStart = import ./setup.nix {
        config = cfg;
        inherit pkgs;
      };
    };
  };
}
