{ config, lib, pkgs, serverInfo, php, ... }:

with lib;

let

  httpd = serverInfo.serverConfig.package;

  version24 = !versionOlder httpd.version "2.4";

  allGranted = if version24 then ''
    Require all granted
  '' else ''
    Order allow,deny
    Allow from all
  '';

  mediawikiConfig = pkgs.writeText "LocalSettings.php"
    ''
      <?php
        # Copied verbatim from the default (generated) LocalSettings.php.
        if( defined( 'MW_INSTALL_PATH' ) ) {
                $IP = MW_INSTALL_PATH;
        } else {
                $IP = dirname( __FILE__ );
        }

        $path = array( $IP, "$IP/includes", "$IP/languages" );
        set_include_path( implode( PATH_SEPARATOR, $path ) . PATH_SEPARATOR . get_include_path() );

        require_once( "$IP/includes/DefaultSettings.php" );

        if ( $wgCommandLineMode ) {
                if ( isset( $_SERVER ) && array_key_exists( 'REQUEST_METHOD', $_SERVER ) ) {
                        die( "This script must be run from the command line\n" );
                }
        }

        $wgScriptPath = "${config.urlPrefix}";

        # We probably need to set $wgSecretKey and $wgCacheEpoch.

        # Paths to external programs.
        $wgDiff3 = "${pkgs.diffutils}/bin/diff3";
        $wgDiff = "${pkgs.diffutils}/bin/diff";
        $wgImageMagickConvertCommand = "${pkgs.imagemagick}/bin/convert";

        #$wgDebugLogFile = "/tmp/mediawiki_debug_log.txt";

        # Database configuration.
        $wgDBtype = "${config.dbType}";
        $wgDBserver = "${config.dbServer}";
        $wgDBuser = "${config.dbUser}";
        $wgDBpassword = "${config.dbPassword}";
        $wgDBname = "${config.dbName}";

        # E-mail.
        $wgEmergencyContact = "${config.emergencyContact}";
        $wgPasswordSender = "${config.passwordSender}";

        $wgSitename = "${config.siteName}";

        ${optionalString (config.logo != "") ''
          $wgLogo = "${config.logo}";
        ''}

        ${optionalString (config.articleUrlPrefix != "") ''
          $wgArticlePath = "${config.articleUrlPrefix}/$1";
        ''}

        ${optionalString config.enableUploads ''
          $wgEnableUploads = true;
          $wgUploadDirectory = "${config.uploadDir}";
        ''}

        ${optionalString (config.defaultSkin != "") ''
          $wgDefaultSkin = "${config.defaultSkin}";
        ''}

        ${config.extraConfig}
      ?>
    '';

  # Unpack Mediawiki and put the config file in its root directory.
  mediawikiRoot = pkgs.stdenv.mkDerivation rec {
    name= "mediawiki-1.23.13";

    src = pkgs.fetchurl {
      url = "http://download.wikimedia.org/mediawiki/1.23/${name}.tar.gz";
      sha256 = "168wpf53n4ksj2g5q5r0hxapx6238dvsfng5ff9ixk6axsn0j5d0";
    };

    skins = config.skins;

    buildPhase =
      ''
        for skin in $skins; do
          cp -prvd $skin/* skins/
        done
      ''; # */

    installPhase =
      ''
        mkdir -p $out
        cp -r * $out
        cp ${mediawikiConfig} $out/LocalSettings.php
        sed -i \
        -e 's|/bin/bash|${pkgs.bash}/bin/bash|g' \
        -e 's|/usr/bin/timeout|${pkgs.coreutils}/bin/timeout|g' \
          $out/includes/limit.sh \
          $out/includes/GlobalFunctions.php
      '';
  };

  mediawikiScripts = pkgs.runCommand "mediawiki-${config.id}-scripts"
    { buildInputs = [ pkgs.makeWrapper ]; }
    ''
      mkdir -p $out/bin
      for i in changePassword.php createAndPromote.php userOptions.php edit.php nukePage.php update.php; do
        makeWrapper ${php}/bin/php $out/bin/mediawiki-${config.id}-$(basename $i .php) \
          --add-flags ${mediawikiRoot}/maintenance/$i
      done
    '';

in

