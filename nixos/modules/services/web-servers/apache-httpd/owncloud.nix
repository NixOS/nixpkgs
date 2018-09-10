{ config, lib, pkgs, serverInfo, php, ... }:

with lib;

let

  owncloudConfig = pkgs.writeText "config.php"
    ''
      <?php

      /* Only enable this for local development and not in productive environments */
      /* This will disable the minifier and outputs some additional debug informations */
      define("DEBUG", false);

      $CONFIG = array(
      /* Flag to indicate ownCloud is successfully installed (true = installed) */
      "installed" => true,

      /* Type of database, can be sqlite, mysql or pgsql */
      "dbtype" => "${config.dbType}",

      /* Name of the ownCloud database */
      "dbname" => "${config.dbName}",

      /* User to access the ownCloud database */
      "dbuser" => "${config.dbUser}",

      /* Password to access the ownCloud database */
      "dbpassword" => "${config.dbPassword}",

      /* Host running the ownCloud database. To specify a port use "HOSTNAME:####"; to specify a unix sockets use "localhost:/path/to/socket". */
      "dbhost" => "${config.dbServer}",

      /* Prefix for the ownCloud tables in the database */
      "dbtableprefix" => "",

      /* Force use of HTTPS connection (true = use HTTPS) */
      "forcessl" => ${config.forceSSL},

      /* Blacklist a specific file and disallow the upload of files with this name - WARNING: USE THIS ONLY IF YOU KNOW WHAT YOU ARE DOING. */
      "blacklisted_files" => array('.htaccess'),

      /* The automatic hostname detection of ownCloud can fail in certain reverse proxy and CLI/cron situations. This option allows to manually override the automatic detection. You can also add a port. For example "www.example.com:88" */
      "overwritehost" => "${config.overwriteHost}",

      /* The automatic protocol detection of ownCloud can fail in certain reverse proxy and CLI/cron situations. This option allows to manually override the protocol detection. For example "https" */
      "overwriteprotocol" => "${config.overwriteProtocol}",

      /* The automatic webroot detection of ownCloud can fail in certain reverse proxy and CLI/cron situations. This option allows to manually override the automatic detection. For example "/domain.tld/ownCloud". The value "/" can be used to remove the root. */
      "overwritewebroot" => "${config.overwriteWebRoot}",

      /* The automatic detection of ownCloud can fail in certain reverse proxy and CLI/cron situations. This option allows to define a manually override condition as regular expression for the remote ip address. For example "^10\.0\.0\.[1-3]$" */
      "overwritecondaddr" => "",

      /* A proxy to use to connect to the internet. For example "myproxy.org:88" */
      "proxy" => "",

      /* The optional authentication for the proxy to use to connect to the internet. The format is: [username]:[password] */
      "proxyuserpwd" => "",

      /* List of trusted domains, to prevent host header poisoning ownCloud is only using these Host headers */
      ${if config.trustedDomain != "" then "'trusted_domains' => array('${config.trustedDomain}')," else ""}

      /* Theme to use for ownCloud */
      "theme" => "",

      /* Optional ownCloud default language - overrides automatic language detection on public pages like login or shared items. This has no effect on the user's language preference configured under "personal -> language" once they have logged in */
      "default_language" => "${config.defaultLang}",

      /* Path to the parent directory of the 3rdparty directory */
      "3rdpartyroot" => "",

      /* URL to the parent directory of the 3rdparty directory, as seen by the browser */
      "3rdpartyurl" => "",

      /* Default app to open on login.
       * This can be a comma-separated list of app ids.
       * If the first app is not enabled for the current user,
       * it will try with the second one and so on. If no enabled app could be found,
       * the "files" app will be displayed instead. */
      "defaultapp" => "${config.defaultApp}",

      /* Enable the help menu item in the settings */
      "knowledgebaseenabled" => true,

      /* Enable installing apps from the appstore */
      "appstoreenabled" => ${config.appStoreEnable},

      /* URL of the appstore to use, server should understand OCS */
      "appstoreurl" => "https://api.owncloud.com/v1",

      /* Domain name used by ownCloud for the sender mail address, e.g. no-reply@example.com */
      "mail_domain" => "${config.mailFromDomain}",

      /* FROM address used by ownCloud for the sender mail address, e.g. owncloud@example.com
         This setting overwrites the built in 'sharing-noreply' and 'lostpassword-noreply'
         FROM addresses, that ownCloud uses
      */
      "mail_from_address" => "${config.mailFrom}",

      /* Enable SMTP class debugging */
      "mail_smtpdebug" => false,

      /* Mode to use for sending mail, can be sendmail, smtp, qmail or php, see PHPMailer docs */
      "mail_smtpmode" => "${config.SMTPMode}",

      /* Host to use for sending mail, depends on mail_smtpmode if this is used */
      "mail_smtphost" => "${config.SMTPHost}",

      /* Port to use for sending mail, depends on mail_smtpmode if this is used */
      "mail_smtpport" => ${config.SMTPPort},

      /* SMTP server timeout in seconds for sending mail, depends on mail_smtpmode if this is used */
      "mail_smtptimeout" => ${config.SMTPTimeout},

      /* SMTP connection prefix or sending mail, depends on mail_smtpmode if this is used.
         Can be "", ssl or tls */
      "mail_smtpsecure" => "${config.SMTPSecure}",

      /* authentication needed to send mail, depends on mail_smtpmode if this is used
       * (false = disable authentication)
       */
      "mail_smtpauth" => ${config.SMTPAuth},

      /* authentication type needed to send mail, depends on mail_smtpmode if this is used
       * Can be LOGIN (default), PLAIN or NTLM */
      "mail_smtpauthtype" => "${config.SMTPAuthType}",

      /* Username to use for sendmail mail, depends on mail_smtpauth if this is used */
      "mail_smtpname" => "${config.SMTPUser}",

      /* Password to use for sendmail mail, depends on mail_smtpauth if this is used */
      "mail_smtppassword" => "${config.SMTPPass}",

      /* memcached servers (Only used when xCache, APC and APCu are absent.) */
      "memcached_servers" => array(
          // hostname, port and optional weight. Also see:
          // http://www.php.net/manual/en/memcached.addservers.php
          // http://www.php.net/manual/en/memcached.addserver.php
          //array('localhost', 11211),
          //array('other.host.local', 11211),
      ),

      /* How long should ownCloud keep deleted files in the trash bin, default value:  30 days */
      'trashbin_retention_obligation' => 30,

      /* Disable/Enable auto expire for the trash bin, by default auto expire is enabled */
      'trashbin_auto_expire' => true,

      /* allow user to change his display name, if it is supported by the back-end */
      'allow_user_to_change_display_name' => true,

      /* Check 3rdparty apps for malicious code fragments */
      "appcodechecker" => true,

      /* Check if ownCloud is up to date */
      "updatechecker" => true,

      /* Are we connected to the internet or are we running in a closed network? */
      "has_internet_connection" => true,

      /* Check if the ownCloud WebDAV server is working correctly. Can be disabled if not needed in special situations*/
      "check_for_working_webdav" => true,

      /* Check if .htaccess protection of data is working correctly. Can be disabled if not needed in special situations*/
      "check_for_working_htaccess" => true,

      /* Place to log to, can be owncloud and syslog (owncloud is log menu item in admin menu) */
      "log_type" => "owncloud",

      /* File for the owncloud logger to log to, (default is ownloud.log in the data dir) */
      "logfile" => "${config.dataDir}/owncloud.log",

      /* Loglevel to start logging at. 0=DEBUG, 1=INFO, 2=WARN, 3=ERROR (default is WARN) */
      "loglevel" => "2",

      /* date format to be used while writing to the owncloud logfile */
      'logdateformat' => 'F d, Y H:i:s',

      ${tzSetting}

      /* Append all database queries and parameters to the log file.
       (watch out, this option can increase the size of your log file)*/
      "log_query" => false,

      /* Whether ownCloud should log the last successfull cron exec */
      "cron_log" => true,

      /*
       * Configure the size in bytes log rotation should happen, 0 or false disables the rotation.
       * This rotates the current owncloud logfile to a new name, this way the total log usage
       * will stay limited and older entries are available for a while longer. The
       * total disk usage is twice the configured size.
       * WARNING: When you use this, the log entries will eventually be lost.
       */
      'log_rotate_size' => "104857600", // 104857600, // 100 MiB

      /* Lifetime of the remember login cookie, default is 15 days */
      "remember_login_cookie_lifetime" => 1296000,

      /* Life time of a session after inactivity */
      "session_lifetime" => 86400,

      /*
       * Enable/disable session keep alive when a user is logged in in the Web UI.
       * This is achieved by sending a "heartbeat" to the server to prevent
       * the session timing out.
       */
      "session_keepalive" => true,

      /* Custom CSP policy, changing this will overwrite the standard policy */
      "custom_csp_policy" => "default-src 'self'; script-src 'self' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; frame-src *; img-src *; font-src 'self' data:; media-src *",

      /* Enable/disable X-Frame-Restriction */
      /* HIGH SECURITY RISK IF DISABLED*/
      "xframe_restriction" => true,

      /* The directory where the user data is stored, default to data in the owncloud
       * directory. The sqlite database is also stored here, when sqlite is used.
       */
      "datadirectory" => "${config.dataDir}/storage",

      /* The directory where the skeleton files are located. These files will be copied to the data
       * directory of new users. Leave empty to not copy any skeleton files.
       */
      // "skeletondirectory" => "",

      /* Enable maintenance mode to disable ownCloud
         If you want to prevent users to login to ownCloud before you start doing some maintenance work,
         you need to set the value of the maintenance parameter to true.
         Please keep in mind that users who are already logged-in are kicked out of ownCloud instantly.
      */
      "maintenance" => false,

      "apps_paths" => array(

      /* Set an array of path for your apps directories
       key 'path' is for the fs path and the key 'url' is for the http path to your
       applications paths. 'writable' indicates whether the user can install apps in this folder.
       You must have at least 1 app folder writable or you must set the parameter 'appstoreenabled' to false
      */
          array(
              'path'=> '${config.dataDir}/apps',
              'url' => '/apps',
              'writable' => true,
          ),
      ),
      'user_backends'=>array(
          /*
          array(
              'class'=>'OC_User_IMAP',
              'arguments'=>array('{imap.gmail.com:993/imap/ssl}INBOX')
          )
          */
      ),
      //links to custom clients
      'customclient_desktop' => ''', //http://owncloud.org/sync-clients/
      'customclient_android' => ''', //https://play.google.com/store/apps/details?id=com.owncloud.android
      'customclient_ios' => ''', //https://itunes.apple.com/us/app/owncloud/id543672169?mt=8

      // PREVIEW
      'enable_previews' => true,
      /* the max width of a generated preview, if value is null, there is no limit */
      'preview_max_x' => null,
      /* the max height of a generated preview, if value is null, there is no limit */
      'preview_max_y' => null,
      /* the max factor to scale a preview, default is set to 10 */
      'preview_max_scale_factor' => 10,
      /* custom path for libreoffice / openoffice binary */
      'preview_libreoffice_path' => '${config.libreofficePath}',
      /* cl parameters for libreoffice / openoffice */
      'preview_office_cl_parameters' => ''',

      /* whether avatars should be enabled */
      'enable_avatars' => true,

      // Extra SSL options to be used for configuration
      'openssl' => array(
          'config' => '/etc/ssl/openssl.cnf',
      ),

      // default cipher used for file encryption, currently we support AES-128-CFB and AES-256-CFB
      'cipher' => 'AES-256-CFB',

      /* whether usage of the instance should be restricted to admin users only */
      'singleuser' => false,

      /* all css and js files will be served by the web server statically in one js file and ons css file*/
      'asset-pipeline.enabled' => false,

      /* where mount.json file should be stored, defaults to data/mount.json */
      'mount_file' => ''',

      /*
       * Location of the cache folder, defaults to "data/$user/cache" where "$user" is the current user.
       *
       * When specified, the format will change to "$cache_path/$user" where "$cache_path" is the configured
       * cache directory and "$user" is the user.
       *
       */
      'cache_path' => ''',

      /* EXPERIMENTAL: option whether to include external storage in quota calculation, defaults to false */
      'quota_include_external_storage' => false,

      /*
       * specifies how often the filesystem is checked for changes made outside owncloud
       * 0 -> never check the filesystem for outside changes, provides a performance increase when it's certain that no changes are made directly to the filesystem
       * 1 -> check each file or folder at most once per request, recomended for general use if outside changes might happen
       * 2 -> check every time the filesystem is used, causes a performance hit when using external storages, not recomended for regular use
       */
      'filesystem_check_changes' => 1,

      /* If true, prevent owncloud from changing the cache due to changes in the filesystem for all storage */
      'filesystem_cache_readonly' => false,

      /**
       * define default folder for shared files and folders
       */
      'share_folder' => '/',

      'version' => '${config.package.version}',

      'openssl' => '${pkgs.openssl.bin}/bin/openssl'

      );

    '';

  tzSetting = let tz = serverInfo.fullConfig.time.timeZone; in optionalString (!isNull tz) ''
    /* timezone used while writing to the owncloud logfile (default: UTC) */
    'logtimezone' => '${tz}',
  '';

  postgresql = serverInfo.fullConfig.services.postgresql.postgresqlPackage;

  setupDb = pkgs.writeScript "setup-owncloud-db" ''
    #!${pkgs.runtimeShell}
    PATH="${postgresql}/bin"
    createuser --no-superuser --no-createdb --no-createrole "${config.dbUser}" || true
    createdb "${config.dbName}" -O "${config.dbUser}" || true
    psql -U postgres -d postgres -c "alter user ${config.dbUser} with password '${config.dbPassword}';" || true

    QUERY="CREATE TABLE appconfig
             ( appid       VARCHAR( 255 ) NOT NULL
             , configkey   VARCHAR( 255 ) NOT NULL
             , configvalue VARCHAR( 255 ) NOT NULL
             );
           GRANT ALL ON appconfig TO ${config.dbUser};
           ALTER TABLE appconfig OWNER TO ${config.dbUser};"

    psql -h "/tmp" -U postgres -d ${config.dbName} -Atw -c "$QUERY" || true
  '';

