{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.grafana;
  opt = options.services.grafana;
  provisioningSettingsFormat = pkgs.formats.yaml {};
  declarativePlugins = pkgs.linkFarm "grafana-plugins" (builtins.map (pkg: { name = pkg.pname; path = pkg; }) cfg.declarativePlugins);
  useMysql = cfg.settings.database.type == "mysql";
  usePostgresql = cfg.settings.database.type == "postgres";

  settingsFormatIni = pkgs.formats.ini {};
  configFile = settingsFormatIni.generate "config.ini" cfg.settings;

  datasourceConfiguration = {
    apiVersion = 1;
    datasources = cfg.provision.datasources;
  };

  datasourceFileNew = if (cfg.provision.datasources.path == null) then provisioningSettingsFormat.generate "datasource.yaml" cfg.provision.datasources.settings else cfg.provision.datasources.path;
  datasourceFile = if (builtins.isList cfg.provision.datasources) then provisioningSettingsFormat.generate "datasource.yaml" datasourceConfiguration else datasourceFileNew;

  dashboardConfiguration = {
    apiVersion = 1;
    providers = cfg.provision.dashboards;
  };

  dashboardFileNew = if (cfg.provision.dashboards.path == null) then provisioningSettingsFormat.generate "dashboard.yaml" cfg.provision.dashboards.settings else cfg.provision.dashboards.path;
  dashboardFile = if (builtins.isList cfg.provision.dashboards) then provisioningSettingsFormat.generate "dashboard.yaml" dashboardConfiguration else dashboardFileNew;

  notifierConfiguration = {
    apiVersion = 1;
    notifiers = cfg.provision.notifiers;
  };

  notifierFile = pkgs.writeText "notifier.yaml" (builtins.toJSON notifierConfiguration);

  generateAlertingProvisioningYaml = x: if (cfg.provision.alerting."${x}".path == null)
                                        then provisioningSettingsFormat.generate "${x}.yaml" cfg.provision.alerting."${x}".settings
                                        else cfg.provision.alerting."${x}".path;
  rulesFile = generateAlertingProvisioningYaml "rules";
  contactPointsFile = generateAlertingProvisioningYaml "contactPoints";
  policiesFile = generateAlertingProvisioningYaml "policies";
  templatesFile = generateAlertingProvisioningYaml "templates";
  muteTimingsFile = generateAlertingProvisioningYaml "muteTimings";

  provisionConfDir =  pkgs.runCommand "grafana-provisioning" { } ''
    mkdir -p $out/{datasources,dashboards,notifiers,alerting}
    ln -sf ${datasourceFile} $out/datasources/datasource.yaml
    ln -sf ${dashboardFile} $out/dashboards/dashboard.yaml
    ln -sf ${notifierFile} $out/notifiers/notifier.yaml
    ln -sf ${rulesFile} $out/alerting/rules.yaml
    ln -sf ${contactPointsFile} $out/alerting/contactPoints.yaml
    ln -sf ${policiesFile} $out/alerting/policies.yaml
    ln -sf ${templatesFile} $out/alerting/templates.yaml
    ln -sf ${muteTimingsFile} $out/alerting/muteTimings.yaml
  '';

  # Get a submodule without any embedded metadata:
  _filter = x: filterAttrs (k: v: k != "_module") x;

  # http://docs.grafana.org/administration/provisioning/#datasources
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
        type = types.enum ["proxy" "direct"];
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
      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Database password, if used. Please note that the contents of this option
          will end up in a world-readable Nix store. Use the file provider
          pointing at a reasonably secured file in the local filesystem
          to work around that. Look at the documentation for details:
          <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
        '';
      };
      basicAuthPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Basic auth password. Please note that the contents of this option
          will end up in a world-readable Nix store. Use the file provider
          pointing at a reasonably secured file in the local filesystem
          to work around that. Look at the documentation for details:
          <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
        '';
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

  # http://docs.grafana.org/administration/provisioning/#dashboards
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
        type = types.enum ["dingding" "discord" "email" "googlechat" "hipchat" "kafka" "line" "teams" "opsgenie" "pagerduty" "prometheus-alertmanager" "pushover" "sensu" "sensugo" "slack" "telegram" "threema" "victorops" "webhook"];
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
in {
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

    package = mkOption {
      description = lib.mdDoc "Package to use.";
      default = pkgs.grafana;
      defaultText = literalExpression "pkgs.grafana";
      type = types.package;
    };

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
              defaultText = literalExpression ''
                pkgs.runCommand "grafana-provisioning" { } \'\'
                  mkdir -p $out/{datasources,dashboards,notifiers,alerting}
                  ln -sf ''${datasourceFile} $out/datasources/datasource.yaml
                  ln -sf ''${dashboardFile} $out/dashboards/dashboard.yaml
                  ln -sf ''${notifierFile} $out/notifiers/notifier.yaml
                  ln -sf ''${rulesFile} $out/alerting/rules.yaml
                  ln -sf ''${contactPointsFile} $out/alerting/contactPoints.yaml
                  ln -sf ''${policiesFile} $out/alerting/policies.yaml
                  ln -sf ''${templatesFile} $out/alerting/templates.yaml
                  ln -sf ''${muteTimingsFile} $out/alerting/muteTimings.yaml
                  \'\'
              '';
              type = types.path;
            };
          };

          server = {
            protocol = mkOption {
              description = lib.mdDoc "Which protocol to listen.";
              default = "http";
              type = types.enum ["http" "https" "h2" "socket"];
            };

            http_addr = mkOption {
              description = lib.mdDoc "Listening address.";
              default = "";
              type = types.str;
            };

            http_port = mkOption {
              description = lib.mdDoc "Listening port.";
              default = 3000;
              type = types.port;
            };

            domain = mkOption {
              description = lib.mdDoc "The public facing domain name used to access grafana from a browser.";
              default = "localhost";
              type = types.str;
            };

            root_url = mkOption {
              description = lib.mdDoc "Full public facing url.";
              default = "%(protocol)s://%(domain)s:%(http_port)s/";
              type = types.str;
            };

            static_root_path = mkOption {
              description = lib.mdDoc "Root path for static assets.";
              default = "${cfg.package}/share/grafana/public";
              defaultText = literalExpression ''"''${package}/share/grafana/public"'';
              type = types.str;
            };

            enable_gzip = mkOption {
              description = lib.mdDoc ''
                Set this option to true to enable HTTP compression, this can improve transfer speed and bandwidth utilization.
                It is recommended that most users set it to true. By default it is set to false for compatibility reasons.
              '';
              default = false;
              type = types.bool;
            };

            cert_file = mkOption {
              description = lib.mdDoc "Cert file for ssl.";
              default = "";
              type = types.str;
            };

            cert_key = mkOption {
              description = lib.mdDoc "Cert key for ssl.";
              default = "";
              type = types.str;
            };

            socket = mkOption {
              description = lib.mdDoc "Path where the socket should be created when protocol=socket. Make sure that Grafana has appropriate permissions before you change this setting.";
              default = "/run/grafana/grafana.sock";
              type = types.str;
            };
          };

          database = {
            type = mkOption {
              description = lib.mdDoc "Database type.";
              default = "sqlite3";
              type = types.enum ["mysql" "sqlite3" "postgres"];
            };

            host = mkOption {
              description = lib.mdDoc "Database host.";
              default = "127.0.0.1:3306";
              type = types.str;
            };

            name = mkOption {
              description = lib.mdDoc "Database name.";
              default = "grafana";
              type = types.str;
            };

            user = mkOption {
              description = lib.mdDoc "Database user.";
              default = "root";
              type = types.str;
            };

            password = mkOption {
              description = lib.mdDoc ''
                Database password. Please note that the contents of this option
                will end up in a world-readable Nix store. Use the file provider
                pointing at a reasonably secured file in the local filesystem
                to work around that. Look at the documentation for details:
                <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider>
              '';
              default = "";
              type = types.str;
            };

            path = mkOption {
              description = lib.mdDoc "Only applicable to sqlite3 database. The file path where the database will be stored.";
              default = "${cfg.dataDir}/data/grafana.db";
              defaultText = literalExpression ''"''${config.${opt.dataDir}}/data/grafana.db"'';
              type = types.path;
            };
          };

          security = {
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
              default = "";
              type = types.str;
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
            from_address = mkOption {
              description = lib.mdDoc "Email address used for sending.";
              default = "admin@grafana.localhost";
              type = types.str;
            };
          };

          users = {
            allow_sign_up = mkOption {
              description = lib.mdDoc "Disable user signup / registration.";
              default = false;
              type = types.bool;
            };

            allow_org_create = mkOption {
              description = lib.mdDoc "Whether user is allowed to create organizations.";
              default = false;
              type = types.bool;
            };

            auto_assign_org = mkOption {
              description = lib.mdDoc "Whether to automatically assign new users to default org.";
              default = true;
              type = types.bool;
            };

            auto_assign_org_role = mkOption {
              description = lib.mdDoc "Default role new users will be auto assigned.";
              default = "Viewer";
              type = types.enum ["Viewer" "Editor"];
            };
          };

          analytics.reporting_enabled = mkOption {
            description = lib.mdDoc "Whether to allow anonymous usage reporting to stats.grafana.net.";
            default = true;
            type = types.bool;
          };
        };
      };
    };

    provision = {
      enable = mkEnableOption (lib.mdDoc "provision");

      datasources = mkOption {
        description = lib.mdDoc ''
          Deprecated option for Grafana datasource configuration. Use either
          `services.grafana.provision.datasources.settings` or
          `services.grafana.provision.datasources.path` instead.
        '';
        default = [];
        apply = x: if (builtins.isList x) then map _filter x else x;
        type = with types; either (listOf grafanaTypes.datasourceConfig) (submodule {
          options.settings = mkOption {
            description = lib.mdDoc ''
              Grafana datasource configuration in Nix. Can't be used with
              `services.grafana.provision.datasources.path` simultaneously. See
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
                  default = [];
                  type = types.listOf grafanaTypes.datasourceConfig;
                };

                deleteDatasources = mkOption {
                  description = lib.mdDoc "List of datasources that should be deleted from the database.";
                  default = [];
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
              `services.grafana.provision.datasources.settings` simultaneously.
            '';
            default = null;
            type = types.nullOr types.path;
          };
        });
      };


      dashboards = mkOption {
        description = lib.mdDoc ''
          Deprecated option for Grafana dashboard configuration. Use either
          `services.grafana.provision.dashboards.settings` or
          `services.grafana.provision.dashboards.path` instead.
        '';
        default = [];
        apply = x: if (builtins.isList x) then map _filter x else x;
        type = with types; either (listOf grafanaTypes.dashboardConfig) (submodule {
          options.settings = mkOption {
            description = lib.mdDoc ''
              Grafana dashboard configuration in Nix. Can't be used with
              `services.grafana.provision.dashboards.path` simultaneously. See
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
                default = [];
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
              `services.grafana.provision.dashboards.settings` simultaneously.
            '';
            default = null;
            type = types.nullOr types.path;
          };
        });
      };


      notifiers = mkOption {
        description = lib.mdDoc "Grafana notifier configuration.";
        default = [];
        type = types.listOf grafanaTypes.notifierConfig;
        apply = x: map _filter x;
      };


      alerting = {
        rules = {
          path = mkOption {
            description = lib.mdDoc ''
              Path to YAML rules configuration. Can't be used with
              `services.grafana.provision.alerting.rules.settings` simultaneously.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana rules configuration in Nix. Can't be used with
              `services.grafana.provision.alerting.rules.path` simultaneously. See
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
                  default = [];
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
                  default = [];
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
              `services.grafana.provision.alerting.contactPoints.settings` simultaneously.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana contact points configuration in Nix. Can't be used with
              `services.grafana.provision.alerting.contactPoints.path` simultaneously. See
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
                  description = lib.mdDoc "List of contact points to import or update. Please note that sensitive data will end up in world-readable Nix store.";
                  default = [];
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
                  default = [];
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
              `services.grafana.provision.alerting.policies.settings` simultaneously.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana notification policies configuration in Nix. Can't be used with
              `services.grafana.provision.alerting.policies.path` simultaneously. See
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
                  default = [];
                  type = types.listOf (types.submodule {
                    freeformType = provisioningSettingsFormat.type;
                  });
                };

                resetPolicies = mkOption {
                  description = lib.mdDoc "List of orgIds that should be reset to the default policy.";
                  default = [];
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
              `services.grafana.provision.alerting.templates.settings` simultaneously.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana templates configuration in Nix. Can't be used with
              `services.grafana.provision.alerting.templates.path` simultaneously. See
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
                  default = [];
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
                  default = [];
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
              `services.grafana.provision.alerting.muteTimings.settings` simultaneously.
            '';
            default = null;
            type = types.nullOr types.path;
          };

          settings = mkOption {
            description = lib.mdDoc ''
              Grafana mute timings configuration in Nix. Can't be used with
              `services.grafana.provision.alerting.muteTimings.path` simultaneously. See
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
                  default = [];
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
                  default = [];
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
    warnings = let
      usesFileProvider = opt: defaultValue: builtins.match "^${defaultValue}$|^\\$__file\\{.*}$" opt != null;
    in flatten [
      (optional (
        ! usesFileProvider cfg.settings.database.password "" ||
        ! usesFileProvider cfg.settings.security.admin_password "admin"
      ) "Grafana passwords will be stored as plaintext in the Nix store! Use file provider instead.")
      (optional (
        let
          checkOpts = opt: any (x: x.password != null || x.basicAuthPassword != null || x.secureJsonData != null) opt;
          datasourcesUsed = if (cfg.provision.datasources.settings == null) then [] else cfg.provision.datasources.settings.datasources;
        in if (builtins.isList cfg.provision.datasources) then checkOpts cfg.provision.datasources else checkOpts datasourcesUsed
        ) ''
          Datasource passwords will be stored as plaintext in the Nix store!
          It is not possible to use file provider in provisioning; please provision
          datasources via `services.grafana.provision.datasources.path` instead.
        '')
      (optional (
        any (x: x.secure_settings != null) cfg.provision.notifiers
      ) "Notifier secure settings will be stored as plaintext in the Nix store! Use file provider instead.")
      (optional (
        builtins.isList cfg.provision.datasources && cfg.provision.datasources != []
      ) ''
          Provisioning Grafana datasources with options has been deprecated.
          Use `services.grafana.provision.datasources.settings` or
          `services.grafana.provision.datasources.path` instead.
        '')
      (optional (
        builtins.isList cfg.provision.datasources && cfg.provision.dashboards != []
      ) ''
          Provisioning Grafana dashboards with options has been deprecated.
          Use `services.grafana.provision.dashboards.settings` or
          `services.grafana.provision.dashboards.path` instead.
        '')
      (optional (
        cfg.provision.notifiers != []
        ) ''
            Notifiers are deprecated upstream and will be removed in Grafana 10.
            Use `services.grafana.provision.alerting.contactPoints` instead.
        '')
    ];

    environment.systemPackages = [ cfg.package ];

    assertions = [
      {
        assertion = if (builtins.isList cfg.provision.datasources) then true else cfg.provision.datasources.settings == null || cfg.provision.datasources.path == null;
        message = "Cannot set both datasources settings and datasources path";
      }
      {
        assertion = let
          prometheusIsNotDirect = opt: all
          ({ type, access, ... }: type == "prometheus" -> access != "direct")
          opt;
        in
          if (builtins.isList cfg.provision.datasources) then prometheusIsNotDirect cfg.provision.datasources
          else cfg.provision.datasources.settings == null || prometheusIsNotDirect cfg.provision.datasources.settings.datasources;
        message = "For datasources of type `prometheus`, the `direct` access mode is not supported anymore (since Grafana 9.2.0)";
      }
      {
        assertion = if (builtins.isList cfg.provision.dashboards) then true else cfg.provision.dashboards.settings == null || cfg.provision.dashboards.path == null;
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
      wantedBy = ["multi-user.target"];
      after = ["networking.target"] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      script = ''
        set -o errexit -o pipefail -o nounset -o errtrace
        shopt -s inherit_errexit

        exec ${cfg.package}/bin/grafana-server -homepath ${cfg.dataDir} -config ${configFile}
      '';
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        User = "grafana";
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
        SystemCallFilter = [ "@system-service" "~@privileged" ];
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
    users.groups.grafana = {};
  };
}
