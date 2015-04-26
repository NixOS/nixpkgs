{ config, lib, pkgs, serverInfo, php, ... }:

with lib;

let
  # https://wordpress.org/plugins/postgresql-for-wordpress/
  # Wordpress plugin 'postgresql-for-wordpress' installation example
  postgresqlForWordpressPlugin = pkgs.stdenv.mkDerivation {
    name = "postgresql-for-wordpress-plugin";
    # Download the theme from the wordpress site
    src = pkgs.fetchurl {
      url = https://downloads.wordpress.org/plugin/postgresql-for-wordpress.1.3.1.zip;
      sha256 = "f11a5d76af884c7bec2bc653ed5bd29d3ede9a8657bd67ab7824e329e5d809e8";
    };
    # We need unzip to build this package
    buildInputs = [ pkgs.unzip ];
    # Installing simply means copying all files to the output directory
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  # Our bare-bones wp-config.php file using the above settings
  wordpressConfig = pkgs.writeText "wp-config.php" ''
    <?php
    define('DB_NAME',     '${config.dbName}');
    define('DB_USER',     '${config.dbUser}');
    define('DB_PASSWORD', '${config.dbPassword}');
    define('DB_HOST',     '${config.dbHost}');
    define('DB_CHARSET',  'utf8');
    $table_prefix  = '${config.tablePrefix}';
    if ( !defined('ABSPATH') )
    	define('ABSPATH', dirname(__FILE__) . '/');
    require_once(ABSPATH . 'wp-settings.php');
    ${config.extraConfig}
  '';

  # .htaccess to support pretty URLs
  htaccess = pkgs.writeText "htaccess" ''
    <IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
    </IfModule>
  '';

  # The wordpress package itself
  wordpressRoot = pkgs.stdenv.mkDerivation rec {
    name = "wordpress";
    # Fetch directly from the wordpress site, want to upgrade?
    # Just change the version URL and update the hash
    src = pkgs.fetchurl {
      url = http://wordpress.org/wordpress-4.1.1.tar.gz;
      sha256 = "1s9y0i9ms3m6dswb9gqrr95plnx6imahc07fyhvrp5g35f6c12k1";
    };
    installPhase = ''
      mkdir -p $out
      # Copy all the wordpress files we downloaded
      cp -R * $out/
      # We'll symlink the wordpress config
      ln -s ${wordpressConfig} $out/wp-config.php
      # As well as our custom .htaccess
      ln -s ${htaccess} $out/.htaccess
      # And the uploads directory
      ln -s ${config.wordpressUploads} $out/wp-content/uploads
      # And the theme(s)
      ${concatMapStrings (theme: "ln -s ${theme} $out/wp-content/themes/${theme.name}\n") config.themes}
      # And the plugin(s)
      # remove bundled plugin(s) coming with wordpress
      rm -Rf $out/wp-content/plugins/akismet
      # install plugins
      ${concatMapStrings (plugin: "ln -s ${plugin} $out/wp-content/plugins/${plugin.name}\n") (config.plugins ++ [ postgresqlForWordpressPlugin]) }
    '';
  };

in

{

  # And some httpd extraConfig to make things work nicely
  extraConfig = ''
    <Directory ${wordpressRoot}>
      DirectoryIndex index.php
      Allow from *
      Options FollowSymLinks
      AllowOverride All
    </Directory>
  '';

  enablePHP = true;

  options = {
    dbHost = mkOption {
      default = "localhost";
      description = "The location of the database server.";  
      example = "localhost";
    };
    dbName = mkOption {
      default = "wordpress";
      description = "Name of the database that holds the Wordpress data.";
      example = "localhost";
    };
    dbUser = mkOption {
      default = "wordpress";
      description = "The dbUser, read the username, for the database.";
      example = "wordpress";
    };
    dbPassword = mkOption {
      default = "wordpress";
      description = "The password to the respective dbUser.";
      example = "wordpress";
    };
    tablePrefix = mkOption {
      default = "wp_";
      description = ''
        The $table_prefix is the value placed in the front of your database tables. Change the value if you want to use something other than wp_ for your database prefix. Typically this is changed if you are installing multiple WordPress blogs in the same database. See <link xlink:href='http://codex.wordpress.org/Editing_wp-config.php#table_prefix'/>.
      '';
    };
    wordpressUploads = mkOption {
    default = "/data/uploads";
      description = ''
        This directory is used for uploads of pictures and must be accessible (read: owned) by the httpd running user. The directory passed here is automatically created and permissions are given to the httpd running user.
      '';
    };
    plugins = mkOption {
      default = [];
      type = types.listOf types.path;
      description =
        ''
          List of path(s) to respective plugin(s) which are symlinked from the 'plugins' directory. Note: These plugins need to be packaged before use.
        '';
      example = ''
        # Wordpress plugin 'akismet' installation example
        akismetPlugin = pkgs.stdenv.mkDerivation {
          name = "akismet-plugin";
          # Download the theme from the wordpress site
          src = pkgs.fetchurl {
            url = https://downloads.wordpress.org/plugin/akismet.3.1.zip;
            sha256 = "1i4k7qyzna08822ncaz5l00wwxkwcdg4j9h3z2g0ay23q640pclg";
          };
          # We need unzip to build this package
          buildInputs = [ pkgs.unzip ];
          # Installing simply means copying all files to the output directory
          installPhase = "mkdir -p $out; cp -R * $out/";
        };

        And then pass this theme to the themes list like this:
          plugins = [ akismetPlugin ];
      '';
    };
    themes = mkOption {
      default = [];
      type = types.listOf types.path;
      description =
        ''
          List of path(s) to respective theme(s) which are symlinked from the 'theme' directory. Note: These themes need to be packaged before use.
        '';
      example = ''
        # For shits and giggles, let's package the responsive theme
        responsiveTheme = pkgs.stdenv.mkDerivation {
          name = "responsive-theme";
          # Download the theme from the wordpress site
          src = pkgs.fetchurl {
            url = http://wordpress.org/themes/download/responsive.1.9.7.6.zip;
            sha256 = "06i26xlc5kdnx903b1gfvnysx49fb4kh4pixn89qii3a30fgd8r8";
          };
          # We need unzip to build this package
          buildInputs = [ pkgs.unzip ];
          # Installing simply means copying all files to the output directory
          installPhase = "mkdir -p $out; cp -R * $out/";
        };

        And then pass this theme to the themes list like this:
          themes = [ responsiveTheme ];
      '';
    };
    extraConfig = mkOption {
      default = "";
      example =
        ''
          define( 'AUTOSAVE_INTERVAL', 60 ); // Seconds
        '';
      description = ''
        Any additional text to be appended to Wordpress's wp-config.php
        configuration file.  This is a PHP script.  For configuration
        settings, see <link xlink:href='http://codex.wordpress.org/Editing_wp-config.php'/>.
      '';
    };
  }; 

  documentRoot = wordpressRoot;

  startupScript = pkgs.writeScript "init-wordpress.sh" ''
    #!/bin/sh
    mkdir -p ${config.wordpressUploads}
    chown ${serverInfo.serverConfig.user} ${config.wordpressUploads}

    # we should use systemd dependencies here
    #waitForUnit("network-interfaces.target");
    if [ ! -d ${serverInfo.fullConfig.services.mysql.dataDir}/${config.dbName} ]; then
      # Wait until MySQL is up
      while [ ! -e /var/run/mysql/mysqld.pid ]; do
        sleep 1
      done
      ${pkgs.mysql}/bin/mysql -e 'CREATE DATABASE ${config.dbName};'
      ${pkgs.mysql}/bin/mysql -e 'GRANT ALL ON ${config.dbName}.* TO ${config.dbUser}@localhost IDENTIFIED BY "${config.dbPassword}";'
    fi
  '';
}
