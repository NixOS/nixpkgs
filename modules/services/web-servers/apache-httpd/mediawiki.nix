{ config, pkgs, serverInfo, ... }:

with pkgs.lib;

let

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

        ${config.extraConfig}
      ?>
    '';

  # Unpack Mediawiki and put the config file in its root directory.
  mediawikiRoot = pkgs.stdenv.mkDerivation rec {
    name= "mediawiki-1.15.4";
    
    src = pkgs.fetchurl {
      url = "http://download.wikimedia.org/mediawiki/1.15/${name}.tar.gz";
      sha256 = "1blf79lhnaxixc8z96f9z4xi2jlg906ps3kd4x8b9ipg2dgl3vy9";
    };

    buildPhase = "true";

    installPhase =
      ''
        ensureDir $out
        cp -r * $out
        cp ${mediawikiConfig} $out/LocalSettings.php
      '';
  };

  mediawikiScripts = pkgs.runCommand "mediawiki-${config.id}-scripts"
    { buildInputs = [ pkgs.makeWrapper ]; }
    ''
      ensureDir $out/bin
      for i in changePassword.php createAndPromote.php userOptions.php edit.php nukePage.php; do
        makeWrapper ${pkgs.php}/bin/php $out/bin/mediawiki-${config.id}-$(basename $i .php) \
          --add-flags ${mediawikiRoot}/maintenance/$i
      done
    '';
  
in

{

  extraConfig =
    ''
      Alias ${config.urlPrefix} ${mediawikiRoot}

      <Directory ${mediawikiRoot}>
          Order allow,deny
          Allow from all
          DirectoryIndex index.php
      </Directory>

      ${optionalString (config.articleUrlPrefix != "") ''
        Alias ${config.articleUrlPrefix} ${mediawikiRoot}/index.php
      ''}
    '';

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
    '');

  robotsEntries = optionalString (config.articleUrlPrefix != "")
    ''
      User-agent: *
      Disallow: ${config.urlPrefix}/
      Disallow: ${config.articleUrlPrefix}/Special:Search
      Disallow: ${config.articleUrlPrefix}/Special:Random
    '';

}
