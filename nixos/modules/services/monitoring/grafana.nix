{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.grafana;

  envOptions = {
    PATHS_DATA = cfg.dataDir;
    PATHS_PLUGINS = "${cfg.dataDir}/plugins";
    PATHS_LOGS = "${cfg.dataDir}/log";

    SERVER_PROTOCOL = cfg.protocol;
    SERVER_HTTP_ADDR = cfg.addr;
    SERVER_HTTP_PORT = cfg.port;
    SERVER_DOMAIN = cfg.domain;
    SERVER_ROOT_URL = cfg.rootUrl;
    SERVER_STATIC_ROOT_PATH = cfg.staticRootPath;
    SERVER_CERT_FILE = cfg.certFile;
    SERVER_CERT_KEY = cfg.certKey;

    DATABASE_TYPE = cfg.database.type;
    DATABASE_HOST = cfg.database.host;
    DATABASE_NAME = cfg.database.name;
    DATABASE_USER = cfg.database.user;
    DATABASE_PASSWORD = cfg.database.password;
    DATABASE_PATH = cfg.database.path;

    SECURITY_ADMIN_USER = cfg.security.adminUser;
    SECURITY_ADMIN_PASSWORD = cfg.security.adminPassword;
    SECURITY_SECRET_KEY = cfg.security.secretKey;

    USERS_ALLOW_SIGN_UP = boolToString cfg.users.allowSignUp;
    USERS_ALLOW_ORG_CREATE = boolToString cfg.users.allowOrgCreate;
    USERS_AUTO_ASSIGN_ORG = boolToString cfg.users.autoAssignOrg;
    USERS_AUTO_ASSIGN_ORG_ROLE = cfg.users.autoAssignOrgRole;

    AUTH_ANONYMOUS_ENABLED = boolToString cfg.auth.anonymous.enable;
    AUTH_ANONYMOUS_ORG_NAME = cfg.auth.anonymous.org_name;
    AUTH_ANONYMOUS_ORG_ROLE = cfg.auth.anonymous.org_role;

    ANALYTICS_REPORTING_ENABLED = boolToString cfg.analytics.reporting.enable;
  } // cfg.extraOptions;

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
      default = "${cfg.package}/share/grafana/public";
      type = types.str;
    };

    package = mkOption {
      description = "Package to use.";
      default = pkgs.grafana;
      defaultText = "pkgs.grafana";
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
      org_name = mkOption {
        description = "Which organization to allow anonymous access to";
        default = "Main Org.";
        type = types.str;
      };
      org_role = mkOption {
        description = "Which role anonymous users have in the organization";
        default = "Viewer";
        type = types.str;
      };

    };

    analytics.reporting = {
      enable = mkOption {
        description = "Whether to allow anonymous usage reporting to stats.grafana.net";
        default = true;
        type = types.bool;
      };
    };

    extraOptions = mkOption {
      description = ''
        Extra configuration options passed as env variables as specified in
        <link xlink:href="http://docs.grafana.org/installation/configuration/">documentation</link>,
        but without GF_ prefix
      '';
      default = {};
      type = types.attrsOf types.str;
    };
  };

  config = mkIf cfg.enable {
    warnings = optional (
      cfg.database.password != options.services.grafana.database.password.default ||
      cfg.security.adminPassword != options.services.grafana.security.adminPassword.default
    ) "Grafana passwords will be stored as plaintext in the Nix store!";

    environment.systemPackages = [ cfg.package ];

    systemd.services.grafana = {
      description = "Grafana Service Daemon";
      wantedBy = ["multi-user.target"];
      after = ["networking.target"];
      environment = mapAttrs' (n: v: nameValuePair "GF_${n}" (toString v)) envOptions;
      serviceConfig = {
        ExecStart = "${cfg.package.bin}/bin/grafana-server -homepath ${cfg.dataDir}";
        WorkingDirectory = cfg.dataDir;
        User = "grafana";
      };
      preStart = ''
        ln -fs ${cfg.package}/share/grafana/conf ${cfg.dataDir}
        ln -fs ${cfg.package}/share/grafana/vendor ${cfg.dataDir}
      '';
    };

    users.extraUsers.grafana = {
      uid = config.ids.uids.grafana;
      description = "Grafana user";
      home = cfg.dataDir;
      createHome = true;
    };
  };
}
