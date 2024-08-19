{ config, pkgs, lib, ... }:

let

  inherit (lib) mkDefault mkEnableOption mkPackageOption mkForce mkIf mkMerge mkOption;
  inherit (lib) concatStringsSep literalExpression mapAttrsToList optional optionals optionalString types;

  cfg = config.services.mediawiki;
  fpm = config.services.phpfpm.pools.mediawiki;
  user = "mediawiki";
  group =
    if cfg.webserver == "apache" then
      config.services.httpd.group
    else if cfg.webserver == "nginx" then
      config.services.nginx.group
    else "mediawiki";

  cacheDir = "/var/cache/mediawiki";
  stateDir = "/var/lib/mediawiki";

  # https://www.mediawiki.org/wiki/Compatibility
  php = pkgs.php82;

  pkg = pkgs.stdenv.mkDerivation rec {
    pname = "mediawiki-full";
    inherit (src) version;
    src = cfg.package;

    installPhase = ''
      mkdir -p $out
      cp -r * $out/

      # try removing directories before symlinking to allow overwriting any builtin extension or skin
      ${concatStringsSep "\n" (mapAttrsToList (k: v: ''
        rm -rf $out/share/mediawiki/skins/${k}
        ln -s ${v} $out/share/mediawiki/skins/${k}
      '') cfg.skins)}

      ${concatStringsSep "\n" (mapAttrsToList (k: v: ''
        rm -rf $out/share/mediawiki/extensions/${k}
        ln -s ${if v != null then v else "$src/share/mediawiki/extensions/${k}"} $out/share/mediawiki/extensions/${k}
      '') cfg.extensions)}
    '';
  };

  mediawikiScripts = pkgs.runCommand "mediawiki-scripts" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    preferLocalBuild = true;
  } ''
    mkdir -p $out/bin
    for i in changePassword.php createAndPromote.php userOptions.php edit.php nukePage.php update.php; do
      makeWrapper ${php}/bin/php $out/bin/mediawiki-$(basename $i .php) \
        --set MEDIAWIKI_CONFIG ${mediawikiConfig} \
        --add-flags ${pkg}/share/mediawiki/maintenance/$i
    done
  '';

  dbAddr = if cfg.database.socket == null then
    "${cfg.database.host}:${toString cfg.database.port}"
  else if cfg.database.type == "mysql" then
    "${cfg.database.host}:${cfg.database.socket}"
  else if cfg.database.type == "postgres" then
    "${cfg.database.socket}"
  else
    throw "Unsupported database type: ${cfg.database.type} for socket: ${cfg.database.socket}";

  mediawikiConfig = pkgs.writeTextFile {
    name = "LocalSettings.php";
    checkPhase = ''
      ${php}/bin/php --syntax-check "$target"
    '';
    text = ''
      <?php
        # Protect against web entry
        if ( !defined( 'MEDIAWIKI' ) ) {
          exit;
        }

        $wgSitename = "${cfg.name}";
        $wgMetaNamespace = false;

        ## The URL base path to the directory containing the wiki;
        ## defaults for all runtime URL paths are based off of this.
        ## For more information on customizing the URLs
        ## (like /w/index.php/Page_title to /wiki/Page_title) please see:
        ## https://www.mediawiki.org/wiki/Manual:Short_URL
        $wgScriptPath = "${lib.optionalString (cfg.webserver == "nginx") "/w"}";

        ## The protocol and server name to use in fully-qualified URLs
        $wgServer = "${cfg.url}";

        ## The URL path to static resources (images, scripts, etc.)
        $wgResourceBasePath = $wgScriptPath;

        ${lib.optionalString (cfg.webserver == "nginx") ''
          $wgArticlePath = "/wiki/$1";
          $wgUsePathInfo = true;
        ''}

        ## The URL path to the logo.  Make sure you change this from the default,
        ## or else you'll overwrite your logo when you upgrade!
        $wgLogo = "$wgResourceBasePath/resources/assets/wiki.png";

        ## UPO means: this is also a user preference option

        $wgEnableEmail = true;
        $wgEnableUserEmail = true; # UPO

        $wgPasswordSender = "${cfg.passwordSender}";

        $wgEnotifUserTalk = false; # UPO
        $wgEnotifWatchlist = false; # UPO
        $wgEmailAuthentication = true;

        ## Database settings
        $wgDBtype = "${cfg.database.type}";
        $wgDBserver = "${dbAddr}";
        $wgDBport = "${toString cfg.database.port}";
        $wgDBname = "${cfg.database.name}";
        $wgDBuser = "${cfg.database.user}";
        ${optionalString (cfg.database.passwordFile != null) "$wgDBpassword = file_get_contents(\"${cfg.database.passwordFile}\");"}

        ${optionalString (cfg.database.type == "mysql" && cfg.database.tablePrefix != null) ''
          # MySQL specific settings
          $wgDBprefix = "${cfg.database.tablePrefix}";
        ''}

        ${optionalString (cfg.database.type == "mysql") ''
          # MySQL table options to use during installation or update
          $wgDBTableOptions = "ENGINE=InnoDB, DEFAULT CHARSET=binary";
        ''}

        ## Shared memory settings
        $wgMainCacheType = CACHE_NONE;
        $wgMemCachedServers = [];

        ${optionalString (cfg.uploadsDir != null) ''
          $wgEnableUploads = true;
          $wgUploadDirectory = "${cfg.uploadsDir}";
        ''}

        $wgUseImageMagick = true;
        $wgImageMagickConvertCommand = "${pkgs.imagemagick}/bin/convert";

        # InstantCommons allows wiki to use images from https://commons.wikimedia.org
        $wgUseInstantCommons = false;

        # Periodically send a pingback to https://www.mediawiki.org/ with basic data
        # about this MediaWiki instance. The Wikimedia Foundation shares this data
        # with MediaWiki developers to help guide future development efforts.
        $wgPingback = true;

        ## If you use ImageMagick (or any other shell command) on a
        ## Linux server, this will need to be set to the name of an
        ## available UTF-8 locale
        $wgShellLocale = "C.UTF-8";

        ## Set $wgCacheDirectory to a writable directory on the web server
        ## to make your wiki go slightly faster. The directory should not
        ## be publicly accessible from the web.
        $wgCacheDirectory = "${cacheDir}";

        # Site language code, should be one of the list in ./languages/data/Names.php
        $wgLanguageCode = "en";

        $wgSecretKey = file_get_contents("${stateDir}/secret.key");

        # Changing this will log out all existing sessions.
        $wgAuthenticationTokenVersion = "";

        ## For attaching licensing metadata to pages, and displaying an
        ## appropriate copyright notice / icon. GNU Free Documentation
        ## License and Creative Commons licenses are supported so far.
        $wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
        $wgRightsUrl = "";
        $wgRightsText = "";
        $wgRightsIcon = "";

        # Path to the GNU diff3 utility. Used for conflict resolution.
        $wgDiff = "${pkgs.diffutils}/bin/diff";
        $wgDiff3 = "${pkgs.diffutils}/bin/diff3";

        # Enabled skins.
        ${concatStringsSep "\n" (mapAttrsToList (k: v: "wfLoadSkin('${k}');") cfg.skins)}

        # Enabled extensions.
        ${concatStringsSep "\n" (mapAttrsToList (k: v: "wfLoadExtension('${k}');") cfg.extensions)}


        # End of automatically generated settings.
        # Add more configuration options below.

        ${cfg.extraConfig}
      '';
    };

  withTrailingSlash = str: if lib.hasSuffix "/" str then str else "${str}/";
