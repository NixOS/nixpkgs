{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.grafana;
  opt = options.services.grafana;
  provisioningSettingsFormat = pkgs.formats.yaml {};
  declarativePlugins = pkgs.linkFarm "grafana-plugins" (builtins.map (pkg: { name = pkg.pname; path = pkg; }) cfg.declarativePlugins);
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";

  envOptions = {
    PATHS_DATA = cfg.dataDir;
    PATHS_PLUGINS = if builtins.isNull cfg.declarativePlugins then "${cfg.dataDir}/plugins" else declarativePlugins;
    PATHS_LOGS = "${cfg.dataDir}/log";

    SERVER_SERVE_FROM_SUBPATH = boolToString cfg.server.serveFromSubPath;
    SERVER_PROTOCOL = cfg.protocol;
    SERVER_HTTP_ADDR = cfg.addr;
    SERVER_HTTP_PORT = cfg.port;
    SERVER_SOCKET = cfg.socket;
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

    AUTH_DISABLE_LOGIN_FORM = boolToString cfg.auth.disableLoginForm;

    AUTH_ANONYMOUS_ENABLED = boolToString cfg.auth.anonymous.enable;
    AUTH_ANONYMOUS_ORG_NAME = cfg.auth.anonymous.org_name;
    AUTH_ANONYMOUS_ORG_ROLE = cfg.auth.anonymous.org_role;

    AUTH_AZUREAD_NAME = "Azure AD";
    AUTH_AZUREAD_ENABLED = boolToString cfg.auth.azuread.enable;
    AUTH_AZUREAD_ALLOW_SIGN_UP = boolToString cfg.auth.azuread.allowSignUp;
    AUTH_AZUREAD_CLIENT_ID = cfg.auth.azuread.clientId;
    AUTH_AZUREAD_SCOPES = "openid email profile";
    AUTH_AZUREAD_AUTH_URL = "https://login.microsoftonline.com/${cfg.auth.azuread.tenantId}/oauth2/v2.0/authorize";
    AUTH_AZUREAD_TOKEN_URL = "https://login.microsoftonline.com/${cfg.auth.azuread.tenantId}/oauth2/v2.0/token";
    AUTH_AZUREAD_ALLOWED_DOMAINS = cfg.auth.azuread.allowedDomains;
    AUTH_AZUREAD_ALLOWED_GROUPS = cfg.auth.azuread.allowedGroups;
    AUTH_AZUREAD_ROLE_ATTRIBUTE_STRICT = false;

    AUTH_GOOGLE_ENABLED = boolToString cfg.auth.google.enable;
    AUTH_GOOGLE_ALLOW_SIGN_UP = boolToString cfg.auth.google.allowSignUp;
    AUTH_GOOGLE_CLIENT_ID = cfg.auth.google.clientId;

    ANALYTICS_REPORTING_ENABLED = boolToString cfg.analytics.reporting.enable;

    SMTP_ENABLED = boolToString cfg.smtp.enable;
    SMTP_HOST = cfg.smtp.host;
    SMTP_USER = cfg.smtp.user;
    SMTP_PASSWORD = cfg.smtp.password;
    SMTP_FROM_ADDRESS = cfg.smtp.fromAddress;
  } // cfg.extraOptions;

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
  options.services.grafana = {
    enable = mkEnableOption (lib.mdDoc "grafana");

    protocol = mkOption {
      description = lib.mdDoc "Which protocol to listen.";
      default = "http";
      type = types.enum ["http" "https" "socket"];
    };

    addr = mkOption {
      description = lib.mdDoc "Listening address.";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = lib.mdDoc "Listening port.";
      default = 3000;
      type = types.port;
    };

    socket = mkOption {
      description = lib.mdDoc "Listening socket.";
      default = "/run/grafana/grafana.sock";
      type = types.str;
    };

    domain = mkOption {
      description = lib.mdDoc "The public facing domain name used to access grafana from a browser.";
      default = "localhost";
      type = types.str;
    };

    rootUrl = mkOption {
      description = lib.mdDoc "Full public facing url.";
      default = "%(protocol)s://%(domain)s:%(http_port)s/";
      type = types.str;
    };

    certFile = mkOption {
      description = lib.mdDoc "Cert file for ssl.";
      default = "";
      type = types.str;
    };

    certKey = mkOption {
      description = lib.mdDoc "Cert key for ssl.";
      default = "";
      type = types.str;
    };

    staticRootPath = mkOption {
      description = lib.mdDoc "Root path for static assets.";
      default = "${cfg.package}/share/grafana/public";
      defaultText = literalExpression ''"''${package}/share/grafana/public"'';
      type = types.str;
    };

    package = mkOption {
      description = lib.mdDoc "Package to use.";
      default = pkgs.grafana;
      defaultText = literalExpression "pkgs.grafana";
      type = types.package;
    };

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

    dataDir = mkOption {
      description = lib.mdDoc "Data directory.";
      default = "/var/lib/grafana";
      type = types.path;
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
          Database password.
          This option is mutual exclusive with the passwordFile option.
        '';
        default = "";
        type = types.str;
      };

      passwordFile = mkOption {
        description = lib.mdDoc ''
          File that containts the database password.
          This option is mutual exclusive with the password option.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      path = mkOption {
        description = lib.mdDoc "Database path.";
        default = "${cfg.dataDir}/data/grafana.db";
        defaultText = literalExpression ''"''${config.${opt.dataDir}}/data/grafana.db"'';
        type = types.path;
      };

      connMaxLifetime = mkOption {
        description = lib.mdDoc ''
          Sets the maximum amount of time (in seconds) a connection may be reused.
          For MySQL this setting should be shorter than the `wait_timeout` variable.
        '';
        default = "unlimited";
        example = 14400;
        type = types.either types.int (types.enum [ "unlimited" ]);
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
                  description = lib.mdDoc "List of contact points to import or update.";
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

    security = {
      adminUser = mkOption {
        description = lib.mdDoc "Default admin username.";
        default = "admin";
        type = types.str;
      };

      adminPassword = mkOption {
        description = lib.mdDoc ''
          Default admin password.
          This option is mutual exclusive with the adminPasswordFile option.
        '';
        default = "admin";
        type = types.str;
      };

      adminPasswordFile = mkOption {
        description = lib.mdDoc ''
          Default admin password.
          This option is mutual exclusive with the `adminPassword` option.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      secretKey = mkOption {
        description = lib.mdDoc "Secret key used for signing.";
        default = "SW2YcwTIb9zpOOhoPsMm";
        type = types.str;
      };

      secretKeyFile = mkOption {
        description = lib.mdDoc "Secret key used for signing.";
        default = null;
        type = types.nullOr types.path;
      };
    };

    server = {
      serveFromSubPath = mkOption {
        description = lib.mdDoc "Serve Grafana from subpath specified in rootUrl setting";
        default = false;
        type = types.bool;
      };
    };

    smtp = {
      enable = mkEnableOption (lib.mdDoc "smtp");
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
          Password used for authentication.
          This option is mutual exclusive with the passwordFile option.
        '';
        default = "";
        type = types.str;
      };
      passwordFile = mkOption {
        description = lib.mdDoc ''
          Password used for authentication.
          This option is mutual exclusive with the password option.
        '';
        default = null;
        type = types.nullOr types.path;
      };
      fromAddress = mkOption {
        description = lib.mdDoc "Email address used for sending.";
        default = "admin@grafana.localhost";
        type = types.str;
      };
    };

    users = {
      allowSignUp = mkOption {
        description = lib.mdDoc "Disable user signup / registration.";
        default = false;
        type = types.bool;
      };

      allowOrgCreate = mkOption {
        description = lib.mdDoc "Whether user is allowed to create organizations.";
        default = false;
        type = types.bool;
      };

      autoAssignOrg = mkOption {
        description = lib.mdDoc "Whether to automatically assign new users to default org.";
        default = true;
        type = types.bool;
      };

      autoAssignOrgRole = mkOption {
        description = lib.mdDoc "Default role new users will be auto assigned.";
        default = "Viewer";
        type = types.enum ["Viewer" "Editor"];
      };
    };

    auth = {
      disableLoginForm = mkOption {
        description = lib.mdDoc "Set to true to disable (hide) the login form, useful if you use OAuth";
        default = false;
        type = types.bool;
      };

      anonymous = {
        enable = mkOption {
          description = lib.mdDoc "Whether to allow anonymous access.";
          default = false;
          type = types.bool;
        };
        org_name = mkOption {
          description = lib.mdDoc "Which organization to allow anonymous access to.";
          default = "Main Org.";
          type = types.str;
        };
        org_role = mkOption {
          description = lib.mdDoc "Which role anonymous users have in the organization.";
          default = "Viewer";
          type = types.str;
        };
      };
      azuread = {
        enable = mkOption {
          description = lib.mdDoc "Whether to allow Azure AD OAuth.";
          default = false;
          type = types.bool;
        };
        allowSignUp = mkOption {
          description = lib.mdDoc "Whether to allow sign up with Azure AD OAuth.";
          default = false;
          type = types.bool;
        };
        clientId = mkOption {
          description = lib.mdDoc "Azure AD OAuth client ID.";
          default = "";
          type = types.str;
        };
        clientSecretFile = mkOption {
          description = lib.mdDoc "Azure AD OAuth client secret.";
          default = null;
          type = types.nullOr types.path;
        };
        tenantId = mkOption {
          description = lib.mdDoc ''
            Tenant id used to create auth and token url. Default to "common"
            , let user sign in with any tenant.
            '';
          default = "common";
          type = types.str;
        };
        allowedDomains = mkOption {
          description = lib.mdDoc ''
            Limits access to users who belong to specific domains.
            Separate domains with space or comma.
          '';
          default = "";
          type = types.str;
        };
        allowedGroups = mkOption {
          description = lib.mdDoc ''
            To limit access to authenticated users who are members of one or more groups,
            set allowedGroups to a comma- or space-separated list of group object IDs.
            You can find object IDs for a specific group on the Azure portal.
            '';
          default = "";
          type = types.str;
        };
      };
      google = {
        enable = mkOption {
          description = lib.mdDoc "Whether to allow Google OAuth2.";
          default = false;
          type = types.bool;
        };
        allowSignUp = mkOption {
          description = lib.mdDoc "Whether to allow sign up with Google OAuth2.";
          default = false;
          type = types.bool;
        };
        clientId = mkOption {
          description = lib.mdDoc "Google OAuth2 client ID.";
          default = "";
          type = types.str;
        };
        clientSecretFile = mkOption {
          description = lib.mdDoc "Google OAuth2 client secret.";
          default = null;
          type = types.nullOr types.path;
        };
      };
    };

    analytics.reporting = {
      enable = mkOption {
        description = lib.mdDoc "Whether to allow anonymous usage reporting to stats.grafana.net.";
        default = true;
        type = types.bool;
      };
    };

    extraOptions = mkOption {
      description = lib.mdDoc ''
        Extra configuration options passed as env variables as specified in
        [documentation](http://docs.grafana.org/installation/configuration/),
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
        let
          checkOpts = opt: any (x: x.password != null || x.basicAuthPassword != null || x.secureJsonData != null) opt;
          datasourcesUsed = if (cfg.provision.datasources.settings == null) then [] else cfg.provision.datasources.settings.datasources;
        in if (builtins.isList cfg.provision.datasources) then checkOpts cfg.provision.datasources else checkOpts datasourcesUsed
      ) "Datasource passwords will be stored as plaintext in the Nix store! Use file provider instead.")
      (optional (
        any (x: x.secure_settings != null) cfg.provision.notifiers
      ) "Notifier secure settings will be stored as plaintext in the Nix store! Use file provider instead.")
      (optional (
        builtins.isList cfg.provision.datasources
      ) ''
          Provisioning Grafana datasources with options has been deprecated.
          Use `services.grafana.provision.datasources.settings` or
          `services.grafana.provision.datasources.path` instead.
        '')
      (optional (
        builtins.isList cfg.provision.dashboards
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
        assertion = cfg.database.password != opt.database.password.default -> cfg.database.passwordFile == null;
        message = "Cannot set both password and passwordFile";
      }
      {
        assertion = cfg.security.adminPassword != opt.security.adminPassword.default -> cfg.security.adminPasswordFile == null;
        message = "Cannot set both adminPassword and adminPasswordFile";
      }
      {
        assertion = cfg.security.secretKey != opt.security.secretKey.default -> cfg.security.secretKeyFile == null;
        message = "Cannot set both secretKey and secretKeyFile";
      }
      {
        assertion = cfg.smtp.password != opt.smtp.password.default -> cfg.smtp.passwordFile == null;
        message = "Cannot set both password and passwordFile";
      }
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
      environment = {
        QT_QPA_PLATFORM = "offscreen";
      } // mapAttrs' (n: v: nameValuePair "GF_${n}" (toString v)) envOptions;
      script = ''
        set -o errexit -o pipefail -o nounset -o errtrace
        shopt -s inherit_errexit

        ${optionalString (cfg.auth.azuread.clientSecretFile != null) ''
          GF_AUTH_AZUREAD_CLIENT_SECRET="$(<${escapeShellArg cfg.auth.azuread.clientSecretFile})"
          export GF_AUTH_AZUREAD_CLIENT_SECRET
        ''}
        ${optionalString (cfg.auth.google.clientSecretFile != null) ''
          GF_AUTH_GOOGLE_CLIENT_SECRET="$(<${escapeShellArg cfg.auth.google.clientSecretFile})"
          export GF_AUTH_GOOGLE_CLIENT_SECRET
        ''}
        ${optionalString (cfg.database.passwordFile != null) ''
          GF_DATABASE_PASSWORD="$(<${escapeShellArg cfg.database.passwordFile})"
          export GF_DATABASE_PASSWORD
        ''}
        ${optionalString (cfg.security.adminPasswordFile != null) ''
          GF_SECURITY_ADMIN_PASSWORD="$(<${escapeShellArg cfg.security.adminPasswordFile})"
          export GF_SECURITY_ADMIN_PASSWORD
        ''}
        ${optionalString (cfg.security.secretKeyFile != null) ''
          GF_SECURITY_SECRET_KEY="$(<${escapeShellArg cfg.security.secretKeyFile})"
          export GF_SECURITY_SECRET_KEY
        ''}
        ${optionalString (cfg.smtp.passwordFile != null) ''
          GF_SMTP_PASSWORD="$(<${escapeShellArg cfg.smtp.passwordFile})"
          export GF_SMTP_PASSWORD
        ''}
        ${optionalString cfg.provision.enable ''
          export GF_PATHS_PROVISIONING=${provisionConfDir};
        ''}
        exec ${cfg.package}/bin/grafana-server -homepath ${cfg.dataDir}
      '';
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        User = "grafana";
        RuntimeDirectory = "grafana";
        RuntimeDirectoryMode = "0755";
        # Hardening
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = if (cfg.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
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
