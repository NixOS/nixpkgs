{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.grafana;
  opt = options.services.grafana;

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
    DATABASE_CONN_MAX_LIFETIME = cfg.database.connMaxLifetime;

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

    SMTP_ENABLE = boolToString cfg.smtp.enable;
    SMTP_HOST = cfg.smtp.host;
    SMTP_USER = cfg.smtp.user;
    SMTP_PASSWORD = cfg.smtp.password;
    SMTP_FROM_ADDRESS = cfg.smtp.fromAddress;
  } // cfg.extraOptions;

  datasourceConfiguration = {
    apiVersion = 1;
    datasources = cfg.provision.datasources;
  };

  datasourceFile = pkgs.writeText "datasource.yaml" (builtins.toJSON datasourceConfiguration);

  dashboardConfiguration = {
    apiVersion = 1;
    providers = cfg.provision.dashboards;
  };

  dashboardFile = pkgs.writeText "dashboard.yaml" (builtins.toJSON dashboardConfiguration);

  provisionConfDir =  pkgs.runCommand "grafana-provisioning" { } ''
    mkdir -p $out/{datasources,dashboards}
    ln -sf ${datasourceFile} $out/datasources/datasource.yaml
    ln -sf ${dashboardFile} $out/dashboards/dashboard.yaml
  '';

  # Get a submodule without any embedded metadata:
  _filter = x: filterAttrs (k: v: k != "_module") x;

  # http://docs.grafana.org/administration/provisioning/#datasources
  grafanaTypes.datasourceConfig = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "Name of the datasource. Required";
      };
      type = mkOption {
        type = types.enum ["graphite" "prometheus" "cloudwatch" "elasticsearch" "influxdb" "opentsdb" "mysql" "mssql" "postgres" "loki"];
        description = "Datasource type. Required";
      };
      access = mkOption {
        type = types.enum ["proxy" "direct"];
        default = "proxy";
        description = "Access mode. proxy or direct (Server or Browser in the UI). Required";
      };
      orgId = mkOption {
        type = types.int;
        default = 1;
        description = "Org id. will default to orgId 1 if not specified";
      };
      url = mkOption {
        type = types.str;
        description = "Url of the datasource";
      };
      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Database password, if used";
      };
      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Database user, if used";
      };
      database = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Database name, if used";
      };
      basicAuth = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable/disable basic auth";
      };
      basicAuthUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Basic auth username";
      };
      basicAuthPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Basic auth password";
      };
      withCredentials = mkOption {
        type = types.bool;
        default = false;
        description = "Enable/disable with credentials headers";
      };
      isDefault = mkOption {
        type = types.bool;
        default = false;
        description = "Mark as default datasource. Max one per org";
      };
      jsonData = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Datasource specific configuration";
      };
      secureJsonData = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Datasource specific secure configuration";
      };
      version = mkOption {
        type = types.int;
        default = 1;
        description = "Version";
      };
      editable = mkOption {
        type = types.bool;
        default = false;
        description = "Allow users to edit datasources from the UI.";
      };
    };
  };

  # http://docs.grafana.org/administration/provisioning/#dashboards
  grafanaTypes.dashboardConfig = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        default = "default";
        description = "Provider name";
      };
      orgId = mkOption {
        type = types.int;
        default = 1;
        description = "Organization ID";
      };
      folder = mkOption {
        type = types.str;
        default = "";
        description = "Add dashboards to the specified folder";
      };
      type = mkOption {
        type = types.str;
        default = "file";
        description = "Dashboard provider type";
      };
      disableDeletion = mkOption {
        type = types.bool;
        default = false;
        description = "Disable deletion when JSON file is removed";
      };
      updateIntervalSeconds = mkOption {
        type = types.int;
        default = 10;
        description = "How often Grafana will scan for changed dashboards";
      };
      options = {
        path = mkOption {
          type = types.path;
          description = "Path grafana will watch for dashboards";
        };
      };
    };
  };