in

rec {

  extraConfig =
    ''
      ${if config.urlPrefix != "" then "Alias ${config.urlPrefix} ${config.package}" else ''

        RewriteEngine On
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
      ''}

      <Directory ${config.package}>
        Include ${config.package}/.htaccess
      </Directory>
    '';

  globalEnvVars = [
    { name = "OC_CONFIG_PATH"; value = "${config.dataDir}/config/"; }
  ];

  documentRoot = if config.urlPrefix == "" then config.package else null;

  enablePHP = true;

  options = {

    package = mkOption {
      type = types.package;
      default = pkgs.owncloud70;
      defaultText = "pkgs.owncloud70";
      example = literalExample "pkgs.owncloud70";
      description = ''
          ownCloud package to use.
      '';
    };

    urlPrefix = mkOption {
      default = "";
      example = "/owncloud";
      description = ''
        The URL prefix under which the owncloud service appears.
      '';
    };

    id = mkOption {
      default = "main";
      description = ''
        A unique identifier necessary to keep multiple owncloud server
        instances on the same machine apart.  This is used to
        disambiguate the administrative scripts, which get names like
        mediawiki-$id-change-password.
      '';
    };

    adminUser = mkOption {
      default = "owncloud";
      description = "The admin user name for accessing owncloud.";
    };

    adminPassword = mkOption {
      description = "The admin password for accessing owncloud.";
    };

    dbType = mkOption {
      default = "pgsql";
      description = "Type of database, in NixOS, for now, only pgsql.";
    };

    dbName = mkOption {
      default = "owncloud";
      description = "Name of the database that holds the owncloud data.";
    };

    dbServer = mkOption {
      default = "localhost:5432";
      description = ''
        The location of the database server.
      '';
    };

    dbUser = mkOption {
      default = "owncloud";
      description = "The user name for accessing the database.";
    };

    dbPassword = mkOption {
      example = "foobar";
      description = ''
        The password of the database user.  Warning: this is stored in
        cleartext in the Nix store!
      '';
    };

    forceSSL = mkOption {
      default = "false";
      description = "Force use of HTTPS connection.";
    };

    adminAddr = mkOption {
      default = serverInfo.serverConfig.adminAddr;
      example = "admin@example.com";
      description = ''
        Emergency contact e-mail address.  Defaults to the Apache
        admin address.
      '';
    };

    siteName = mkOption {
      default = "owncloud";
      example = "Foobar owncloud";
      description = "Name of the owncloud";
    };

    trustedDomain = mkOption {
      default = "";
      description = "Trusted domain";
    };

    defaultLang = mkOption {
      default = "";
      description = "Default language";
    };

    defaultApp = mkOption {
      default = "";
      description = "Default application";
    };

    appStoreEnable = mkOption {
      default = "true";
      description = "Enable app store";
    };

    mailFrom = mkOption {
      default = "no-reply";
      description = "Mail from";
    };

    mailFromDomain = mkOption {
      default = "example.xyz";
      description = "Mail from domain";
    };

    SMTPMode = mkOption {
      default = "smtp";
      description = "Which mode to use for sending mail: sendmail, smtp, qmail or php.";
    };

    SMTPHost = mkOption {
      default = "";
      description = "SMTP host";
    };

    SMTPPort = mkOption {
      default = "25";
      description = "SMTP port";
    };

    SMTPTimeout = mkOption {
      default = "10";
      description = "SMTP mode";
    };

    SMTPSecure = mkOption {
      default = "ssl";
      description = "SMTP secure";
    };

    SMTPAuth = mkOption {
      default = "true";
      description = "SMTP auth";
    };

    SMTPAuthType = mkOption {
      default = "LOGIN";
      description = "SMTP auth type";
    };

    SMTPUser = mkOption {
      default = "";
      description = "SMTP user";
    };

    SMTPPass = mkOption {
      default = "";
      description = "SMTP pass";
    };

    dataDir = mkOption {
      default = "/var/lib/owncloud";
      description = "Data dir";
    };

    libreofficePath = mkOption {
      default = "/usr/bin/libreoffice";
      description = "Path for LibreOffice/OpenOffice binary.";
    };

    overwriteHost = mkOption {
      default = "";
      description = "The automatic hostname detection of ownCloud can fail in
        certain reverse proxy and CLI/cron situations. This option allows to
        manually override the automatic detection. You can also add a port.";
    };

    overwriteProtocol = mkOption {
      default = "";
      description = "The automatic protocol detection of ownCloud can fail in
        certain reverse proxy and CLI/cron situations. This option allows to
        manually override the protocol detection.";
    };

    overwriteWebRoot = mkOption {
      default = "";
      description = "The automatic webroot detection of ownCloud can fail in
        certain reverse proxy and CLI/cron situations. This option allows to
        manually override the automatic detection.";
    };

  };

  startupScript = pkgs.writeScript "owncloud_startup.sh" ''

    if [ ! -d ${config.dataDir}/config ]; then
      mkdir -p ${config.dataDir}/config
      cp ${owncloudConfig} ${config.dataDir}/config/config.php
      mkdir -p ${config.dataDir}/storage
      mkdir -p ${config.dataDir}/apps
      cp -r ${config.package}/apps/* ${config.dataDir}/apps/
      chmod -R ug+rw ${config.dataDir}
      chmod -R o-rwx ${config.dataDir}
      chown -R wwwrun:wwwrun ${config.dataDir}

      ${pkgs.sudo}/bin/sudo -u postgres ${setupDb}
    fi

    if [ -e ${config.package}/config/ca-bundle.crt ]; then
      cp -f ${config.package}/config/ca-bundle.crt ${config.dataDir}/config/
    fi

    ${php}/bin/php ${config.package}/occ upgrade >> ${config.dataDir}/upgrade.log || true

    chown wwwrun:wwwrun ${config.dataDir}/owncloud.log || true

    QUERY="INSERT INTO groups (gid) values('admin');
           INSERT INTO users (uid,password)
             values('${config.adminUser}','${builtins.hashString "sha1" config.adminPassword}');
           INSERT INTO group_user (gid,uid)
             values('admin','${config.adminUser}');"
    ${pkgs.sudo}/bin/sudo -u postgres ${postgresql}/bin/psql -h "/tmp" -U postgres -d ${config.dbName} -Atw -c "$QUERY" || true
  '';
}
