{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  options.services.linkding = {
    # General options
    enable = lib.mkEnableOption "linkding service";

    package = lib.mkPackageOption pkgs "linkding" { };

    # Service configuration, in order of https://linkding.link/options/#list-of-options
    enableBackgroundTasks = lib.mkOption {
      default = true;
      description = ''
        Enable background tasks, such as creating snapshots for bookmarks on the the [Internet Archive Wayback Machine](https://archive.org/web/)
        (`LD_DISABLE_BACKGROUND_TASKS` environment variable)[https://linkding.link/options/#ld_disable_background_tasks].
      '';
      type = lib.types.bool;
    };

    enableUrlValidation = lib.mkOption {
      default = true;
      description = ''
        Enable URL validation for bookmarks
        (`LD_DISABLE_URL_VALIDATION` environment variable)[https://linkding.link/options/#ld_disable_url_validation].
      '';
      type = lib.types.bool;
    };

    requestTimeoutSeconds = lib.mkOption {
      default = 60;
      description = ''
        Request timeout in the uwsgi application server
        (`LD_REQUEST_TIMEOUT` environment variable)[https://linkding.link/options/#ld_request_timeout].
      '';
      type = lib.types.ints.unsigned;
    };

    host = lib.mkOption {
      default = "::1";
      description = ''
        Address for socket to bind to
        (`LD_SERVER_HOST` environment variable)[https://linkding.link/options/#ld_server_host].
      '';
      type = lib.types.str;
    };

    port = lib.mkOption {
      default = 9090;
      description = ''
        Port number
        (`LD_SERVER_PORT` environment variable)[https://linkding.link/options/#ld_server_port].
      '';
      type = lib.types.port;
    };

    contextPath = lib.mkOption {
      default = null;
      description = ''
        Context path of the website
        (`LD_CONTEXT_PATH` environment variable)[https://linkding.link/options/#ld_context_path].
      '';
      type = lib.types.nullOr lib.types.str;
    };

    enableAuthProxy = lib.mkOption {
      default = false;
      description = ''
        Enable support for authentication proxy
        (`LD_ENABLE_AUTH_PROXY` environment variable)[https://linkding.link/options/#ld_enable_auth_proxy].
      '';
      type = lib.types.bool;
    };

    enableOidc = lib.mkOption {
      default = false;
      description = ''
        Enable support for OpenID Connect (OIDC) authentication
        (`LD_ENABLE_OIDC` environment variable)[https://linkding.link/options/#ld_enable_oidc].
      '';
      type = lib.types.bool;
    };

    csrfTrustedOrigins = lib.mkOption {
      default = [ ];
      description = ''
        List of trusted origins to allow for POST requests
        (`LD_CSRF_TRUSTED_ORIGINS` environment variable)[https://linkding.link/options/#ld_csrf_trusted_origins].
      '';
      type = lib.types.listOf lib.types.str;
    };

    logXForwardedFor = lib.mkOption {
      default = false;
      description = ''
        Set uWSGI [log-x-forwarded-for](https://uwsgi-docs.readthedocs.io/en/latest/Options.html?#log-x-forwarded-for) parameter
        (`LD_LOG_X_FORWARDED_FOR` environment variable)[https://linkding.link/options/#ld_log_x_forwarded_for].
      '';
      type = lib.types.bool;
    };

    databaseEngine = lib.mkOption {
      default = "sqlite";
      description = ''
        Database engine used by linkding to store data
        (`LD_DB_ENGINE` environment variable)[https://linkding.link/options/#ld_db_engine].
      '';
      type = lib.types.enum [
        "postgres"
        "sqlite"
      ];
    };

    databaseName = lib.mkOption {
      default = "linkding";
      description = ''
        Database name
        (`LD_DB_DATABASE` environment variable)[https://linkding.link/options/#ld_db_database].
      '';
      type = lib.types.str;
    };

    databaseUser = lib.mkOption {
      default = "linkding";
      description = ''
        Database username
        (`LD_DB_USER` environment variable)[https://linkding.link/options/#ld_db_user].
      '';
      type = lib.types.str;
    };

    databasePassword = lib.mkOption {
      default = null;
      description = ''
        Database username
        (`LD_DB_PASSWORD` environment variable)[https://linkding.link/options/#ld_db_password].
      '';
      type = lib.types.nullOr lib.types.str;
    };

    databaseHost = lib.mkOption {
      default = "127.0.0.1";
      description = ''
        Hostname or IP address of the database server
        (`LD_DB_HOST` environment variable)[https://linkding.link/options/#ld_db_host].
      '';
      type = lib.types.str;
    };

    databasePort = lib.mkOption {
      default = null;
      description = ''
        Database server port number
        (`LD_DB_PORT` environment variable)[https://linkding.link/options/#ld_db_port].
      '';
      type = lib.types.nullOr lib.types.port;
    };

    databaseOptions = lib.mkOption {
      default = { };
      description = ''
        Database server port number
        (`LD_DB_OPTIONS` environment variable)[https://linkding.link/options/#ld_db_options].
      '';
      type = lib.types.attrsOf lib.types.str;
    };

    faviconProviderUrl = lib.mkOption {
      default = "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url={url}&size=32";
      description = ''
        URL used for downloading favicons
        (`LD_FAVICON_PROVIDER` environment variable)[https://linkding.link/options/#ld_favicon_provider].
      '';
      type = lib.types.str;
    };

    singleFileTimeoutSeconds = lib.mkOption {
      default = 60.0;
      description = ''
        How long to wait for the snapshot to complete
        (`LD_REQUEST_TIMEOUT` environment variable)[https://linkding.link/options/#ld_request_timeout].
      '';
      type = lib.types.addCheck (
        lib.types.float
        // {
          name = "nonnegativeFloat";
          description = "nonnegative floating point number, meaning >=0";
          descriptionClass = "nonRestrictiveClause";
        }
      ) (n: n >= 0);
    };

    singleFileOptions = lib.mkOption {
      default = null;
      description = ''
        `single-file` options for creating HTML archive snapshots
        (`LD_SINGLEFILE_OPTIONS` environment variable)[https://linkding.link/options/#ld_singlefile_options].
      '';
      type = lib.types.nullOr lib.types.str;
    };

    enableRequestLogs = lib.mkOption {
      default = true;
      description = ''
        Set uWSGI [disable-logging](https://uwsgi-docs.readthedocs.io/en/latest/Options.html#disable-logging) parameter
        (`LD_DISABLE_REQUEST_LOGS` environment variable)[https://linkding.link/options/#ld_disable_request_logs].
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.services.linkding.enable {
    systemd.services.linkding = {
      description = "linkding";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment =
        let
          boolToPythonRepr = value: if value then "True" else "False";
        in
        {
          LD_DISABLE_BACKGROUND_TASKS = boolToPythonRepr (!config.services.linkding.enableBackgroundTasks);
          LD_DISABLE_URL_VALIDATION = boolToPythonRepr (!config.services.linkding.enableUrlValidation);
          LD_REQUEST_TIMEOUT = builtins.toString config.services.linkding.requestTimeoutSeconds;
          LD_SERVER_HOST = config.services.linkding.host;
          LD_SERVER_PORT = builtins.toString config.services.linkding.port;
          LD_ENABLE_AUTH_PROXY = boolToPythonRepr config.services.linkding.enableAuthProxy;
          LD_ENABLE_OIDC = boolToPythonRepr config.services.linkding.enableOidc;
          LD_LOG_X_FORWARDED_FOR = boolToPythonRepr config.services.linkding.logXForwardedFor;
          LD_DB_ENGINE = config.services.linkding.databaseEngine;
          LD_DB_DATABASE = config.services.linkding.databaseName;
          LD_DB_USER = config.services.linkding.databaseUser;
          LD_DB_HOST = config.services.linkding.databaseHost;
          LD_DB_OPTIONS = builtins.toJSON config.services.linkding.databaseOptions;
          LD_FAVICON_PROVIDER = config.services.linkding.faviconProviderUrl;
          LD_SINGLEFILE_TIMEOUT_SEC = builtins.toString config.services.linkding.singleFileTimeoutSeconds;
          LD_DISABLE_REQUEST_LOGS = boolToPythonRepr (!config.services.linkding.enableRequestLogs);
        }
        // lib.optionalAttrs (config.services.linkding.contextPath != null) {
          LD_CONTEXT_PATH = config.services.linkding.contextPath;
        }
        // lib.optionalAttrs (config.services.linkding.csrfTrustedOrigins != [ ]) {
          LD_CSRF_TRUSTED_ORIGINS = lib.strings.concatStringsSep "," config.services.linkding.csrfTrustedOrigins;
        }
        // lib.optionalAttrs (config.services.linkding.databasePassword != null) {
          LD_DB_PASSWORD = config.services.linkding.databasePassword;
        }
        // lib.optionalAttrs (config.services.linkding.databasePort != null) {
          LD_DB_PORT = config.services.linkding.databasePort;
        }
        // lib.optionalAttrs (config.services.linkding.singleFileOptions != null) {
          LD_SINGLEFILE_OPTIONS = config.services.linkding.singleFileOptions;
        };

      serviceConfig.ExecStart = "${config.services.linkding.package}/bootstrap.sh";
    };
  };

  meta.maintainers = [ lib.maintainers.l0b0 ];
}