in {
  options.services.grafana = {
    enable = mkEnableOption "grafana";

    protocol = mkOption {
      description = "Which protocol to listen.";
      default = "http";
      type = types.enum ["http" "https" "socket"];
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
        type = types.enum ["mysql" "sqlite3" "postgres"];
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
        description = ''
          Database password.
          This option is mutual exclusive with the passwordFile option.
        '';
        default = "";
        type = types.str;
      };

      passwordFile = mkOption {
        description = ''
          File that containts the database password.
          This option is mutual exclusive with the password option.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      path = mkOption {
        description = "Database path.";
        default = "${cfg.dataDir}/data/grafana.db";
        type = types.path;
      };

      connMaxLifetime = mkOption {
        description = ''
          Sets the maximum amount of time (in seconds) a connection may be reused.
          For MySQL this setting should be shorter than the `wait_timeout' variable.
        '';
        default = "unlimited";
        example = 14400;
        type = types.either types.int (types.enum [ "unlimited" ]);
      };
    };

    provision = {
      enable = mkEnableOption "provision";
      datasources = mkOption {
        description = "Grafana datasources configuration";
        default = [];
        type = types.listOf grafanaTypes.datasourceConfig;
        apply = x: map _filter x;
      };
      dashboards = mkOption {
        description = "Grafana dashboard configuration";
        default = [];
        type = types.listOf grafanaTypes.dashboardConfig;
        apply = x: map _filter x;
      };
    };

    security = {
      adminUser = mkOption {
        description = "Default admin username.";
        default = "admin";
        type = types.str;
      };

      adminPassword = mkOption {
        description = ''
          Default admin password.
          This option is mutual exclusive with the adminPasswordFile option.
        '';
        default = "admin";
        type = types.str;
      };

      adminPasswordFile = mkOption {
        description = ''
          Default admin password.
          This option is mutual exclusive with the <literal>adminPassword</literal> option.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      secretKey = mkOption {
        description = "Secret key used for signing.";
        default = "SW2YcwTIb9zpOOhoPsMm";
        type = types.str;
      };

      secretKeyFile = mkOption {
        description = "Secret key used for signing.";
        default = null;
        type = types.nullOr types.path;
      };
    };

    smtp = {
      enable = mkEnableOption "smtp";
      host = mkOption {
        description = "Host to connect to";
        default = "localhost:25";
        type = types.str;
      };
      user = mkOption {
        description = "User used for authentication";
        default = "";
        type = types.str;
      };
      password = mkOption {
        description = ''
          Password used for authentication.
          This option is mutual exclusive with the passwordFile option.
        '';
        default = "";
        type = types.str;
      };
      passwordFile = mkOption {
        description = ''
          Password used for authentication.
          This option is mutual exclusive with the password option.
        '';
        default = null;
        type = types.nullOr types.path;
      };
      fromAddress = mkOption {
        description = "Email address used for sending";
        default = "admin@grafana.localhost";
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
      type = with types; attrsOf (either str path);
    };
  };

  config = mkIf cfg.enable {
    warnings = flatten [
      (optional (
        cfg.database.password != opt.database.password.default ||
        cfg.security.adminPassword != opt.security.adminPassword.default
      ) "Grafana passwords will be stored as plaintext in the Nix store!")
      (optional (
        any (x: x.password != null || x.basicAuthPassword != null || x.secureJsonData != null) cfg.provision.datasources
      ) "Datasource passwords will be stored as plaintext in the Nix store!")
    ];

    environment.systemPackages = [ cfg.package ];

    assertions = [
      {
        assertion = cfg.database.password != opt.database.password.default -> cfg.database.passwordFile == null;
        message = "Cannot set both password and passwordFile";
      }
      {
        assertion = cfg.security.adminPassword != opt.security.adminPassword.default -> cfg.security.adminPasswordFile == null;
        message = "Cannot set both adminPassword and adminPasswordFile";
      }
      {
        assertion = cfg.security.secretKeyFile != opt.security.secretKeyFile.default -> cfg.security.secretKeyFile == null;
        message = "Cannot set both secretKey and secretKeyFile";
      }
      {
        assertion = cfg.smtp.password != opt.smtp.password.default -> cfg.smtp.passwordFile == null;
        message = "Cannot set both password and secretKeyFile";
      }
    ];

    systemd.services.grafana = {
      description = "Grafana Service Daemon";
      wantedBy = ["multi-user.target"];
      after = ["networking.target"];
      environment = {
        QT_QPA_PLATFORM = "offscreen";
      } // mapAttrs' (n: v: nameValuePair "GF_${n}" (toString v)) envOptions;
      script = ''
        ${optionalString (cfg.database.passwordFile != null) ''
          export GF_DATABASE_PASSWORD="$(cat ${escapeShellArg cfg.database.passwordFile})"
        ''}
        ${optionalString (cfg.security.adminPasswordFile != null) ''
          export GF_SECURITY_ADMIN_PASSWORD="$(cat ${escapeShellArg cfg.security.adminPasswordFile})"
        ''}
        ${optionalString (cfg.security.secretKeyFile != null) ''
          export GF_SECURITY_SECRET_KEY="$(cat ${escapeShellArg cfg.security.secretKeyFile})"
        ''}
        ${optionalString (cfg.smtp.passwordFile != null) ''
          export GF_SMTP_PASSWORD="$(cat ${escapeShellArg cfg.smtp.passwordFile})"
        ''}
        ${optionalString cfg.provision.enable ''
          export GF_PATHS_PROVISIONING=${provisionConfDir};
        ''}
        exec ${cfg.package.bin}/bin/grafana-server -homepath ${cfg.dataDir}
      '';
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        User = "grafana";
      };
      preStart = ''
        ln -fs ${cfg.package}/share/grafana/conf ${cfg.dataDir}
        ln -fs ${cfg.package}/share/grafana/tools ${cfg.dataDir}
      '';
    };

    users.users.grafana = {
      uid = config.ids.uids.grafana;
      description = "Grafana user";
      home = cfg.dataDir;
      createHome = true;
    };
  };
}
