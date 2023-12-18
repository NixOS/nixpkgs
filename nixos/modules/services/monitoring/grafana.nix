{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.grafana;
  opt = options.services.grafana;
  provisioningSettingsFormat = pkgs.formats.yaml { };
  declarativePlugins = pkgs.linkFarm "grafana-plugins" (builtins.map (pkg: { name = pkg.pname; path = pkg; }) cfg.declarativePlugins);
  useMysql = cfg.settings.database.type == "mysql";
  usePostgresql = cfg.settings.database.type == "postgres";

  # Prefer using the values from the default config file[0] directly. This way,
  # people reading the NixOS manual can see them without cross-referencing the
  # official documentation.
  #
  # However, if there is no default entry or if the setting is optional, use
  # `null` as the default value. It will be turned into the empty string.
  #
  # If a setting is a list, always allow setting it as a plain string as well.
  #
  # [0]: https://github.com/grafana/grafana/blob/main/conf/defaults.ini
  settingsFormatIni = pkgs.formats.ini {
    listToValue = concatMapStringsSep " " (generators.mkValueStringDefault { });
    mkKeyValue = generators.mkKeyValueDefault
      {
        mkValueString = v:
          if v == null then ""
          else generators.mkValueStringDefault { } v;
      }
      "=";
  };
  configFile = settingsFormatIni.generate "config.ini" cfg.settings;

  mkProvisionCfg = name: attr: provisionCfg:
    if provisionCfg.path != null
    then provisionCfg.path
    else
      provisioningSettingsFormat.generate "${name}.yaml"
        (if provisionCfg.settings != null
        then provisionCfg.settings
        else {
          apiVersion = 1;
          ${attr} = [ ];
        });

  datasourceFileOrDir = mkProvisionCfg "datasource" "datasources" cfg.provision.datasources;
  dashboardFileOrDir = mkProvisionCfg "dashboard" "providers" cfg.provision.dashboards;

  notifierConfiguration = {
    apiVersion = 1;
    notifiers = cfg.provision.notifiers;
  };

  notifierFileOrDir = pkgs.writeText "notifier.yaml" (builtins.toJSON notifierConfiguration);

  generateAlertingProvisioningYaml = x:
    if (cfg.provision.alerting."${x}".path == null)
    then provisioningSettingsFormat.generate "${x}.yaml" cfg.provision.alerting."${x}".settings
    else cfg.provision.alerting."${x}".path;
  rulesFileOrDir = generateAlertingProvisioningYaml "rules";
  contactPointsFileOrDir = generateAlertingProvisioningYaml "contactPoints";
  policiesFileOrDir = generateAlertingProvisioningYaml "policies";
  templatesFileOrDir = generateAlertingProvisioningYaml "templates";
  muteTimingsFileOrDir = generateAlertingProvisioningYaml "muteTimings";

  ln = { src, dir, filename }: ''
    if [[ -d "${src}" ]]; then
      pushd $out/${dir} &>/dev/null
        lndir "${src}"
      popd &>/dev/null
    else
      ln -sf ${src} $out/${dir}/${filename}.yaml
    fi
  '';
  provisionConfDir = pkgs.runCommand "grafana-provisioning" { nativeBuildInputs = [ pkgs.xorg.lndir ]; } ''
    mkdir -p $out/{alerting,datasources,dashboards,notifiers,plugins}
    ${ln { src = datasourceFileOrDir;    dir = "datasources"; filename = "datasource"; }}
    ${ln { src = dashboardFileOrDir;     dir = "dashboards";  filename = "dashboard"; }}
    ${ln { src = notifierFileOrDir;      dir = "notifiers";   filename = "notifier"; }}
    ${ln { src = rulesFileOrDir;         dir = "alerting";    filename = "rules"; }}
    ${ln { src = contactPointsFileOrDir; dir = "alerting";    filename = "contactPoints"; }}
    ${ln { src = policiesFileOrDir;      dir = "alerting";    filename = "policies"; }}
    ${ln { src = templatesFileOrDir;     dir = "alerting";    filename = "templates"; }}
    ${ln { src = muteTimingsFileOrDir;   dir = "alerting";    filename = "muteTimings"; }}
  '';

  # Get a submodule without any embedded metadata:
  _filter = x: filterAttrs (k: v: k != "_module") x;

  # https://grafana.com/docs/grafana/latest/administration/provisioning/#datasources
  grafanaTypes.datasourceConfig = types.submodule {
    freeformType = provisioningSettingsFormat.type;

    options = {
      name = mkOption {
        type = types.str;
        description = lib.mdDoc "Name of the datasource. Required.";
      };
      type = mkOption {
        type = types.str;
        description = lib.mdDoc "Datasource type. Required.";
      };
      access = mkOption {
        type = types.enum [ "proxy" "direct" ];
        default = "proxy";
        description = lib.mdDoc "Access mode. proxy or direct (Server or Browser in the UI). Required.";
      };
      uid = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "Custom UID which can be used to reference this datasource in other parts of the configuration, if not specified will be generated automatically.";
      };
      url = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "Url of the datasource.";
      };
      editable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Allow users to edit datasources from the UI.";
      };
      jsonData = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = lib.mdDoc "Extra data for datasource plugins.";
      };
      secureJsonData = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = lib.mdDoc ''
          Datasource specific secure configuration. Please note that the contents of this option
          will end up in a world-readable Nix store. Use the file provider
          pointing at a reasonably secured file in the local filesystem
          to work around that. Look at the documentation for details:
          <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
        '';
      };
    };
  };

  # https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards
  grafanaTypes.dashboardConfig = types.submodule {
    freeformType = provisioningSettingsFormat.type;

    options = {
      name = mkOption {
        type = types.str;
        default = "default";
        description = lib.mdDoc "A unique provider name.";
      };
      type = mkOption {
        type = types.str;
        default = "file";
        description = lib.mdDoc "Dashboard provider type.";
      };
      options.path = mkOption {
        type = types.path;
        description = lib.mdDoc "Path grafana will watch for dashboards. Required when using the 'file' type.";
      };
    };
  };

  grafanaTypes.notifierConfig = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        default = "default";
        description = lib.mdDoc "Notifier name.";
      };
      type = mkOption {
        type = types.enum [ "dingding" "discord" "email" "googlechat" "hipchat" "kafka" "line" "teams" "opsgenie" "pagerduty" "prometheus-alertmanager" "pushover" "sensu" "sensugo" "slack" "telegram" "threema" "victorops" "webhook" ];
        description = lib.mdDoc "Notifier type.";
      };
      uid = mkOption {
        type = types.str;
        description = lib.mdDoc "Unique notifier identifier.";
      };
      org_id = mkOption {
        type = types.int;
        default = 1;
        description = lib.mdDoc "Organization ID.";
      };
      org_name = mkOption {
        type = types.str;
        default = "Main Org.";
        description = lib.mdDoc "Organization name.";
      };
      is_default = mkOption {
        type = types.bool;
        description = lib.mdDoc "Is the default notifier.";
        default = false;
      };
      send_reminder = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Should the notifier be sent reminder notifications while alerts continue to fire.";
      };
      frequency = mkOption {
        type = types.str;
        default = "5m";
        description = lib.mdDoc "How frequently should the notifier be sent reminders.";
      };
      disable_resolve_message = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Turn off the message that sends when an alert returns to OK.";
      };
      settings = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = lib.mdDoc "Settings for the notifier type.";
      };
      secure_settings = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = lib.mdDoc ''
          Secure settings for the notifier type. Please note that the contents of this option
          will end up in a world-readable Nix store. Use the file provider
          pointing at a reasonably secured file in the local filesystem
          to work around that. Look at the documentation for details:
          <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
        '';
      };
    };
  };
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "grafana" "protocol" ] [ "services" "grafana" "settings" "server" "protocol" ])
    (mkRenamedOptionModule [ "services" "grafana" "addr" ] [ "services" "grafana" "settings" "server" "http_addr" ])
    (mkRenamedOptionModule [ "services" "grafana" "port" ] [ "services" "grafana" "settings" "server" "http_port" ])
    (mkRenamedOptionModule [ "services" "grafana" "domain" ] [ "services" "grafana" "settings" "server" "domain" ])
    (mkRenamedOptionModule [ "services" "grafana" "rootUrl" ] [ "services" "grafana" "settings" "server" "root_url" ])
    (mkRenamedOptionModule [ "services" "grafana" "staticRootPath" ] [ "services" "grafana" "settings" "server" "static_root_path" ])
    (mkRenamedOptionModule [ "services" "grafana" "certFile" ] [ "services" "grafana" "settings" "server" "cert_file" ])
    (mkRenamedOptionModule [ "services" "grafana" "certKey" ] [ "services" "grafana" "settings" "server" "cert_key" ])
    (mkRenamedOptionModule [ "services" "grafana" "socket" ] [ "services" "grafana" "settings" "server" "socket" ])
    (mkRenamedOptionModule [ "services" "grafana" "database" "type" ] [ "services" "grafana" "settings" "database" "type" ])
    (mkRenamedOptionModule [ "services" "grafana" "database" "host" ] [ "services" "grafana" "settings" "database" "host" ])
    (mkRenamedOptionModule [ "services" "grafana" "database" "name" ] [ "services" "grafana" "settings" "database" "name" ])
    (mkRenamedOptionModule [ "services" "grafana" "database" "user" ] [ "services" "grafana" "settings" "database" "user" ])
    (mkRenamedOptionModule [ "services" "grafana" "database" "password" ] [ "services" "grafana" "settings" "database" "password" ])
    (mkRenamedOptionModule [ "services" "grafana" "database" "path" ] [ "services" "grafana" "settings" "database" "path" ])
    (mkRenamedOptionModule [ "services" "grafana" "database" "connMaxLifetime" ] [ "services" "grafana" "settings" "database" "conn_max_lifetime" ])
    (mkRenamedOptionModule [ "services" "grafana" "security" "adminUser" ] [ "services" "grafana" "settings" "security" "admin_user" ])
    (mkRenamedOptionModule [ "services" "grafana" "security" "adminPassword" ] [ "services" "grafana" "settings" "security" "admin_password" ])
    (mkRenamedOptionModule [ "services" "grafana" "security" "secretKey" ] [ "services" "grafana" "settings" "security" "secret_key" ])
    (mkRenamedOptionModule [ "services" "grafana" "server" "serveFromSubPath" ] [ "services" "grafana" "settings" "server" "serve_from_sub_path" ])
    (mkRenamedOptionModule [ "services" "grafana" "smtp" "enable" ] [ "services" "grafana" "settings" "smtp" "enabled" ])
    (mkRenamedOptionModule [ "services" "grafana" "smtp" "user" ] [ "services" "grafana" "settings" "smtp" "user" ])
    (mkRenamedOptionModule [ "services" "grafana" "smtp" "password" ] [ "services" "grafana" "settings" "smtp" "password" ])
    (mkRenamedOptionModule [ "services" "grafana" "smtp" "fromAddress" ] [ "services" "grafana" "settings" "smtp" "from_address" ])
    (mkRenamedOptionModule [ "services" "grafana" "users" "allowSignUp" ] [ "services" "grafana" "settings" "users" "allow_sign_up" ])
    (mkRenamedOptionModule [ "services" "grafana" "users" "allowOrgCreate" ] [ "services" "grafana" "settings" "users" "allow_org_create" ])
    (mkRenamedOptionModule [ "services" "grafana" "users" "autoAssignOrg" ] [ "services" "grafana" "settings" "users" "auto_assign_org" ])
    (mkRenamedOptionModule [ "services" "grafana" "users" "autoAssignOrgRole" ] [ "services" "grafana" "settings" "users" "auto_assign_org_role" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "disableLoginForm" ] [ "services" "grafana" "settings" "auth" "disable_login_form" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "anonymous" "enable" ] [ "services" "grafana" "settings" "auth.anonymous" "enabled" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "anonymous" "org_name" ] [ "services" "grafana" "settings" "auth.anonymous" "org_name" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "anonymous" "org_role" ] [ "services" "grafana" "settings" "auth.anonymous" "org_role" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "azuread" "enable" ] [ "services" "grafana" "settings" "auth.azuread" "enabled" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "azuread" "allowSignUp" ] [ "services" "grafana" "settings" "auth.azuread" "allow_sign_up" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "azuread" "clientId" ] [ "services" "grafana" "settings" "auth.azuread" "client_id" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "azuread" "allowedDomains" ] [ "services" "grafana" "settings" "auth.azuread" "allowed_domains" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "azuread" "allowedGroups" ] [ "services" "grafana" "settings" "auth.azuread" "allowed_groups" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "google" "enable" ] [ "services" "grafana" "settings" "auth.google" "enabled" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "google" "allowSignUp" ] [ "services" "grafana" "settings" "auth.google" "allow_sign_up" ])
    (mkRenamedOptionModule [ "services" "grafana" "auth" "google" "clientId" ] [ "services" "grafana" "settings" "auth.google" "client_id" ])
    (mkRenamedOptionModule [ "services" "grafana" "analytics" "reporting" "enable" ] [ "services" "grafana" "settings" "analytics" "reporting_enabled" ])

    (mkRemovedOptionModule [ "services" "grafana" "database" "passwordFile" ] ''
      This option has been removed. Use 'services.grafana.settings.database.password' with file provider instead.
    '')
    (mkRemovedOptionModule [ "services" "grafana" "security" "adminPasswordFile" ] ''
      This option has been removed. Use 'services.grafana.settings.security.admin_password' with file provider instead.
    '')
    (mkRemovedOptionModule [ "services" "grafana" "security" "secretKeyFile" ] ''
      This option has been removed. Use 'services.grafana.settings.security.secret_key' with file provider instead.
    '')
    (mkRemovedOptionModule [ "services" "grafana" "smtp" "passwordFile" ] ''
      This option has been removed. Use 'services.grafana.settings.smtp.password' with file provider instead.
    '')
    (mkRemovedOptionModule [ "services" "grafana" "auth" "azuread" "clientSecretFile" ] ''
      This option has been removed. Use 'services.grafana.settings.azuread.client_secret' with file provider instead.
    '')
    (mkRemovedOptionModule [ "services" "grafana" "auth" "google" "clientSecretFile" ] ''
      This option has been removed. Use 'services.grafana.settings.google.client_secret' with file provider instead.
    '')
    (mkRemovedOptionModule [ "services" "grafana" "extraOptions" ] ''
      This option has been removed. Use 'services.grafana.settings' instead. For a detailed migration guide, please
      review the release notes of NixOS 22.11.
    '')

    (mkRemovedOptionModule [ "services" "grafana" "auth" "azuread" "tenantId" ] "This option has been deprecated upstream.")
  ];

  options.services.grafana = {
    enable = mkEnableOption (lib.mdDoc "grafana");

    declarativePlugins = mkOption {
      type = with types; nullOr (listOf path);
      default = null;
      description = lib.mdDoc "If non-null, then a list of packages containing Grafana plugins to install. If set, plugins cannot be manually installed.";
      example = literalExpression "with pkgs.grafanaPlugins; [ grafana-piechart-panel ]";
      # Make sure each plugin is added only once; otherwise building
      # the link farm fails, since the same path is added multiple
      # times.
      apply = x: if isList x then lib.unique x else x;
    };

    package = mkPackageOption pkgs "grafana" { };

    dataDir = mkOption {
      description = lib.mdDoc "Data directory.";
      default = "/var/lib/grafana";
      type = types.path;
    };

    settings = mkOption {
      description = lib.mdDoc ''
        Grafana settings. See <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/>
        for available options. INI format is used.
      '';
      type = types.submodule {
        freeformType = settingsFormatIni.type;

        options = {
          paths = {
            plugins = mkOption {
              description = lib.mdDoc "Directory where grafana will automatically scan and look for plugins";
              default = if (cfg.declarativePlugins == null) then "${cfg.dataDir}/plugins" else declarativePlugins;
              defaultText = literalExpression "if (cfg.declarativePlugins == null) then \"\${cfg.dataDir}/plugins\" else declarativePlugins";
              type = types.path;
            };

            provisioning = mkOption {
              description = lib.mdDoc ''
                Folder that contains provisioning config files that grafana will apply on startup and while running.
                Don't change the value of this option if you are planning to use `services.grafana.provision` options.
              '';
              default = provisionConfDir;
              defaultText = "directory with links to files generated from services.grafana.provision";
              type = types.path;
            };
          };

          server = {
            protocol = mkOption {
              description = lib.mdDoc "Which protocol to listen.";
              default = "http";
              type = types.enum [ "http" "https" "h2" "socket" ];
            };

            http_addr = mkOption {
              type = types.str;
              default = "127.0.0.1";
              description = lib.mdDoc ''
                Listening address.

                ::: {.note}
                This setting intentionally varies from upstream's default to be a bit more secure by default.
                :::
              '';
            };

            http_port = mkOption {
              description = lib.mdDoc "Listening port.";
              default = 3000;
              type = types.port;
            };

            domain = mkOption {
              description = lib.mdDoc ''
                The public facing domain name used to access grafana from a browser.

                This setting is only used in the default value of the `root_url` setting.
                If you set the latter manually, this option does not have to be specified.
              '';
              default = "localhost";
              type = types.str;
            };

            enforce_domain = mkOption {
              description = lib.mdDoc ''
                Redirect to correct domain if the host header does not match the domain.
                Prevents DNS rebinding attacks.
              '';
              default = false;
              type = types.bool;
            };

            root_url = mkOption {
              description = lib.mdDoc ''
                This is the full URL used to access Grafana from a web browser.
                This is important if you use Google or GitHub OAuth authentication (for the callback URL to be correct).

                This setting is also important if you have a reverse proxy in front of Grafana that exposes it through a subpath.
                In that case add the subpath to the end of this URL setting.
              '';
              default = "%(protocol)s://%(domain)s:%(http_port)s/";
              type = types.str;
            };

            serve_from_sub_path = mkOption {
              description = lib.mdDoc ''
                Serve Grafana from subpath specified in the `root_url` setting.
                By default it is set to `false` for compatibility reasons.

                By enabling this setting and using a subpath in `root_url` above,
                e.g. `root_url = "http://localhost:3000/grafana"`,
                Grafana is accessible on `http://localhost:3000/grafana`.
                If accessed without subpath, Grafana will redirect to an URL with the subpath.
              '';
              default = false;
              type = types.bool;
            };

            router_logging = mkOption {
              description = lib.mdDoc ''
                Set to `true` for Grafana to log all HTTP requests (not just errors).
                These are logged as Info level events to the Grafana log.
              '';
              default = false;
              type = types.bool;
            };

            static_root_path = mkOption {
              description = lib.mdDoc "Root path for static assets.";
              default = "${cfg.package}/share/grafana/public";
              defaultText = literalExpression ''"''${package}/share/grafana/public"'';
              type = types.str;
            };

            enable_gzip = mkOption {
              description = lib.mdDoc ''
                Set this option to `true` to enable HTTP compression, this can improve transfer speed and bandwidth utilization.
                It is recommended that most users set it to `true`. By default it is set to `false` for compatibility reasons.
              '';
              default = false;
              type = types.bool;
            };

            cert_file = mkOption {
              description = lib.mdDoc ''
                Path to the certificate file (if `protocol` is set to `https` or `h2`).
              '';
              default = null;
              type = types.nullOr types.str;
            };

            cert_key = mkOption {
              description = lib.mdDoc ''
                Path to the certificate key file (if `protocol` is set to `https` or `h2`).
              '';
              default = null;
              type = types.nullOr types.str;
            };

            socket_gid = mkOption {
              description = lib.mdDoc ''
                GID where the socket should be set when `protocol=socket`.
                Make sure that the target group is in the group of Grafana process and that Grafana process is the file owner before you change this setting.
                It is recommended to set the gid as http server user gid.
                Not set when the value is -1.
              '';
              default = -1;
              type = types.int;
            };

            socket_mode = mkOption {
              description = lib.mdDoc ''
                Mode where the socket should be set when `protocol=socket`.
                Make sure that Grafana process is the file owner before you change this setting.
              '';
              # I assume this value is interpreted as octal literal by grafana.
              # If this was an int, people following tutorials or porting their
              # old config could stumble across nix not having octal literals.
              default = "0660";
              type = types.str;
            };

            socket = mkOption {
              description = lib.mdDoc ''
                Path where the socket should be created when `protocol=socket`.
                Make sure that Grafana has appropriate permissions before you change this setting.
              '';
              default = "/run/grafana/grafana.sock";
              type = types.str;
            };

            cdn_url = mkOption {
              description = lib.mdDoc ''
                Specify a full HTTP URL address to the root of your Grafana CDN assets.
                Grafana will add edition and version paths.

                For example, given a cdn url like `https://cdn.myserver.com`
                grafana will try to load a javascript file from `http://cdn.myserver.com/grafana-oss/7.4.0/public/build/app.<hash>.js`.
              '';
              default = null;
              type = types.nullOr types.str;
            };

            read_timeout = mkOption {
              description = lib.mdDoc ''
                Sets the maximum time using a duration format (5s/5m/5ms)
                before timing out read of an incoming request and closing idle connections.
                0 means there is no timeout for reading the request.
              '';
              default = "0";
              type = types.str;
            };
          };

          database = {
            type = mkOption {
              description = lib.mdDoc "Database type.";
              default = "sqlite3";
              type = types.enum [ "mysql" "sqlite3" "postgres" ];
            };

            host = mkOption {
              description = lib.mdDoc ''
                Only applicable to MySQL or Postgres.
                Includes IP or hostname and port or in case of Unix sockets the path to it.
                For example, for MySQL running on the same host as Grafana: `host = "127.0.0.1:3306"`
                or with Unix sockets: `host = "/var/run/mysqld/mysqld.sock"`
              '';
              default = "127.0.0.1:3306";
              type = types.str;
            };

            name = mkOption {
              description = lib.mdDoc "The name of the Grafana database.";
              default = "grafana";
              type = types.str;
            };

            user = mkOption {
              description = lib.mdDoc "The database user (not applicable for `sqlite3`).";
              default = "root";
              type = types.str;
            };

            password = mkOption {
              description = lib.mdDoc ''
                The database user's password (not applicable for `sqlite3`).

                Please note that the contents of this option
                will end up in a world-readable Nix store. Use the file provider
                pointing at a reasonably secured file in the local filesystem
                to work around that. Look at the documentation for details:
                <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
              '';
              default = "";
              type = types.str;
            };

            max_idle_conn = mkOption {
              description = lib.mdDoc "The maximum number of connections in the idle connection pool.";
              default = 2;
              type = types.int;
            };

            max_open_conn = mkOption {
              description = lib.mdDoc "The maximum number of open connections to the database.";
              default = 0;
              type = types.int;
            };

            conn_max_lifetime = mkOption {
              description = lib.mdDoc ''
                Sets the maximum amount of time a connection may be reused.
                The default is 14400 (which means 14400 seconds or 4 hours).
                For MySQL, this setting should be shorter than the `wait_timeout` variable.
              '';
              default = 14400;
              type = types.int;
            };

            locking_attempt_timeout_sec = mkOption {
              description = lib.mdDoc ''
                For `mysql`, if the `migrationLocking` feature toggle is set,
                specify the time (in seconds) to wait before failing to lock the database for the migrations.
              '';
              default = 0;
              type = types.int;
            };

            log_queries = mkOption {
              description = lib.mdDoc "Set to `true` to log the sql calls and execution times";
              default = false;
              type = types.bool;
            };

            ssl_mode = mkOption {
              description = lib.mdDoc ''
                For Postgres, use either `disable`, `require` or `verify-full`.
                For MySQL, use either `true`, `false`, or `skip-verify`.
              '';
              default = "disable";
              type = types.enum [ "disable" "require" "verify-full" "true" "false" "skip-verify" ];
            };

            isolation_level = mkOption {
              description = lib.mdDoc ''
                Only the MySQL driver supports isolation levels in Grafana.
                In case the value is empty, the driver's default isolation level is applied.
              '';
              default = null;
              type = types.nullOr (types.enum [ "READ-UNCOMMITTED" "READ-COMMITTED" "REPEATABLE-READ" "SERIALIZABLE" ]);
            };

            ca_cert_path = mkOption {
              description = lib.mdDoc "The path to the CA certificate to use.";
              default = null;
              type = types.nullOr types.str;
            };

            client_key_path = mkOption {
              description = lib.mdDoc "The path to the client key. Only if server requires client authentication.";
              default = null;
              type = types.nullOr types.str;
            };

            client_cert_path = mkOption {
              description = lib.mdDoc "The path to the client cert. Only if server requires client authentication.";
              default = null;
              type = types.nullOr types.str;
            };

            server_cert_name = mkOption {
              description = lib.mdDoc ''
                The common name field of the certificate used by the `mysql` or `postgres` server.
                Not necessary if `ssl_mode` is set to `skip-verify`.
              '';
              default = null;
              type = types.nullOr types.str;
            };

            path = mkOption {
              description = lib.mdDoc "Only applicable to `sqlite3` database. The file path where the database will be stored.";
              default = "${cfg.dataDir}/data/grafana.db";
              defaultText = literalExpression ''"''${config.${opt.dataDir}}/data/grafana.db"'';
              type = types.path;
            };

            cache_mode = mkOption {
              description = lib.mdDoc ''
                For `sqlite3` only.
                [Shared cache](https://www.sqlite.org/sharedcache.html) setting used for connecting to the database.
              '';
              default = "private";
              type = types.enum [ "private" "shared" ];
            };

            wal = mkOption {
              description = lib.mdDoc ''
                For `sqlite3` only.
                Setting to enable/disable [Write-Ahead Logging](https://sqlite.org/wal.html).
              '';
              default = false;
              type = types.bool;
            };

            query_retries = mkOption {
              description = lib.mdDoc ''
                This setting applies to `sqlite3` only and controls the number of times the system retries a query when the database is locked.
              '';
              default = 0;
              type = types.int;
            };

            transaction_retries = mkOption {
              description = lib.mdDoc ''
                This setting applies to `sqlite3` only and controls the number of times the system retries a transaction when the database is locked.
              '';
              default = 5;
              type = types.int;
            };

            # TODO Add "instrument_queries" option when upgrading to grafana 10.0
            # instrument_queries = mkOption {
            #   description = lib.mdDoc "Set to `true` to add metrics and tracing for database queries.";
            #   default = false;
            #   type = types.bool;
            # };
          };

          security = {
            disable_initial_admin_creation = mkOption {
              description = lib.mdDoc "Disable creation of admin user on first start of Grafana.";
              default = false;
              type = types.bool;
            };

            admin_user = mkOption {
              description = lib.mdDoc "Default admin username.";
              default = "admin";
              type = types.str;
            };

            admin_password = mkOption {
              description = lib.mdDoc ''
                Default admin password. Please note that the contents of this option
                will end up in a world-readable Nix store. Use the file provider
                pointing at a reasonably secured file in the local filesystem
                to work around that. Look at the documentation for details:
                <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
              '';
              default = "admin";
              type = types.str;
            };

            admin_email = mkOption {
              description = lib.mdDoc "The email of the default Grafana Admin, created on startup.";
              default = "admin@localhost";
              type = types.str;
            };

            secret_key = mkOption {
              description = lib.mdDoc ''
                Secret key used for signing. Please note that the contents of this option
                will end up in a world-readable Nix store. Use the file provider
                pointing at a reasonably secured file in the local filesystem
                to work around that. Look at the documentation for details:
                <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
              '';
              default = "SW2YcwTIb9zpOOhoPsMm";
              type = types.str;
            };

            disable_gravatar = mkOption {
              description = lib.mdDoc "Set to `true` to disable the use of Gravatar for user profile images.";
              default = false;
              type = types.bool;
            };

            data_source_proxy_whitelist = mkOption {
              description = lib.mdDoc ''
                Define a whitelist of allowed IP addresses or domains, with ports,
                to be used in data source URLs with the Grafana data source proxy.
                Format: `ip_or_domain:port` separated by spaces.
                PostgreSQL, MySQL, and MSSQL data sources do not use the proxy and are therefore unaffected by this setting.
              '';
              default = [ ];
              type = types.oneOf [ types.str (types.listOf types.str) ];
            };

            disable_brute_force_login_protection = mkOption {
              description = lib.mdDoc "Set to `true` to disable [brute force login protection](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html#account-lockout).";
              default = false;
              type = types.bool;
            };

            cookie_secure = mkOption {
              description = lib.mdDoc "Set to `true` if you host Grafana behind HTTPS.";
              default = false;
              type = types.bool;
            };

            cookie_samesite = mkOption {
              description = lib.mdDoc ''
                Sets the `SameSite` cookie attribute and prevents the browser from sending this cookie along with cross-site requests.
                The main goal is to mitigate the risk of cross-origin information leakage.
                This setting also provides some protection against cross-site request forgery attacks (CSRF),
                [read more about SameSite here](https://owasp.org/www-community/SameSite).
                Using value `disabled` does not add any `SameSite` attribute to cookies.
              '';
              default = "lax";
              type = types.enum [ "lax" "strict" "none" "disabled" ];
            };

            allow_embedding = mkOption {
              description = lib.mdDoc ''
                When `false`, the HTTP header `X-Frame-Options: deny` will be set in Grafana HTTP responses
                which will instruct browsers to not allow rendering Grafana in a `<frame>`, `<iframe>`, `<embed>` or `<object>`.
                The main goal is to mitigate the risk of [Clickjacking](https://owasp.org/www-community/attacks/Clickjacking).
              '';
              default = false;
              type = types.bool;
            };

            strict_transport_security = mkOption {
              description = lib.mdDoc ''
                Set to `true` if you want to enable HTTP `Strict-Transport-Security` (HSTS) response header.
                Only use this when HTTPS is enabled in your configuration,
                or when there is another upstream system that ensures your application does HTTPS (like a frontend load balancer).
                HSTS tells browsers that the site should only be accessed using HTTPS.
              '';
              default = false;
              type = types.bool;
            };

            strict_transport_security_max_age_seconds = mkOption {
              description = lib.mdDoc ''
                Sets how long a browser should cache HSTS in seconds.
                Only applied if `strict_transport_security` is enabled.
              '';
              default = 86400;
              type = types.int;
            };

            strict_transport_security_preload = mkOption {
              description = lib.mdDoc ''
                Set to `true` to enable HSTS `preloading` option.
                Only applied if `strict_transport_security` is enabled.
              '';
              default = false;
              type = types.bool;
            };

            strict_transport_security_subdomains = mkOption {
              description = lib.mdDoc ''
                Set to `true` to enable HSTS `includeSubDomains` option.
                Only applied if `strict_transport_security` is enabled.
              '';
              default = false;
              type = types.bool;
            };

            x_content_type_options = mkOption {
              description = lib.mdDoc ''
                Set to `false` to disable the `X-Content-Type-Options` response header.
                The `X-Content-Type-Options` response HTTP header is a marker used by the server
                to indicate that the MIME types advertised in the `Content-Type` headers should not be changed and be followed.
              '';
              default = true;
              type = types.bool;
            };

            x_xss_protection = mkOption {
              description = lib.mdDoc ''
                Set to `false` to disable the `X-XSS-Protection` header,
                which tells browsers to stop pages from loading when they detect reflected cross-site scripting (XSS) attacks.
              '';
              default = true;
              type = types.bool;
            };

            content_security_policy = mkOption {
              description = lib.mdDoc ''
                Set to `true` to add the `Content-Security-Policy` header to your requests.
                CSP allows to control resources that the user agent can load and helps prevent XSS attacks.
              '';
              default = false;
              type = types.bool;
            };

            content_security_policy_report_only = mkOption {
              description = lib.mdDoc ''
                Set to `true` to add the `Content-Security-Policy-Report-Only` header to your requests.
                CSP in Report Only mode enables you to experiment with policies by monitoring their effects without enforcing them.
                You can enable both policies simultaneously.
              '';
              default = false;
              type = types.bool;
            };

            # The options content_security_policy_template and
            # content_security_policy_template are missing because I'm not sure
            # how exactly the quoting of the default value works. See also
            # https://github.com/grafana/grafana/blob/cb7e18938b8eb6860a64b91aaba13a7eb31bc95b/conf/defaults.ini#L364
            # https://github.com/grafana/grafana/blob/cb7e18938b8eb6860a64b91aaba13a7eb31bc95b/conf/defaults.ini#L373

            # These two options are lists joined with spaces:
            # https://github.com/grafana/grafana/blob/916d9793aa81c2990640b55a15dee0db6b525e41/pkg/middleware/csrf/csrf.go#L37-L38

            csrf_trusted_origins = mkOption {
              description = lib.mdDoc ''
                List of additional allowed URLs to pass by the CSRF check.
                Suggested when authentication comes from an IdP.
              '';
              default = [ ];
              type = types.oneOf [ types.str (types.listOf types.str) ];
            };

            csrf_additional_headers = mkOption {
              description = lib.mdDoc ''
                List of allowed headers to be set by the user.
                Suggested to use for if authentication lives behind reverse proxies.
              '';
              default = [ ];
              type = types.oneOf [ types.str (types.listOf types.str) ];
            };
          };

          smtp = {
            enabled = mkOption {
              description = lib.mdDoc "Whether to enable SMTP.";
              default = false;
              type = types.bool;
            };

            host = mkOption {
              description = lib.mdDoc "Host to connect to.";
              default = "localhost:25";
              type = types.str;
            };

            user = mkOption {
              description = lib.mdDoc "User used for authentication.";
              default = null;
              type = types.nullOr types.str;
            };

            password = mkOption {
              description = lib.mdDoc ''
                Password used for authentication. Please note that the contents of this option
                will end up in a world-readable Nix store. Use the file provider
                pointing at a reasonably secured file in the local filesystem
                to work around that. Look at the documentation for details:
                <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
              '';
              default = "";
              type = types.str;
            };

            cert_file = mkOption {
              description = lib.mdDoc "File path to a cert file.";
              default = null;
              type = types.nullOr types.str;
            };

            key_file = mkOption {
              description = lib.mdDoc "File path to a key file.";
              default = null;
              type = types.nullOr types.str;
            };

            skip_verify = mkOption {
              description = lib.mdDoc "Verify SSL for SMTP server.";
              default = false;
              type = types.bool;
            };

            from_address = mkOption {
              description = lib.mdDoc "Address used when sending out emails.";
              default = "admin@grafana.localhost";
              type = types.str;
            };

            from_name = mkOption {
              description = lib.mdDoc "Name to be used as client identity for EHLO in SMTP dialog.";
              default = "Grafana";
              type = types.str;
            };

            ehlo_identity = mkOption {
              description = lib.mdDoc "Name to be used as client identity for EHLO in SMTP dialog.";
              default = null;
              type = types.nullOr types.str;
            };

            startTLS_policy = mkOption {
              description = lib.mdDoc "StartTLS policy when connecting to server.";
              default = null;
              type = types.nullOr (types.enum [ "OpportunisticStartTLS" "MandatoryStartTLS" "NoStartTLS" ]);
            };
          };

          users = {
            allow_sign_up = mkOption {
              description = lib.mdDoc ''
                Set to false to prohibit users from being able to sign up / create user accounts.
                The admin user can still create users.
              '';
              default = false;
              type = types.bool;
            };

            allow_org_create = mkOption {
              description = lib.mdDoc "Set to `false` to prohibit users from creating new organizations.";
              default = false;
              type = types.bool;
            };

            auto_assign_org = mkOption {
              description = lib.mdDoc ''
                Set to `true` to automatically add new users to the main organization (id 1).
                When set to `false,` new users automatically cause a new organization to be created for that new user.
                The organization will be created even if the `allow_org_create` setting is set to `false`.
              '';
              default = true;
              type = types.bool;
            };

            auto_assign_org_id = mkOption {
              description = lib.mdDoc ''
                Set this value to automatically add new users to the provided org.
                This requires `auto_assign_org` to be set to `true`.
                Please make sure that this organization already exists.
              '';
              default = 1;
              type = types.int;
            };

            auto_assign_org_role = mkOption {
              description = lib.mdDoc ''
                The role new users will be assigned for the main organization (if the `auto_assign_org` setting is set to `true`).
              '';
              default = "Viewer";
              type = types.enum [ "Viewer" "Editor" "Admin" ];
            };

            verify_email_enabled = mkOption {
              description = lib.mdDoc "Require email validation before sign up completes.";
              default = false;
              type = types.bool;
            };

            login_hint = mkOption {
              description = lib.mdDoc "Text used as placeholder text on login page for login/username input.";
              default = "email or username";
              type = types.str;
            };

            password_hint = mkOption {
              description = lib.mdDoc "Text used as placeholder text on login page for password input.";
              default = "password";
              type = types.str;
            };

            default_theme = mkOption {
              description = lib.mdDoc "Sets the default UI theme. `system` matches the user's system theme.";
              default = "dark";
              type = types.enum [ "dark" "light" "system" ];
            };

            default_language = mkOption {
              description = lib.mdDoc "This setting configures the default UI language, which must be a supported IETF language tag, such as `en-US`.";
              default = "en-US";
              type = types.str;
            };

            home_page = mkOption {
              description = lib.mdDoc ''
                Path to a custom home page.
                Users are only redirected to this if the default home dashboard is used.
                It should match a frontend route and contain a leading slash.
              '';
              default = "";
              type = types.str;
            };

            viewers_can_edit = mkOption {
              description = lib.mdDoc ''
                Viewers can access and use Explore and perform temporary edits on panels in dashboards they have access to.
                They cannot save their changes.
              '';
              default = false;
              type = types.bool;
            };

            editors_can_admin = mkOption {
              description = lib.mdDoc "Editors can administrate dashboards, folders and teams they create.";
              default = false;
              type = types.bool;
            };

            user_invite_max_lifetime_duration = mkOption {
              description = lib.mdDoc ''
                The duration in time a user invitation remains valid before expiring.
                This setting should be expressed as a duration.
                Examples: `6h` (hours), `2d` (days), `1w` (week).
                The minimum supported duration is `15m` (15 minutes).
              '';
              default = "24h";
              type = types.str;
            };

            # Lists are joined via space, so this option can't be a list.
            # Users have to manually join their values.
            hidden_users = mkOption {
              description = lib.mdDoc ''
                This is a comma-separated list of usernames.
                Users specified here are hidden in the Grafana UI.
                They are still visible to Grafana administrators and to themselves.
              '';
              default = "";
              type = types.str;
            };
          };

          analytics = {
            reporting_enabled = mkOption {
              description = lib.mdDoc ''
                When enabled Grafana will send anonymous usage statistics to `stats.grafana.org`.
                No IP addresses are being tracked, only simple counters to track running instances, versions, dashboard and error counts.
                Counters are sent every 24 hours.
              '';
              default = true;
              type = types.bool;
            };

            check_for_updates = mkOption {
              description = lib.mdDoc ''
                When set to `false`, disables checking for new versions of Grafana from Grafana's GitHub repository.
                When enabled, the check for a new version runs every 10 minutes.
                It will notify, via the UI, when a new version is available.
                The check itself will not prompt any auto-updates of the Grafana software, nor will it send any sensitive information.
              '';
              default = false;
              type = types.bool;
            };

            check_for_plugin_updates = mkOption {
              description = lib.mdDoc ''
                When set to `false`, disables checking for new versions of installed plugins from https://grafana.com.
                When enabled, the check for a new plugin runs every 10 minutes.
                It will notify, via the UI, when a new plugin update exists.
                The check itself will not prompt any auto-updates of the plugin, nor will it send any sensitive information.
              '';
              default = cfg.declarativePlugins == null;
              defaultText = literalExpression "cfg.declarativePlugins == null";
              type = types.bool;
            };

            feedback_links_enabled = mkOption {
              description = lib.mdDoc "Set to `false` to remove all feedback links from the UI.";
              default = true;
              type = types.bool;
            };
          };
        };
      };
    };

    provision = {
      enable = mkEnableOption (lib.mdDoc "provision");

      datasources = mkOption {
        description = lib.mdDoc ''
          Declaratively provision Grafana's datasources.
        '';
        default = { };
        type = types.submodule {
          options.settings = mkOption {
            description = lib.mdDoc ''
              Grafana datasource configuration in Nix. Can't be used with
              [](#opt-services.grafana.provision.datasources.path) simultaneously. See
              <https://grafana.com/docs/grafana/latest/administration/provisioning/#data-sources>
              for supported options.
            '';
            default = null;
            type = types.nullOr (types.submodule {
              options = {
                apiVersion = mkOption {
                  description = lib.mdDoc "Config file version.";
                  default = 1;
                  type = types.int;
                };

                datasources = mkOption {
                  description = lib.mdDoc "List of datasources to insert/update.";
                  default = [ ];
                  type = types.listOf grafanaTypes.datasourceConfig;
                };

                deleteDatasources = mkOption {
                  description = lib.mdDoc "List of datasources that should be deleted from the database.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    options.name = mkOption {
                      description = lib.mdDoc "Name of the datasource to delete.";
                      type = types.str;
                    };

                    options.orgId = mkOption {
                      description = lib.mdDoc "Organization ID of the datasource to delete.";
                      type = types.int;
                    };
                  });
                };
              };
            });
            example = literalExpression ''
              {
                apiVersion = 1;

                datasources = [{
                  name = "Graphite";
                  type = "graphite";
                }];

                deleteDatasources = [{
                  name = "Graphite";
                  orgId = 1;
                }];
              }
            '';
          };

          options.path = mkOption {
            description = lib.mdDoc ''
              Path to YAML datasource configuration. Can't be used with
              [](#opt-services.grafana.provision.datasources.settings) simultaneously.
              Can be either a directory or a single YAML file. Will end up in the store.
            '';
            default = null;
            type = types.nullOr types.path;
          };
        };
      };


      dashboards = mkOption {
        description = lib.mdDoc ''
          Declaratively provision Grafana's dashboards.
        '';
        default = { };
        type = types.submodule {
          options.settings = mkOption {
            description = lib.mdDoc ''
              Grafana dashboard configuration in Nix. Can't be used with
              [](#opt-services.grafana.provision.dashboards.path) simultaneously. See
              <https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards>
              for supported options.
            '';
            default = null;
            type = types.nullOr (types.submodule {
              options.apiVersion = mkOption {
                description = lib.mdDoc "Config file version.";
                default = 1;
                type = types.int;
              };

              options.providers = mkOption {
                description = lib.mdDoc "List of dashboards to insert/update.";
                default = [ ];
                type = types.listOf grafanaTypes.dashboardConfig;
              };
            });
            example = literalExpression ''
              {
                apiVersion = 1;

                providers = [{
                    name = "default";
                    options.path = "/var/lib/grafana/dashboards";
                }];
              }
            '';
          };

          options.path = mkOption {
            description = lib.mdDoc ''
              Path to YAML dashboard configuration. Can't be used with
              [](#opt-services.grafana.provision.dashboards.settings) simultaneously.
              Can be either a directory or a single YAML file. Will end up in the store.
            '';
            default = null;
            type = types.nullOr types.path;
          };
        };
      };


      notifiers = mkOption {
        description = lib.mdDoc "Grafana notifier configuration.";
        default = [ ];
        type = types.listOf grafanaTypes.notifierConfig;
        apply = x: map _filter x;
      };


      alerting = {
        rules = {
          path = mkOption {
            description = lib.mdDoc ''
              Path to YAML rules configuration. Can't be used with
              [](#opt-services.grafana.provision.alerting.rules.settings) simultaneously.
              Can be either a directory or a single YAML file. Will end up in the store.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana rules configuration in Nix. Can't be used with
              [](#opt-services.grafana.provision.alerting.rules.path) simultaneously. See
              <https://grafana.com/docs/grafana/latest/administration/provisioning/#rules>
              for supported options.
            '';
            default = null;
            type = types.nullOr (types.submodule {
              options = {
                apiVersion = mkOption {
                  description = lib.mdDoc "Config file version.";
                  default = 1;
                  type = types.int;
                };

                groups = mkOption {
                  description = lib.mdDoc "List of rule groups to import or update.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    freeformType = provisioningSettingsFormat.type;

                    options.name = mkOption {
                      description = lib.mdDoc "Name of the rule group. Required.";
                      type = types.str;
                    };

                    options.folder = mkOption {
                      description = lib.mdDoc "Name of the folder the rule group will be stored in. Required.";
                      type = types.str;
                    };

                    options.interval = mkOption {
                      description = lib.mdDoc "Interval that the rule group should be evaluated at. Required.";
                      type = types.str;
                    };
                  });
                };

                deleteRules = mkOption {
                  description = lib.mdDoc "List of alert rule UIDs that should be deleted.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    options.orgId = mkOption {
                      description = lib.mdDoc "Organization ID, default = 1";
                      default = 1;
                      type = types.int;
                    };

                    options.uid = mkOption {
                      description = lib.mdDoc "Unique identifier for the rule. Required.";
                      type = types.str;
                    };
                  });
                };
              };
            });
            example = literalExpression ''
              {
                apiVersion = 1;

                groups = [{
                  orgId = 1;
                  name = "my_rule_group";
                  folder = "my_first_folder";
                  interval = "60s";
                  rules = [{
                    uid = "my_id_1";
                    title = "my_first_rule";
                    condition = "A";
                    data = [{
                      refId = "A";
                      datasourceUid = "-100";
                      model = {
                        conditions = [{
                          evaluator = {
                            params = [ 3 ];
                            type = "git";
                          };
                          operator.type = "and";
                          query.params = [ "A" ];
                          reducer.type = "last";
                          type = "query";
                        }];
                        datasource = {
                          type = "__expr__";
                          uid = "-100";
                        };
                        expression = "1==0";
                        intervalMs = 1000;
                        maxDataPoints = 43200;
                        refId = "A";
                        type = "math";
                      };
                    }];
                    dashboardUid = "my_dashboard";
                    panelId = 123;
                    noDataState = "Alerting";
                    for = "60s";
                    annotations.some_key = "some_value";
                    labels.team = "sre_team1";
                  }];
                }];

                deleteRules = [{
                  orgId = 1;
                  uid = "my_id_1";
                }];
              }
            '';
          };
        };

        contactPoints = {
          path = mkOption {
            description = lib.mdDoc ''
              Path to YAML contact points configuration. Can't be used with
              [](#opt-services.grafana.provision.alerting.contactPoints.settings) simultaneously.
              Can be either a directory or a single YAML file. Will end up in the store.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana contact points configuration in Nix. Can't be used with
              [](#opt-services.grafana.provision.alerting.contactPoints.path) simultaneously. See
              <https://grafana.com/docs/grafana/latest/administration/provisioning/#contact-points>
              for supported options.
            '';
            default = null;
            type = types.nullOr (types.submodule {
              options = {
                apiVersion = mkOption {
                  description = lib.mdDoc "Config file version.";
                  default = 1;
                  type = types.int;
                };

                contactPoints = mkOption {
                  description = lib.mdDoc "List of contact points to import or update.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    freeformType = provisioningSettingsFormat.type;

                    options.name = mkOption {
                      description = lib.mdDoc "Name of the contact point. Required.";
                      type = types.str;
                    };
                  });
                };

                deleteContactPoints = mkOption {
                  description = lib.mdDoc "List of receivers that should be deleted.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    options.orgId = mkOption {
                      description = lib.mdDoc "Organization ID, default = 1.";
                      default = 1;
                      type = types.int;
                    };

                    options.uid = mkOption {
                      description = lib.mdDoc "Unique identifier for the receiver. Required.";
                      type = types.str;
                    };
                  });
                };
              };
            });
            example = literalExpression ''
              {
                apiVersion = 1;

                contactPoints = [{
                  orgId = 1;
                  name = "cp_1";
                  receivers = [{
                    uid = "first_uid";
                    type = "prometheus-alertmanager";
                    settings.url = "http://test:9000";
                  }];
                }];

                deleteContactPoints = [{
                  orgId = 1;
                  uid = "first_uid";
                }];
              }
            '';
          };
        };

        policies = {
          path = mkOption {
            description = lib.mdDoc ''
              Path to YAML notification policies configuration. Can't be used with
              [](#opt-services.grafana.provision.alerting.policies.settings) simultaneously.
              Can be either a directory or a single YAML file. Will end up in the store.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana notification policies configuration in Nix. Can't be used with
              [](#opt-services.grafana.provision.alerting.policies.path) simultaneously. See
              <https://grafana.com/docs/grafana/latest/administration/provisioning/#notification-policies>
              for supported options.
            '';
            default = null;
            type = types.nullOr (types.submodule {
              options = {
                apiVersion = mkOption {
                  description = lib.mdDoc "Config file version.";
                  default = 1;
                  type = types.int;
                };

                policies = mkOption {
                  description = lib.mdDoc "List of contact points to import or update.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    freeformType = provisioningSettingsFormat.type;
                  });
                };

                resetPolicies = mkOption {
                  description = lib.mdDoc "List of orgIds that should be reset to the default policy.";
                  default = [ ];
                  type = types.listOf types.int;
                };
              };
            });
            example = literalExpression ''
              {
                apiVersion = 1;

                policies = [{
                  orgId = 1;
                  receiver = "grafana-default-email";
                  group_by = [ "..." ];
                  matchers = [
                    "alertname = Watchdog"
                    "severity =~ \"warning|critical\""
                  ];
                  mute_time_intervals = [
                    "abc"
                  ];
                  group_wait = "30s";
                  group_interval = "5m";
                  repeat_interval = "4h";
                }];

                resetPolicies = [
                  1
                ];
              }
            '';
          };
        };

        templates = {
          path = mkOption {
            description = lib.mdDoc ''
              Path to YAML templates configuration. Can't be used with
              [](#opt-services.grafana.provision.alerting.templates.settings) simultaneously.
              Can be either a directory or a single YAML file. Will end up in the store.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana templates configuration in Nix. Can't be used with
              [](#opt-services.grafana.provision.alerting.templates.path) simultaneously. See
              <https://grafana.com/docs/grafana/latest/administration/provisioning/#templates>
              for supported options.
            '';
            default = null;
            type = types.nullOr (types.submodule {
              options = {
                apiVersion = mkOption {
                  description = lib.mdDoc "Config file version.";
                  default = 1;
                  type = types.int;
                };

                templates = mkOption {
                  description = lib.mdDoc "List of templates to import or update.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    freeformType = provisioningSettingsFormat.type;

                    options.name = mkOption {
                      description = lib.mdDoc "Name of the template, must be unique. Required.";
                      type = types.str;
                    };

                    options.template = mkOption {
                      description = lib.mdDoc "Alerting with a custom text template";
                      type = types.str;
                    };
                  });
                };

                deleteTemplates = mkOption {
                  description = lib.mdDoc "List of alert rule UIDs that should be deleted.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    options.orgId = mkOption {
                      description = lib.mdDoc "Organization ID, default = 1.";
                      default = 1;
                      type = types.int;
                    };

                    options.name = mkOption {
                      description = lib.mdDoc "Name of the template, must be unique. Required.";
                      type = types.str;
                    };
                  });
                };
              };
            });
            example = literalExpression ''
              {
                apiVersion = 1;

                templates = [{
                  orgId = 1;
                  name = "my_first_template";
                  template = "Alerting with a custom text template";
                }];

                deleteTemplates = [{
                  orgId = 1;
                  name = "my_first_template";
                }];
              }
            '';
          };
        };

        muteTimings = {
          path = mkOption {
            description = lib.mdDoc ''
              Path to YAML mute timings configuration. Can't be used with
              [](#opt-services.grafana.provision.alerting.muteTimings.settings) simultaneously.
              Can be either a directory or a single YAML file. Will end up in the store.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana mute timings configuration in Nix. Can't be used with
              [](#opt-services.grafana.provision.alerting.muteTimings.path) simultaneously. See
              <https://grafana.com/docs/grafana/latest/administration/provisioning/#mute-timings>
              for supported options.
            '';
            default = null;
            type = types.nullOr (types.submodule {
              options = {
                apiVersion = mkOption {
                  description = lib.mdDoc "Config file version.";
                  default = 1;
                  type = types.int;
                };

                muteTimes = mkOption {
                  description = lib.mdDoc "List of mute time intervals to import or update.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    freeformType = provisioningSettingsFormat.type;

                    options.name = mkOption {
                      description = lib.mdDoc "Name of the mute time interval, must be unique. Required.";
                      type = types.str;
                    };
                  });
                };

                deleteMuteTimes = mkOption {
                  description = lib.mdDoc "List of mute time intervals that should be deleted.";
                  default = [ ];
                  type = types.listOf (types.submodule {
                    options.orgId = mkOption {
                      description = lib.mdDoc "Organization ID, default = 1.";
                      default = 1;
                      type = types.int;
                    };

                    options.name = mkOption {
                      description = lib.mdDoc "Name of the mute time interval, must be unique. Required.";
                      type = types.str;
                    };
                  });
                };
              };
            });
            example = literalExpression ''
              {
                apiVersion = 1;

                muteTimes = [{
                  orgId = 1;
                  name = "mti_1";
                  time_intervals = [{
                    times = [{
                      start_time = "06:00";
                      end_time = "23:59";
                    }];
                    weekdays = [
                      "monday:wednesday"
                      "saturday"
                      "sunday"
                    ];
                    months = [
                      "1:3"
                      "may:august"
                      "december"
                    ];
                    years = [
                      "2020:2022"
                      "2030"
                    ];
                    days_of_month = [
                      "1:5"
                      "-3:-1"
                    ];
                  }];
                }];

                deleteMuteTimes = [{
                  orgId = 1;
                  name = "mti_1";
                }];
              }
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    warnings =
      let
        doesntUseFileProvider = opt: defaultValue:
          let regex = "${optionalString (defaultValue != null) "^${defaultValue}$|"}^\\$__(file|env)\\{.*}$|^\\$[^_\\$][^ ]+$";
          in builtins.match regex opt == null;

        # Ensure that no custom credentials are leaked into the Nix store. Unless the default value
        # is specified, this can be achieved by using the file/env provider:
        # https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#variable-expansion
        passwordWithoutFileProvider = optional
          (
            doesntUseFileProvider cfg.settings.database.password "" ||
            doesntUseFileProvider cfg.settings.security.admin_password "admin"
          )
          ''
            Grafana passwords will be stored as plaintext in the Nix store!
            Use file provider or an env-var instead.
          '';

        # Warn about deprecated notifiers.
        deprecatedNotifiers = optional (cfg.provision.notifiers != [ ]) ''
          Notifiers are deprecated upstream and will be removed in Grafana 11.
          Use `services.grafana.provision.alerting.contactPoints` instead.
        '';

        # Ensure that `secureJsonData` of datasources provisioned via `datasources.settings`
        # only uses file/env providers.
        secureJsonDataWithoutFileProvider = optional
          (
            let
              datasourcesToCheck = optionals
                (cfg.provision.datasources.settings != null)
                cfg.provision.datasources.settings.datasources;
              declarationUnsafe = { secureJsonData, ... }:
                secureJsonData != null
                && any (flip doesntUseFileProvider null) (attrValues secureJsonData);
            in
            any declarationUnsafe datasourcesToCheck
          )
          ''
            Declarations in the `secureJsonData`-block of a datasource will be leaked to the
            Nix store unless a file-provider or an env-var is used!
          '';

        notifierSecureSettingsWithoutFileProvider = optional
          (any (x: x.secure_settings != null) cfg.provision.notifiers)
          "Notifier secure settings will be stored as plaintext in the Nix store! Use file provider instead.";
      in
      passwordWithoutFileProvider
      ++ deprecatedNotifiers
      ++ secureJsonDataWithoutFileProvider
      ++ notifierSecureSettingsWithoutFileProvider;

    environment.systemPackages = [ cfg.package ];

    assertions = [
      {
        assertion = cfg.provision.datasources.settings == null || cfg.provision.datasources.path == null;
        message = "Cannot set both datasources settings and datasources path";
      }
      {
        assertion =
          let
            prometheusIsNotDirect = opt: all
              ({ type, access, ... }: type == "prometheus" -> access != "direct")
              opt;
          in
          cfg.provision.datasources.settings == null || prometheusIsNotDirect cfg.provision.datasources.settings.datasources;
        message = "For datasources of type `prometheus`, the `direct` access mode is not supported anymore (since Grafana 9.2.0)";
      }
      {
        assertion = cfg.provision.dashboards.settings == null || cfg.provision.dashboards.path == null;
        message = "Cannot set both dashboards settings and dashboards path";
      }
      {
        assertion = cfg.provision.alerting.rules.settings == null || cfg.provision.alerting.rules.path == null;
        message = "Cannot set both rules settings and rules path";
      }
      {
        assertion = cfg.provision.alerting.contactPoints.settings == null || cfg.provision.alerting.contactPoints.path == null;
        message = "Cannot set both contact points settings and contact points path";
      }
      {
        assertion = cfg.provision.alerting.policies.settings == null || cfg.provision.alerting.policies.path == null;
        message = "Cannot set both policies settings and policies path";
      }
      {
        assertion = cfg.provision.alerting.templates.settings == null || cfg.provision.alerting.templates.path == null;
        message = "Cannot set both templates settings and templates path";
      }
      {
        assertion = cfg.provision.alerting.muteTimings.settings == null || cfg.provision.alerting.muteTimings.path == null;
        message = "Cannot set both mute timings settings and mute timings path";
      }
    ];

    systemd.services.grafana = {
      description = "Grafana Service Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      script = ''
        set -o errexit -o pipefail -o nounset -o errtrace
        shopt -s inherit_errexit

        exec ${cfg.package}/bin/grafana server -homepath ${cfg.dataDir} -config ${configFile}
      '';
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        User = "grafana";
        Restart = "on-failure";
        RuntimeDirectory = "grafana";
        RuntimeDirectoryMode = "0755";
        # Hardening
        AmbientCapabilities = lib.mkIf (cfg.settings.server.http_port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = if (cfg.settings.server.http_port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        # Upstream grafana is not setting SystemCallFilter for compatibility
        # reasons, see https://github.com/grafana/grafana/pull/40176
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ] ++ lib.optionals (cfg.settings.server.protocol == "socket") [ "@chown" ];
        UMask = "0027";
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
      group = "grafana";
    };
    users.groups.grafana = { };
  };
}
