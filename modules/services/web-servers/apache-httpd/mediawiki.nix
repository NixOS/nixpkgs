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

        $wgDebugLogFile = "/tmp/mediawiki_debug_log.txt";

        # Database configuration.
        $wgDBtype = "postgres";
        $wgDBserver = "";
        $wgDBuser = "wwwrun";
        $wgDBname = "mediawiki";

        $wgEmergencyContact = "${serverInfo.serverConfig.adminAddr}";
        $wgPasswordSender = $wgEmergencyContact;
      ?>
    '';

  # Unpack Mediawiki and put the config file in its root directory.
  mediawikiRoot = pkgs.stdenv.mkDerivation rec {
    name= "mediawiki-1.15.1";
    
    src = pkgs.fetchurl {
      url = "http://download.wikimedia.org/mediawiki/1.15/${name}.tar.gz";
      sha256 = "0i6sb6p4ng38i8s3az42j6wnw6fpxvv3l9cvraav6wsn2cdj4jh4";
    };

    buildPhase = "true";

    installPhase =
      ''
        ensureDir $out
        cp -r * $out
        cp ${mediawikiConfig} $out/LocalSettings.php
      '';
  };
  
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
    '';

  options = {

    /*
    dbName = mkOption {
      example = "wikidb";
      default = "wikidb";
      description = "
        Name of the wiki database that holds MediaWiki data.
      ";
    };
    
    dbEmergencyContact = mkOption {
      example = "admin@example.com";
      default = "e.dolstra@tudelft.nl";
      description = "
	In case of emergency, contact this e-mail.
      ";
    };
    
    dbPasswordSender = mkOption {
      example = "passwordrecovery@example.com";
      default = "e.dolstra@tudelft.nl";
      description = "
	From which e-mail the recovery password for database users will be sent
      ";
    };

    dbType = mkOption {
      example = "mysql";
      default = "mysql";
      description = "
	Which type of database should be used
      ";
    };

    dbServer = mkOption {
      example = "10.0.2.2";
      default = "10.0.2.2";
      description = "
	The location of the database server, e.g. localhost or remote ip address.
      ";
    };

    dbPortNumber = mkOption {
      example = "3306";
      default = "3306";
      description = "
	Portnumber used to connect to the database server. Default: 3306.
      ";
    };

    dbUser = mkOption {
      example = "root";
      default = "root";
      description = "
	The username for accessing the database.
      ";
    };
    
    dbPassword = mkOption {
      example = "foobar";
      default = "";
      description = "
	The dbUser's password.
      ";
    };
    
    dbSiteName = mkOption {
      example = "wikipedia";
      default = "wiki";
      description = "
	Name of the wiki site.
      ";
    };
    */

    urlPrefix = mkOption {
      example = "/wiki";
      default = "/wiki";
      description = ''
        The URL prefix under which the Mediawiki service appears.
      '';
    };

  };

  startupScript = pkgs.writeScript "mediawiki_startup.sh"
    ''
      if ! ${pkgs.postgresql}/bin/psql -l | grep -q ' mediawiki ' ; then
          ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole wwwrun || true
          ${pkgs.postgresql}/bin/createdb mediawiki -O wwwrun
          ${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} wwwrun -c "(echo 'CREATE LANGUAGE plpgsql;'; cat /nix/store/q9gdf3f4362yhsdi8inlhpk26d9b8af6-mediawiki-1.15.1/maintenance/postgres/tables.sql; echo 'CREATE TEXT SEARCH CONFIGURATION public.default ( COPY = pg_catalog.english );'; echo COMMIT) | ${pkgs.postgresql}/bin/psql mediawiki"
      fi
    '';
}
