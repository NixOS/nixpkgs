{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.tt-rss;

  configVersion = 26;

  dbPort = if cfg.database.port == null
    then (if cfg.database.type == "pgsql" then 5432 else 3306)
    else cfg.database.port;

  poolName = "tt-rss";

  mysqlLocal = cfg.database.createLocally && cfg.database.type == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "pgsql";

  tt-rss-config = let
    password =
      if (cfg.database.password != null) then
        "'${(escape ["'" "\\"] cfg.database.password)}'"
      else if (cfg.database.passwordFile != null) then
        "file_get_contents('${cfg.database.passwordFile}')"
      else
        null
      ;
  in pkgs.writeText "config.php" ''
    <?php
      putenv('TTRSS_PHP_EXECUTABLE=${pkgs.php}/bin/php');

      putenv('TTRSS_LOCK_DIRECTORY=${cfg.root}/lock');
      putenv('TTRSS_CACHE_DIR=${cfg.root}/cache');
      putenv('TTRSS_ICONS_DIR=${cfg.root}/feed-icons');
      putenv('TTRSS_ICONS_URL=feed-icons');
      putenv('TTRSS_SELF_URL_PATH=${cfg.selfUrlPath}');

      putenv('TTRSS_MYSQL_CHARSET=UTF8');

      putenv('TTRSS_DB_TYPE=${cfg.database.type}');
      putenv('TTRSS_DB_HOST=${optionalString (cfg.database.host != null) cfg.database.host}');
      putenv('TTRSS_DB_USER=${cfg.database.user}');
      putenv('TTRSS_DB_NAME=${cfg.database.name}');
      putenv('TTRSS_DB_PASS=' ${optionalString (password != null) ". ${password}"});
      putenv('TTRSS_DB_PORT=${toString dbPort}');

      putenv('TTRSS_AUTH_AUTO_CREATE=${boolToString cfg.auth.autoCreate}');
      putenv('TTRSS_AUTH_AUTO_LOGIN=${boolToString cfg.auth.autoLogin}');

      putenv('TTRSS_FEED_CRYPT_KEY=${escape ["'" "\\"] cfg.feedCryptKey}');


      putenv('TTRSS_SINGLE_USER_MODE=${boolToString cfg.singleUserMode}');

      putenv('TTRSS_SIMPLE_UPDATE_MODE=${boolToString cfg.simpleUpdateMode}');

      # Never check for updates - the running version of the code should
      # be controlled entirely by the version of TT-RSS active in the
      # current Nix profile. If TT-RSS updates itself to a version
      # requiring a database schema upgrade, and then the SystemD
      # tt-rss.service is restarted, the old code copied from the Nix
      # store will overwrite the updated version, causing the code to
      # detect the need for a schema "upgrade" (since the schema version
      # in the database is different than in the code), but the update
      # schema operation in TT-RSS will do nothing because the schema
      # version in the database is newer than that in the code.
      putenv('TTRSS_CHECK_FOR_UPDATES=false');

      putenv('TTRSS_FORCE_ARTICLE_PURGE=${toString cfg.forceArticlePurge}');
      putenv('TTRSS_SESSION_COOKIE_LIFETIME=${toString cfg.sessionCookieLifetime}');
      putenv('TTRSS_ENABLE_GZIP_OUTPUT=${boolToString cfg.enableGZipOutput}');

      putenv('TTRSS_PLUGINS=${builtins.concatStringsSep "," cfg.plugins}');

      putenv('TTRSS_LOG_DESTINATION=${cfg.logDestination}');
      putenv('TTRSS_CONFIG_VERSION=${toString configVersion}');


      putenv('TTRSS_PUBSUBHUBBUB_ENABLED=${boolToString cfg.pubSubHubbub.enable}');
      putenv('TTRSS_PUBSUBHUBBUB_HUB=${cfg.pubSubHubbub.hub}');

      putenv('TTRSS_SPHINX_SERVER=${cfg.sphinx.server}');
      putenv('TTRSS_SPHINX_INDEX=${builtins.concatStringsSep "," cfg.sphinx.index}');

      putenv('TTRSS_ENABLE_REGISTRATION=${boolToString cfg.registration.enable}');
      putenv('TTRSS_REG_NOTIFY_ADDRESS=${cfg.registration.notifyAddress}');
      putenv('TTRSS_REG_MAX_USERS=${toString cfg.registration.maxUsers}');

      putenv('TTRSS_SMTP_SERVER=${cfg.email.server}');
      putenv('TTRSS_SMTP_LOGIN=${cfg.email.login}');
      putenv('TTRSS_SMTP_PASSWORD=${escape ["'" "\\"] cfg.email.password}');
      putenv('TTRSS_SMTP_SECURE=${cfg.email.security}');

      putenv('TTRSS_SMTP_FROM_NAME=${escape ["'" "\\"] cfg.email.fromName}');
      putenv('TTRSS_SMTP_FROM_ADDRESS=${escape ["'" "\\"] cfg.email.fromAddress}');
      putenv('TTRSS_DIGEST_SUBJECT=${escape ["'" "\\"] cfg.email.digestSubject}');

      ${cfg.extraConfig}
  '';

  # tt-rss and plugins and themes and config.php
  servedRoot = pkgs.runCommand "tt-rss-served-root" {} ''
    cp --no-preserve=mode -r ${pkgs.tt-rss} $out
    cp ${tt-rss-config} $out/config.php
    ${optionalString (cfg.pluginPackages != []) ''
    for plugin in ${concatStringsSep " " cfg.pluginPackages}; do
    cp -r "$plugin"/* "$out/plugins.local/"
    done
    ''}
    ${optionalString (cfg.themePackages != []) ''
    for theme in ${concatStringsSep " " cfg.themePackages}; do
    cp -r "$theme"/* "$out/themes.local/"
    done
    ''}
  '';

 in {

  ###### interface

  options = {

    services.tt-rss = {

      enable = mkEnableOption "tt-rss";

      root = mkOption {
        type = types.path;
        default = "/var/lib/tt-rss";
        description = lib.mdDoc ''
          Root of the application.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "tt_rss";
        description = lib.mdDoc ''
          User account under which both the update daemon and the web-application run.
        '';
      };

      pool = mkOption {
        type = types.str;
        default = "${poolName}";
        description = lib.mdDoc ''
          Name of existing phpfpm pool that is used to run web-application.
          If not specified a pool will be created automatically with
          default values.
        '';
      };

      virtualHost = mkOption {
        type = types.nullOr types.str;
        default = "tt-rss";
        description = lib.mdDoc ''
          Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };

      database = {
        type = mkOption {
          type = types.enum ["pgsql" "mysql"];
          default = "pgsql";
          description = lib.mdDoc ''
            Database to store feeds. Supported are pgsql and mysql.
          '';
        };

        host = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Host of the database. Leave null to use Unix domain socket.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "tt_rss";
          description = lib.mdDoc ''
            Name of the existing database.
          '';
        };

        user = mkOption {
          type = types.str;
          default = "tt_rss";
          description = lib.mdDoc ''
            The database user. The user must exist and has access to
            the specified database.
          '';
        };

        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The database user's password.
          '';
        };

        passwordFile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The database user's password.
          '';
        };

        port = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The database's port. If not set, the default ports will be provided (5432
            and 3306 for pgsql and mysql respectively).
          '';
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Create the database and database user locally.";
        };
      };

      auth = {
        autoCreate = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Allow authentication modules to auto-create users in tt-rss internal
            database when authenticated successfully.
          '';
        };

        autoLogin = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Automatically login user on remote or other kind of externally supplied
            authentication, otherwise redirect to login form as normal.
            If set to true, users won't be able to set application language
            and settings profile.
          '';
        };
      };

      pubSubHubbub = {
        hub = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            URL to a PubSubHubbub-compatible hub server. If defined, "Published
            articles" generated feed would automatically become PUSH-enabled.
          '';
        };

        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Enable client PubSubHubbub support in tt-rss. When disabled, tt-rss
            won't try to subscribe to PUSH feed updates.
          '';
        };
      };

      sphinx = {
        server = mkOption {
          type = types.str;
          default = "localhost:9312";
          description = lib.mdDoc ''
            Hostname:port combination for the Sphinx server.
          '';
        };

        index = mkOption {
          type = types.listOf types.str;
          default = ["ttrss" "delta"];
          description = lib.mdDoc ''
            Index names in Sphinx configuration. Example configuration
            files are available on tt-rss wiki.
          '';
        };
      };

      registration = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Allow users to register themselves. Please be aware that allowing
            random people to access your tt-rss installation is a security risk
            and potentially might lead to data loss or server exploit. Disabled
            by default.
          '';
        };

        notifyAddress = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            Email address to send new user notifications to.
          '';
        };

        maxUsers = mkOption {
          type = types.int;
          default = 0;
          description = lib.mdDoc ''
            Maximum amount of users which will be allowed to register on this
            system. 0 - no limit.
          '';
        };
      };

      email = {
        server = mkOption {
          type = types.str;
          default = "";
          example = "localhost:25";
          description = lib.mdDoc ''
            Hostname:port combination to send outgoing mail. Blank - use system
            MTA.
          '';
        };

        login = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            SMTP authentication login used when sending outgoing mail.
          '';
        };

        password = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            SMTP authentication password used when sending outgoing mail.
          '';
        };

        security = mkOption {
          type = types.enum ["" "ssl" "tls"];
          default = "";
          description = lib.mdDoc ''
            Used to select a secure SMTP connection. Allowed values: ssl, tls,
            or empty.
          '';
        };

        fromName = mkOption {
          type = types.str;
          default = "Tiny Tiny RSS";
          description = lib.mdDoc ''
            Name for sending outgoing mail. This applies to password reset
            notifications, digest emails and any other mail.
          '';
        };

        fromAddress = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            Address for sending outgoing mail. This applies to password reset
            notifications, digest emails and any other mail.
          '';
        };

        digestSubject = mkOption {
          type = types.str;
          default = "[tt-rss] New headlines for last 24 hours";
          description = lib.mdDoc ''
            Subject line for email digests.
          '';
        };
      };

      sessionCookieLifetime = mkOption {
        type = types.int;
        default = 86400;
        description = lib.mdDoc ''
          Default lifetime of a session (e.g. login) cookie. In seconds,
          0 means cookie will be deleted when browser closes.
        '';
      };

      selfUrlPath = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Full URL of your tt-rss installation. This should be set to the
          location of tt-rss directory, e.g. http://example.org/tt-rss/
          You need to set this option correctly otherwise several features
          including PUSH, bookmarklets and browser integration will not work properly.
        '';
        example = "http://localhost";
      };

      feedCryptKey = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Key used for encryption of passwords for password-protected feeds
          in the database. A string of 24 random characters. If left blank, encryption
          is not used. Requires mcrypt functions.
          Warning: changing this key will make your stored feed passwords impossible
          to decrypt.
        '';
      };

      singleUserMode = mkOption {
        type = types.bool;
        default = false;

        description = lib.mdDoc ''
          Operate in single user mode, disables all functionality related to
          multiple users and authentication. Enabling this assumes you have
          your tt-rss directory protected by other means (e.g. http auth).
        '';
      };

      simpleUpdateMode = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enables fallback update mode where tt-rss tries to update feeds in
          background while tt-rss is open in your browser.
          If you don't have a lot of feeds and don't want to or can't run
          background processes while not running tt-rss, this method is generally
          viable to keep your feeds up to date.
          Still, there are more robust (and recommended) updating methods
          available, you can read about them here: http://tt-rss.org/wiki/UpdatingFeeds
        '';
      };

      forceArticlePurge = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          When this option is not 0, users ability to control feed purging
          intervals is disabled and all articles (which are not starred)
          older than this amount of days are purged.
        '';
      };

      enableGZipOutput = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Selectively gzip output to improve wire performance. This requires
          PHP Zlib extension on the server.
          Enabling this can break tt-rss in several httpd/php configurations,
          if you experience weird errors and tt-rss failing to start, blank pages
          after login, or content encoding errors, disable it.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.str;
        default = ["auth_internal" "note"];
        description = lib.mdDoc ''
          List of plugins to load automatically for all users.
          System plugins have to be specified here. Please enable at least one
          authentication plugin here (auth_*).
          Users may enable other user plugins from Preferences/Plugins but may not
          disable plugins specified in this list.
          Disabling auth_internal in this list would automatically disable
          reset password link on the login form.
        '';
      };

      pluginPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = lib.mdDoc ''
          List of plugins to install. The list elements are expected to
          be derivations. All elements in this derivation are automatically
          copied to the `plugins.local` directory.
        '';
      };

      themePackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = lib.mdDoc ''
          List of themes to install. The list elements are expected to
          be derivations. All elements in this derivation are automatically
          copied to the `themes.local` directory.
        '';
      };

      logDestination = mkOption {
        type = types.enum ["" "sql" "syslog"];
        default = "sql";
        description = lib.mdDoc ''
          Log destination to use. Possible values: sql (uses internal logging
          you can read in Preferences -> System), syslog - logs to system log.
          Setting this to blank uses PHP logging (usually to http server
          error.log).
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Additional lines to append to `config.php`.
        '';
      };
    };
  };

  imports = [
    (mkRemovedOptionModule ["services" "tt-rss" "checkForUpdates"] ''
      This option was removed because setting this to true will cause TT-RSS
      to be unable to start if an automatic update of the code in
      services.tt-rss.root leads to a database schema upgrade that is not
      supported by the code active in the Nix store.
    '')
  ];

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.password != null -> cfg.database.passwordFile == null;
        message = "Cannot set both password and passwordFile";
      }
    ];

    services.phpfpm.pools = mkIf (cfg.pool == "${poolName}") {
      ${poolName} = {
        inherit (cfg) user;
        phpPackage = pkgs.php80;
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = "nginx";
          "listen.group" = "nginx";
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = 1;
        };
      };
    };

    # NOTE: No configuration is done if not using virtual host
    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts = {
        ${cfg.virtualHost} = {
          root = "${cfg.root}/www";

          locations."/" = {
            index = "index.php";
          };

          locations."^~ /feed-icons" = {
            root = "${cfg.root}";
          };

          locations."~ \\.php$" = {
            extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.socket};
              fastcgi_index index.php;
            '';
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.root}' 0555 ${cfg.user} tt_rss - -"
      "d '${cfg.root}/lock' 0755 ${cfg.user} tt_rss - -"
      "d '${cfg.root}/cache' 0755 ${cfg.user} tt_rss - -"
      "d '${cfg.root}/cache/upload' 0755 ${cfg.user} tt_rss - -"
      "d '${cfg.root}/cache/images' 0755 ${cfg.user} tt_rss - -"
      "d '${cfg.root}/cache/export' 0755 ${cfg.user} tt_rss - -"
      "d '${cfg.root}/feed-icons' 0755 ${cfg.user} tt_rss - -"
      "L+ '${cfg.root}/www' - - - - ${servedRoot}"
    ];

    systemd.services = {
      phpfpm-tt-rss = mkIf (cfg.pool == "${poolName}") {
        restartTriggers = [ servedRoot ];
      };

      tt-rss = {
        description = "Tiny Tiny RSS feeds update daemon";

        preStart = let
          callSql = e:
              if cfg.database.type == "pgsql" then ''
                  ${optionalString (cfg.database.password != null) "PGPASSWORD=${cfg.database.password}"} \
                  ${optionalString (cfg.database.passwordFile != null) "PGPASSWORD=$(cat ${cfg.database.passwordFile})"} \
                  ${config.services.postgresql.package}/bin/psql \
                    -U ${cfg.database.user} \
                    ${optionalString (cfg.database.host != null) "-h ${cfg.database.host} --port ${toString dbPort}"} \
                    -c '${e}' \
                    ${cfg.database.name}''

              else if cfg.database.type == "mysql" then ''
                  echo '${e}' | ${config.services.mysql.package}/bin/mysql \
                    -u ${cfg.database.user} \
                    ${optionalString (cfg.database.password != null) "-p${cfg.database.password}"} \
                    ${optionalString (cfg.database.host != null) "-h ${cfg.database.host} -P ${toString dbPort}"} \
                    ${cfg.database.name}''

              else "";

        in (optionalString (cfg.database.type == "pgsql") ''
          exists=$(${callSql "select count(*) > 0 from pg_tables where tableowner = user"} \
          | tail -n+3 | head -n-2 | sed -e 's/[ \n\t]*//')

          if [ "$exists" == 'f' ]; then
            ${callSql "\\i ${pkgs.tt-rss}/schema/ttrss_schema_${cfg.database.type}.sql"}
          else
            echo 'The database contains some data. Leaving it as it is.'
          fi;
        '')

        + (optionalString (cfg.database.type == "mysql") ''
          exists=$(${callSql "select count(*) > 0 from information_schema.tables where table_schema = schema()"} \
          | tail -n+2 | sed -e 's/[ \n\t]*//')

          if [ "$exists" == '0' ]; then
            ${callSql "\\. ${pkgs.tt-rss}/schema/ttrss_schema_${cfg.database.type}.sql"}
          else
            echo 'The database contains some data. Leaving it as it is.'
          fi;
        '');

        serviceConfig = {
          User = "${cfg.user}";
          Group = "tt_rss";
          ExecStart = "${pkgs.php}/bin/php ${cfg.root}/www/update.php --daemon --quiet";
          Restart = "on-failure";
          RestartSec = "60";
          SyslogIdentifier = "tt-rss";
        };

        wantedBy = [ "multi-user.target" ];
        requires = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
        after = [ "network.target" ] ++ optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
      };
    };

    services.mysql = mkIf mysqlLocal {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.postgresql = mkIf pgsqlLocal {
      enable = mkDefault true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.user;
          ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
        }
      ];
    };

    users.users.tt_rss = optionalAttrs (cfg.user == "tt_rss") {
      description = "tt-rss service user";
      isSystemUser = true;
      group = "tt_rss";
    };

    users.groups.tt_rss = {};
  };
}