{

  extraConfig =
    ''
      ${optionalString config.enableUploads ''
        Alias ${config.urlPrefix}/images ${config.uploadDir}

        <Directory ${config.uploadDir}>
            ${allGranted}
            Options -Indexes
        </Directory>
      ''}

      ${if config.urlPrefix != "" then "Alias ${config.urlPrefix} ${mediawikiRoot}" else ''
        RewriteEngine On
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
        ${concatMapStringsSep "\n" (u: "RewriteCond %{REQUEST_URI} !^${u.urlPath}") serverInfo.vhostConfig.servedDirs}
        ${concatMapStringsSep "\n" (u: "RewriteCond %{REQUEST_URI} !^${u.urlPath}") serverInfo.vhostConfig.servedFiles}
        RewriteRule ${if config.enableUploads
          then "!^/images"
          else "^.*\$"
        } %{DOCUMENT_ROOT}/${if config.articleUrlPrefix == ""
          then ""
          else "${config.articleUrlPrefix}/"
        }index.php [L]
      ''}

      <Directory ${mediawikiRoot}>
          ${allGranted}
          DirectoryIndex index.php
      </Directory>

      ${optionalString (config.articleUrlPrefix != "") ''
        Alias ${config.articleUrlPrefix} ${mediawikiRoot}/index.php
      ''}
    '';

  documentRoot = if config.urlPrefix == "" then mediawikiRoot else null;

  enablePHP = true;

  options = {

    id = mkOption {
      default = "main";
      description = ''
        A unique identifier necessary to keep multiple MediaWiki server
        instances on the same machine apart.  This is used to
        disambiguate the administrative scripts, which get names like
        mediawiki-$id-change-password.
      '';
    };

    dbType = mkOption {
      default = "postgres";
      example = "mysql";
      description = "Database type.";
    };

    dbName = mkOption {
      default = "mediawiki";
      description = "Name of the database that holds the MediaWiki data.";
    };

    dbServer = mkOption {
      default = ""; # use a Unix domain socket
      example = "10.0.2.2";
      description = ''
        The location of the database server.  Leave empty to use a
        database server running on the same machine through a Unix
        domain socket.
      '';
    };

    dbUser = mkOption {
      default = "mediawiki";
      description = "The user name for accessing the database.";
    };

    dbPassword = mkOption {
      default = "";
      example = "foobar";
      description = ''
        The password of the database user.  Warning: this is stored in
        cleartext in the Nix store!
      '';
    };

    emergencyContact = mkOption {
      default = serverInfo.serverConfig.adminAddr;
      example = "admin@example.com";
      description = ''
        Emergency contact e-mail address.  Defaults to the Apache
        admin address.
      '';
    };

    passwordSender = mkOption {
      default = serverInfo.serverConfig.adminAddr;
      example = "password@example.com";
      description = ''
        E-mail address from which password confirmations originate.
        Defaults to the Apache admin address.
      '';
    };

    siteName = mkOption {
      default = "MediaWiki";
      example = "Foobar Wiki";
      description = "Name of the wiki";
    };

    logo = mkOption {
      default = "";
      example = "/images/logo.png";
      description = "The URL of the site's logo (which should be a 135x135px image).";
    };

    urlPrefix = mkOption {
      default = "/w";
      description = ''
        The URL prefix under which the Mediawiki service appears.
      '';
    };

    articleUrlPrefix = mkOption {
      default = "/wiki";
      example = "";
      description = ''
        The URL prefix under which article pages appear,
        e.g. http://server/wiki/Page.  Leave empty to use the main URL
        prefix, e.g. http://server/w/index.php?title=Page.
      '';
    };

    enableUploads = mkOption {
      default = false;
      description = "Whether to enable file uploads.";
    };

    uploadDir = mkOption {
      default = throw "You must specify `uploadDir'.";
      example = "/data/mediawiki-upload";
      description = "The directory that stores uploaded files.";
    };

    defaultSkin = mkOption {
      default = "";
      example = "nostalgia";
      description = "Set this value to change the default skin used by MediaWiki.";
    };

    skins = mkOption {
      default = [];
      type = types.listOf types.path;
      description =
        ''
          List of paths whose content is copied to the ‘skins’
          subdirectory of the MediaWiki installation.
        '';
    };

    extraConfig = mkOption {
      default = "";
      example =
        ''
          $wgEnableEmail = false;
        '';
      description = ''
        Any additional text to be appended to MediaWiki's
        configuration file.  This is a PHP script.  For configuration
        settings, see <link xlink:href='http://www.mediawiki.org/wiki/Manual:Configuration_settings'/>.
      '';
    };

  };

  extraPath = [ mediawikiScripts ];

  # !!! Need to specify that Apache has a dependency on PostgreSQL!

  startupScript = pkgs.writeScript "mediawiki_startup.sh"
    # Initialise the database automagically if we're using a Postgres
    # server on localhost.
    (optionalString (config.dbType == "postgres" && config.dbServer == "") ''
      if ! ${pkgs.postgresql}/bin/psql -l | grep -q ' ${config.dbName} ' ; then
          ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole "${config.dbUser}" || true
          ${pkgs.postgresql}/bin/createdb "${config.dbName}" -O "${config.dbUser}"
          ( echo 'CREATE LANGUAGE plpgsql;'
            cat ${mediawikiRoot}/maintenance/postgres/tables.sql
            echo 'CREATE TEXT SEARCH CONFIGURATION public.default ( COPY = pg_catalog.english );'
            echo COMMIT
          ) | ${pkgs.postgresql}/bin/psql -U "${config.dbUser}" "${config.dbName}"
      fi
      ${php}/bin/php ${mediawikiRoot}/maintenance/update.php
    '');

  robotsEntries = optionalString (config.articleUrlPrefix != "")
    ''
      User-agent: *
      Disallow: ${config.urlPrefix}/
      Disallow: ${config.articleUrlPrefix}/Special:Search
      Disallow: ${config.articleUrlPrefix}/Special:Random
    '';

}
