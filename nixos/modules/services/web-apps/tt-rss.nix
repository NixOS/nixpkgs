{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.tt-rss;

  configVersion = 26;

  cacheDir = "cache";
  lockDir = "lock";
  feedIconsDir = "feed-icons";

  dbPort = if cfg.database.port == null
    then (if cfg.database.type == "pgsql" then 5432 else 3306)
    else cfg.database.port;

  poolName = "tt-rss";
  phpfpmSocketName = "/var/run/phpfpm/${poolName}.sock";

  tt-rss-config = pkgs.writeText "config.php" ''
    <?php

      define('PHP_EXECUTABLE', '${pkgs.php}/bin/php');

      define('LOCK_DIRECTORY', '${lockDir}');
      define('CACHE_DIR', '${cacheDir}');
      define('ICONS_DIR', '${feedIconsDir}');
      define('ICONS_URL', '${feedIconsDir}');
      define('SELF_URL_PATH', '${cfg.selfUrlPath}');

      define('MYSQL_CHARSET', 'UTF8');

      define('DB_TYPE', '${cfg.database.type}');
      define('DB_HOST', '${optionalString (cfg.database.host != null) cfg.database.host}');
      define('DB_USER', '${cfg.database.user}');
      define('DB_NAME', '${cfg.database.name}');
      define('DB_PASS', ${
        if (cfg.database.password != null) then
          "'${(escape ["'" "\\"] cfg.database.password)}'"
        else if (cfg.database.passwordFile != null) then
          "file_get_contents('${cfg.database.passwordFile}')"
        else
          ""
      });
      define('DB_PORT', '${toString dbPort}');

      define('AUTH_AUTO_CREATE', ${boolToString cfg.auth.autoCreate});
      define('AUTH_AUTO_LOGIN', ${boolToString cfg.auth.autoLogin});

      define('FEED_CRYPT_KEY', '${escape ["'" "\\"] cfg.feedCryptKey}');


      define('SINGLE_USER_MODE', ${boolToString cfg.singleUserMode});

      define('SIMPLE_UPDATE_MODE', ${boolToString cfg.simpleUpdateMode});
      define('CHECK_FOR_UPDATES', ${boolToString cfg.checkForUpdates});

      define('FORCE_ARTICLE_PURGE', ${toString cfg.forceArticlePurge});
      define('SESSION_COOKIE_LIFETIME', ${toString cfg.sessionCookieLifetime});
      define('ENABLE_GZIP_OUTPUT', ${boolToString cfg.enableGZipOutput});

      define('PLUGINS', '${builtins.concatStringsSep "," cfg.plugins}');

      define('LOG_DESTINATION', '${cfg.logDestination}');
      define('CONFIG_VERSION', ${toString configVersion});


      define('PUBSUBHUBBUB_ENABLED', ${boolToString cfg.pubSubHubbub.enable});
      define('PUBSUBHUBBUB_HUB', '${cfg.pubSubHubbub.hub}');

      define('SPHINX_SERVER', '${cfg.sphinx.server}');
      define('SPHINX_INDEX', '${builtins.concatStringsSep "," cfg.sphinx.index}');

      define('ENABLE_REGISTRATION', ${boolToString cfg.registration.enable});
      define('REG_NOTIFY_ADDRESS', '${cfg.registration.notifyAddress}');
      define('REG_MAX_USERS', ${toString cfg.registration.maxUsers});

      define('SMTP_SERVER', '${cfg.email.server}');
      define('SMTP_LOGIN', '${cfg.email.login}');
      define('SMTP_PASSWORD', '${escape ["'" "\\"] cfg.email.password}');
      define('SMTP_SECURE', '${cfg.email.security}');

      define('SMTP_FROM_NAME', '${escape ["'" "\\"] cfg.email.fromName}');
      define('SMTP_FROM_ADDRESS', '${escape ["'" "\\"] cfg.email.fromAddress}');
      define('DIGEST_SUBJECT', '${escape ["'" "\\"] cfg.email.digestSubject}');

      ${cfg.extraConfig}
  '';

 in {

  ###### interface

  options = {

    services.tt-rss = {

      enable = mkEnableOption "tt-rss";

      root = mkOption {
        type = types.path;
        default = "/var/lib/tt-rss";
        example = "/var/lib/tt-rss";
        description = ''
          Root of the application.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "tt_rss";
        example = "tt_rss";
        description = ''
          User account under which both the update daemon and the web-application run.
        '';
      };

      pool = mkOption {
        type = types.str;
        default = "${poolName}";
        description = ''
          Name of existing phpfpm pool that is used to run web-application.
          If not specified a pool will be created automatically with
          default values.
        '';
      };

      virtualHost = mkOption {
        type = types.nullOr types.str;
        default = "tt-rss";
        description = ''
          Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };

      database = {
        type = mkOption {
          type = types.enum ["pgsql" "mysql"];
          default = "pgsql";
          description = ''
            Database to store feeds. Supported are pgsql and mysql.
          '';
        };

        host = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Host of the database. Leave null to use Unix domain socket.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "tt_rss";
          description = ''
            Name of the existing database.
          '';
        };

        user = mkOption {
          type = types.str;
          default = "tt_rss";
          description = ''
            The database user. The user must exist and has access to
            the specified database.
          '';
        };

        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The database user's password.
          '';
        };

        passwordFile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The database user's password.
          '';
        };

        port = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            The database's port. If not set, the default ports will be provided (5432
            and 3306 for pgsql and mysql respectively).
          '';
        };
      };

      auth = {
        autoCreate = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Allow authentication modules to auto-create users in tt-rss internal
            database when authenticated successfully.
          '';
        };

        autoLogin = mkOption {
          type = types.bool;
          default = true;
          description = ''
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
          description = ''
            URL to a PubSubHubbub-compatible hub server. If defined, "Published
            articles" generated feed would automatically become PUSH-enabled.
          '';
        };

        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable client PubSubHubbub support in tt-rss. When disabled, tt-rss
            won't try to subscribe to PUSH feed updates.
          '';
        };
      };

      sphinx = {
        server = mkOption {
          type = types.str;
          default = "localhost:9312";
          description = ''
            Hostname:port combination for the Sphinx server.
          '';
        };

        index = mkOption {
          type = types.listOf types.str;
          default = ["ttrss" "delta"];
          description = ''
            Index names in Sphinx configuration. Example configuration
            files are available on tt-rss wiki.
          '';
        };
      };

      registration = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow users to register themselves. Please be aware that allowing
            random people to access your tt-rss installation is a security risk
            and potentially might lead to data loss or server exploit. Disabled
            by default.
          '';
        };

        notifyAddress = mkOption {
          type = types.str;
          default = "";
          description = ''
            Email address to send new user notifications to.
          '';
        };

        maxUsers = mkOption {
          type = types.int;
          default = 0;
          description = ''
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
          description = ''
            Hostname:port combination to send outgoing mail. Blank - use system
            MTA.
          '';
        };

        login = mkOption {
          type = types.str;
          default = "";
          description = ''
            SMTP authentication login used when sending outgoing mail.
          '';
        };

        password = mkOption {
          type = types.str;
          default = "";
          description = ''
            SMTP authentication password used when sending outgoing mail.
          '';
        };

        security = mkOption {
          type = types.enum ["" "ssl" "tls"];
          default = "";
          description = ''
            Used to select a secure SMTP connection. Allowed values: ssl, tls,
            or empty.
          '';
        };

        fromName = mkOption {
          type = types.str;
          default = "Tiny Tiny RSS";
          description = ''
            Name for sending outgoing mail. This applies to password reset
            notifications, digest emails and any other mail.
          '';
        };

        fromAddress = mkOption {
          type = types.str;
          default = "";
          description = ''
            Address for sending outgoing mail. This applies to password reset
            notifications, digest emails and any other mail.
          '';
        };

        digestSubject = mkOption {
          type = types.str;
          default = "[tt-rss] New headlines for last 24 hours";
          description = ''
            Subject line for email digests.
          '';
        };
      };

      sessionCookieLifetime = mkOption {
        type = types.int;
        default = 86400;
        description = ''
          Default lifetime of a session (e.g. login) cookie. In seconds,
          0 means cookie will be deleted when browser closes.
        '';
      };

      selfUrlPath = mkOption {
        type = types.str;
        description = ''
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
        description = ''
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

        description = ''
          Operate in single user mode, disables all functionality related to
          multiple users and authentication. Enabling this assumes you have
          your tt-rss directory protected by other means (e.g. http auth).
        '';
      };

      simpleUpdateMode = mkOption {
        type = types.bool;
        default = false;
        description = ''
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
        description = ''
          When this option is not 0, users ability to control feed purging
          intervals is disabled and all articles (which are not starred)
          older than this amount of days are purged.
        '';
      };

      checkForUpdates = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Check for updates automatically if running Git version
        '';
      };

      enableGZipOutput = mkOption {
        type = types.bool;
        default = true;
        description = ''
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
        description = ''
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
        description = ''
          List of plugins to install. The list elements are expected to
          be derivations. All elements in this derivation are automatically
          copied to the <literal>plugins.local</literal> directory.
        '';
      };

      themePackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          List of themes to install. The list elements are expected to
          be derivations. All elements in this derivation are automatically
          copied to the <literal>themes.local</literal> directory.
        '';
      };

      logDestination = mkOption {
        type = types.enum ["" "sql" "syslog"];
        default = "sql";
        description = ''
          Log destination to use. Possible values: sql (uses internal logging
          you can read in Preferences -> System), syslog - logs to system log.
          Setting this to blank uses PHP logging (usually to http server
          error.log).
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional lines to append to <literal>config.php</literal>.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.password != null -> cfg.database.passwordFile == null;
        message = "Cannot set both password and passwordFile";
      }
    ];

    services.phpfpm.pools = mkIf (cfg.pool == "${poolName}") {
      "${poolName}" = {
        listen = "/var/run/phpfpm/${poolName}.sock";
        extraConfig = ''
          listen.owner = nginx
          listen.group = nginx
          listen.mode = 0600
          user = ${cfg.user}
          pm = dynamic
          pm.max_children = 75
          pm.start_servers = 10
          pm.min_spare_servers = 5
          pm.max_spare_servers = 20
          pm.max_requests = 500
          catch_workers_output = 1
        '';
      };
    };

    # NOTE: No configuration is done if not using virtual host
    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts = {
        "${cfg.virtualHost}" = {
          root = "${cfg.root}";

          locations."/" = {
            index = "index.php";
          };

          locations."~ \.php$" = {
            extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.listen};
              fastcgi_index index.php;
            '';
          };
        };
      };
    };

    systemd.services.tt-rss = let
      dbService = if cfg.database.type == "pgsql" then "postgresql.service" else "mysql.service";
    in {

        description = "Tiny Tiny RSS feeds update daemon";

        preStart = let
          callSql = e:
              if cfg.database.type == "pgsql" then ''
                  ${optionalString (cfg.database.password != null) "PGPASSWORD=${cfg.database.password}"} \
                  ${optionalString (cfg.database.passwordFile != null) "PGPASSWORD=$(cat ${cfg.database.passwordFile}"}) \
                  ${pkgs.sudo}/bin/sudo -u ${cfg.user} ${config.services.postgresql.package}/bin/psql \
                    -U ${cfg.database.user} \
                    ${optionalString (cfg.database.host != null) "-h ${cfg.database.host} --port ${toString dbPort}"} \
                    -c '${e}' \
                    ${cfg.database.name}''

              else if cfg.database.type == "mysql" then ''
                  echo '${e}' | ${pkgs.sudo}/bin/sudo -u ${cfg.user} ${config.services.mysql.package}/bin/mysql \
                    -u ${cfg.database.user} \
                    ${optionalString (cfg.database.password != null) "-p${cfg.database.password}"} \
                    ${optionalString (cfg.database.host != null) "-h ${cfg.database.host} -P ${toString dbPort}"} \
                    ${cfg.database.name}''

              else "";

        in ''
          rm -rf "${cfg.root}/*"
          mkdir -m 755 -p "${cfg.root}"
          cp -r "${pkgs.tt-rss}/"* "${cfg.root}"
          ${optionalString (cfg.pluginPackages != []) ''
            for plugin in ${concatStringsSep " " cfg.pluginPackages}; do
              cp -r "$plugin"/* "${cfg.root}/plugins.local/"
            done
          ''}
          ${optionalString (cfg.themePackages != []) ''
            for theme in ${concatStringsSep " " cfg.themePackages}; do
              cp -r "$theme"/* "${cfg.root}/themes.local/"
            done
          ''}
          ln -sf "${tt-rss-config}" "${cfg.root}/config.php"
          chown -R "${cfg.user}" "${cfg.root}"
          chmod -R 755 "${cfg.root}"
        ''

        + (optionalString (cfg.database.type == "pgsql") ''
          ${optionalString (cfg.database.host == null && cfg.database.password == null) ''
            if ! [ -e ${cfg.root}/.db-created ]; then
              ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} ${config.services.postgresql.package}/bin/createuser ${cfg.database.user}
              ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} ${config.services.postgresql.package}/bin/createdb -O ${cfg.database.user} ${cfg.database.name}
              touch ${cfg.root}/.db-created
            fi
          ''}

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
          ExecStart = "${pkgs.php}/bin/php ${cfg.root}/update.php --daemon";
          StandardOutput = "syslog";
          StandardError = "syslog";
          PermissionsStartOnly = true;
        };

        wantedBy = [ "multi-user.target" ];
        requires = ["${dbService}"];
        after = ["network.target" "${dbService}"];
    };

    services.mysql = optionalAttrs (cfg.database.type == "mysql") {
      enable = true;
      package = mkDefault pkgs.mysql;
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

    services.postgresql = optionalAttrs (cfg.database.type == "pgsql") {
      enable = mkDefault true;
    };

    users = optionalAttrs (cfg.user == "tt_rss") {
      users.tt_rss = {
        description = "tt-rss service user";
        isSystemUser = true;
        group = "tt_rss";
      };
      groups.tt_rss = {};
    };
  };
}