in
{
  # interface
  options = {
    services.mediawiki = {

      enable = mkEnableOption "MediaWiki";

      package = mkPackageOption pkgs "mediawiki" { };

      finalPackage = mkOption {
        type = types.package;
        readOnly = true;
        default = pkg;
        defaultText = literalExpression "pkg";
        description = ''
          The final package used by the module. This is the package that will have extensions and skins installed.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "MediaWiki";
        example = "Foobar Wiki";
        description = "Name of the wiki.";
      };

      url = mkOption {
        type = types.str;
        default =
          if cfg.webserver == "apache" then
            "${if cfg.httpd.virtualHost.addSSL || cfg.httpd.virtualHost.forceSSL || cfg.httpd.virtualHost.onlySSL then "https" else "http"}://${cfg.httpd.virtualHost.hostName}"
          else if cfg.webserver == "nginx" then
            let
              hasSSL = host: host.forceSSL || host.addSSL;
            in
            "${if hasSSL config.services.nginx.virtualHosts.${cfg.nginx.hostName} then "https" else "http"}://${cfg.nginx.hostName}"
          else
            "http://localhost";
        defaultText = ''
          if "mediawiki uses ssl" then "{"https" else "http"}://''${cfg.hostName}" else "http://localhost";
        '';
        example = "https://wiki.example.org";
        description = "URL of the wiki.";
      };

      uploadsDir = mkOption {
        type = types.nullOr types.path;
        default = "${stateDir}/uploads";
        description = ''
          This directory is used for uploads of pictures. The directory passed here is automatically
          created and permissions adjusted as required.
        '';
      };

      passwordFile = mkOption {
        type = types.path;
        description = ''
          A file containing the initial password for the administrator account "admin".
        '';
        example = "/run/keys/mediawiki-password";
      };

      passwordSender = mkOption {
        type = types.str;
        default =
          if cfg.webserver == "apache" then
            if cfg.httpd.virtualHost.adminAddr != null then
              cfg.httpd.virtualHost.adminAddr
            else
              config.services.httpd.adminAddr else "root@localhost";
        defaultText = literalExpression ''
          if cfg.webserver == "apache" then
            if cfg.httpd.virtualHost.adminAddr != null then
              cfg.httpd.virtualHost.adminAddr
            else
              config.services.httpd.adminAddr else "root@localhost"
        '';
        description = "Contact address for password reset.";
      };

      skins = mkOption {
        default = {};
        type = types.attrsOf types.path;
        description = ''
          Attribute set of paths whose content is copied to the {file}`skins`
          subdirectory of the MediaWiki installation in addition to the default skins.
        '';
      };

      extensions = mkOption {
        default = {};
        type = types.attrsOf (types.nullOr types.path);
        description = ''
          Attribute set of paths whose content is copied to the {file}`extensions`
          subdirectory of the MediaWiki installation and enabled in configuration.

          Use `null` instead of path to enable extensions that are part of MediaWiki.
        '';
        example = literalExpression ''
          {
            Matomo = pkgs.fetchzip {
              url = "https://github.com/DaSchTour/matomo-mediawiki-extension/archive/v4.0.1.tar.gz";
              sha256 = "0g5rd3zp0avwlmqagc59cg9bbkn3r7wx7p6yr80s644mj6dlvs1b";
            };
            ParserFunctions = null;
          }
        '';
      };

      webserver = mkOption {
        type = types.enum [ "apache" "none" "nginx" ];
        default = "apache";
        description = "Webserver to use.";
      };

      database = {
        type = mkOption {
          type = types.enum [ "mysql" "postgres" "mssql" "oracle" ];
          default = "mysql";
          description = "Database engine to use. MySQL/MariaDB is the database of choice by MediaWiki developers.";
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.port;
          default = if cfg.database.type == "mysql" then 3306 else 5432;
          defaultText = literalExpression "3306";
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "mediawiki";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "mediawiki";
          description = "Database user.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/mediawiki-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        tablePrefix = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            If you only have access to a single database and wish to install more than
            one version of MediaWiki, or have other applications that also use the
            database, you can give the table names a unique prefix to stop any naming
            conflicts or confusion.
            See <https://www.mediawiki.org/wiki/Manual:$wgDBprefix>.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default = if (cfg.database.type == "mysql" && cfg.database.createLocally) then
              "/run/mysqld/mysqld.sock"
            else if (cfg.database.type == "postgres" && cfg.database.createLocally) then
              "/run/postgresql"
            else
              null;
          defaultText = literalExpression "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        createLocally = mkOption {
          type = types.bool;
          default = cfg.database.type == "mysql" || cfg.database.type == "postgres";
          defaultText = literalExpression "true";
          description = ''
            Create the database and database user locally.
            This currently only applies if database type "mysql" is selected.
          '';
        };
      };

      nginx.hostName = mkOption {
        type = types.str;
        example = literalExpression ''wiki.example.com'';
        default = "localhost";
        description = ''
          The hostname to use for the nginx virtual host.
          This is used to generate the nginx configuration.
        '';
      };

      httpd.virtualHost = mkOption {
        type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
        example = literalExpression ''
          {
            hostName = "mediawiki.example.org";
            adminAddr = "webmaster@example.org";
            forceSSL = true;
            enableACME = true;
          }
        '';
        description = ''
          Apache configuration can be done by adapting {option}`services.httpd.virtualHosts`.
          See [](#opt-services.httpd.virtualHosts) for further information.
        '';
      };

      poolConfig = mkOption {
        type = with types; attrsOf (oneOf [ str int bool ]);
        default = {
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
        };
        description = ''
          Options for the MediaWiki PHP pool. See the documentation on `php-fpm.conf`
          for details on configuration directives.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        description = ''
          Any additional text to be appended to MediaWiki's
          LocalSettings.php configuration file. For configuration
          settings, see <https://www.mediawiki.org/wiki/Manual:Configuration_settings>.
        '';
        default = "";
        example = ''
          $wgEnableEmail = false;
        '';
      };

    };
  };

  imports = [
    (lib.mkRenamedOptionModule [ "services" "mediawiki" "virtualHost" ] [ "services" "mediawiki" "httpd" "virtualHost" ])
  ];

  # implementation
  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.createLocally -> (cfg.database.type == "mysql" || cfg.database.type == "postgres");
        message = "services.mediawiki.createLocally is currently only supported for database type 'mysql' and 'postgres'";
      }
      { assertion = cfg.database.createLocally -> cfg.database.user == user && cfg.database.name == cfg.database.user;
        message = "services.mediawiki.database.user must be set to ${user} if services.mediawiki.database.createLocally is set true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.socket != null;
        message = "services.mediawiki.database.socket must be set if services.mediawiki.database.createLocally is set to true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.mediawiki.database.createLocally is set to true";
      }
    ];

    services.mediawiki.skins = {
      MonoBook = "${cfg.package}/share/mediawiki/skins/MonoBook";
      Timeless = "${cfg.package}/share/mediawiki/skins/Timeless";
      Vector = "${cfg.package}/share/mediawiki/skins/Vector";
    };

    services.mysql = mkIf (cfg.database.type == "mysql" && cfg.database.createLocally) {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
      }];
    };

    services.postgresql = mkIf (cfg.database.type == "postgres" && cfg.database.createLocally) {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [{
        name = cfg.database.user;
        ensureDBOwnership = true;
      }];
    };

    services.phpfpm.pools.mediawiki = {
      inherit user group;
      phpEnv.MEDIAWIKI_CONFIG = "${mediawikiConfig}";
      phpPackage = php;
      settings = (if (cfg.webserver == "apache") then {
        "listen.owner" = config.services.httpd.user;
        "listen.group" = config.services.httpd.group;
      } else if (cfg.webserver == "nginx") then {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
      } else {
        "listen.owner" = user;
        "listen.group" = group;
      }) // cfg.poolConfig;
    };

    services.httpd = lib.mkIf (cfg.webserver == "apache") {
      enable = true;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts.${cfg.httpd.virtualHost.hostName} = mkMerge [
        cfg.httpd.virtualHost
        {
          documentRoot = mkForce "${pkg}/share/mediawiki";
          extraConfig = ''
            <Directory "${pkg}/share/mediawiki">
              <FilesMatch "\.php$">
                <If "-f %{REQUEST_FILENAME}">
                  SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
                </If>
              </FilesMatch>

              Require all granted
              DirectoryIndex index.php
              AllowOverride All
            </Directory>
          '' + optionalString (cfg.uploadsDir != null) ''
            Alias "/images" "${cfg.uploadsDir}"
            <Directory "${cfg.uploadsDir}">
              Require all granted
            </Directory>
          '';
        }
      ];
    };
    # inspired by https://www.mediawiki.org/wiki/Manual:Short_URL/Nginx
    services.nginx = lib.mkIf (cfg.webserver == "nginx") {
      enable = true;
      virtualHosts.${config.services.mediawiki.nginx.hostName} = {
        root = "${pkg}/share/mediawiki";
        locations = {
          "~ ^/w/(index|load|api|thumb|opensearch_desc|rest|img_auth)\\.php$".extraConfig = ''
            rewrite ^/w/(.*) /$1 break;
            include ${config.services.nginx.package}/conf/fastcgi.conf;
            fastcgi_index index.php;
            fastcgi_pass unix:${config.services.phpfpm.pools.mediawiki.socket};
          '';
          "/w/images/".alias = withTrailingSlash cfg.uploadsDir;
          # Deny access to deleted images folder
          "/w/images/deleted".extraConfig = ''
            deny all;
          '';
          # MediaWiki assets (usually images)
          "~ ^/w/resources/(assets|lib|src)".extraConfig = ''
            rewrite ^/w(/.*) $1 break;
            add_header Cache-Control "public";
            expires 7d;
          '';
          # Assets, scripts and styles from skins and extensions
          "~ ^/w/(skins|extensions)/.+\\.(css|js|gif|jpg|jpeg|png|svg|wasm|ttf|woff|woff2)$".extraConfig = ''
            rewrite ^/w(/.*) $1 break;
            add_header Cache-Control "public";
            expires 7d;
          '';

          # Handling for Mediawiki REST API, see [[mw:API:REST_API]]
          "/w/rest.php/".tryFiles = "$uri $uri/ /w/rest.php?$query_string";

          # Handling for the article path (pretty URLs)
          "/wiki/".extraConfig = ''
            rewrite ^/wiki/(?<pagename>.*)$ /w/index.php;
          '';

          # Explicit access to the root website, redirect to main page (adapt as needed)
          "= /".extraConfig = ''
            return 301 /wiki/;
          '';

          # Every other entry point will be disallowed.
          # Add specific rules for other entry points/images as needed above this
          "/".extraConfig = ''
             return 404;
          '';
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d '${stateDir}' 0750 ${user} ${group} - -"
      "d '${cacheDir}' 0750 ${user} ${group} - -"
    ] ++ optionals (cfg.uploadsDir != null) [
      "d '${cfg.uploadsDir}' 0750 ${user} ${group} - -"
      "Z '${cfg.uploadsDir}' 0750 ${user} ${group} - -"
    ];

    systemd.services.mediawiki-init = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-mediawiki.service" ];
      after = optional (cfg.database.type == "mysql" && cfg.database.createLocally) "mysql.service"
              ++ optional (cfg.database.type == "postgres" && cfg.database.createLocally) "postgresql.service";
      script = ''
        if ! test -e "${stateDir}/secret.key"; then
          tr -dc A-Za-z0-9 </dev/urandom 2>/dev/null | head -c 64 > ${stateDir}/secret.key
        fi

        echo "exit( wfGetDB( DB_MASTER )->tableExists( 'user' ) ? 1 : 0 );" | \
        ${php}/bin/php ${pkg}/share/mediawiki/maintenance/eval.php --conf ${mediawikiConfig} && \
        ${php}/bin/php ${pkg}/share/mediawiki/maintenance/install.php \
          --confpath /tmp \
          --scriptpath / \
          --dbserver ${lib.escapeShellArg dbAddr} \
          --dbport ${toString cfg.database.port} \
          --dbname ${lib.escapeShellArg cfg.database.name} \
          ${optionalString (cfg.database.tablePrefix != null) "--dbprefix ${lib.escapeShellArg cfg.database.tablePrefix}"} \
          --dbuser ${lib.escapeShellArg cfg.database.user} \
          ${optionalString (cfg.database.passwordFile != null) "--dbpassfile ${lib.escapeShellArg cfg.database.passwordFile}"} \
          --passfile ${lib.escapeShellArg cfg.passwordFile} \
          --dbtype ${cfg.database.type} \
          ${lib.escapeShellArg cfg.name} \
          admin

        ${php}/bin/php ${pkg}/share/mediawiki/maintenance/update.php --conf ${mediawikiConfig} --quick
      '';

      serviceConfig = {
        Type = "oneshot";
        User = user;
        Group = group;
        PrivateTmp = true;
      };
    };

    systemd.services.httpd.after = optional (cfg.webserver == "apache" && cfg.database.createLocally && cfg.database.type == "mysql") "mysql.service"
      ++ optional (cfg.webserver == "apache" && cfg.database.createLocally && cfg.database.type == "postgres") "postgresql.service";

    users.users.${user} = {
      inherit group;
      isSystemUser = true;
    };
    users.groups.${group} = {};

    environment.systemPackages = [ mediawikiScripts ];
  };
}
