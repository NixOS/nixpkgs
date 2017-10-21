{ config, lib, pkgs, serverInfo, php, ... }:
# http://codex.wordpress.org/Hardening_WordPress

with lib;

let
  # Our bare-bones wp-config.php file using the above settings
  wordpressConfig = pkgs.writeText "wp-config.php" ''
    <?php
    define('DB_NAME',     '${config.dbName}');
    define('DB_USER',     '${config.dbUser}');
    define('DB_PASSWORD', file_get_contents('${config.dbPasswordFile}'));
    define('DB_HOST',     '${config.dbHost}');
    define('DB_CHARSET',  'utf8');
    $table_prefix  = '${config.tablePrefix}';
    ${config.extraConfig}
    if ( !defined('ABSPATH') )
    	define('ABSPATH', dirname(__FILE__) . '/');
    require_once(ABSPATH . 'wp-settings.php');
  '';

  # .htaccess to support pretty URLs
  htaccess = pkgs.writeText "htaccess" ''
    <IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\.php$ - [L]

    # add a trailing slash to /wp-admin
    RewriteRule ^wp-admin$ wp-admin/ [R=301,L]

    RewriteCond %{REQUEST_FILENAME} -f [OR]
    RewriteCond %{REQUEST_FILENAME} -d
    RewriteRule ^ - [L]
    RewriteRule ^(wp-(content|admin|includes).*) $1 [L]
    RewriteRule ^(.*\.php)$ $1 [L]
    RewriteRule . index.php [L]
    </IfModule>

    ${config.extraHtaccess}
  '';

  # WP translation can be found here:
  #   https://github.com/nixcloud/wordpress-translations
  supportedLanguages = {
    en_GB = { revision="d6c005372a5318fd758b710b77a800c86518be13"; sha256="0qbbsi87k47q4rgczxx541xz4z4f4fr49hw4lnaxkdsf5maz8p9p"; };
    de_DE = { revision="3c62955c27baaae98fd99feb35593d46562f4736"; sha256="1shndgd11dk836dakrjlg2arwv08vqx6j4xjh4jshvwmjab6ng6p"; };
    zh_ZN = { revision="12b9f811e8cae4b6ee41de343d35deb0a8fdda6d"; sha256="1339ggsxh0g6lab37jmfxicsax4h702rc3fsvv5azs7mcznvwh47"; };
    fr_FR = { revision="688c8b1543e3d38d9e8f57e0a6f2a2c3c8b588bd"; sha256="1j41iak0i6k7a4wzyav0yrllkdjjskvs45w53db8vfm8phq1n014"; };
  };

  downloadLanguagePack = language: revision: sha256s:
    pkgs.stdenv.mkDerivation rec {
      name = "wp_${language}";
      src = pkgs.fetchFromGitHub {
        owner = "nixcloud";
        repo = "wordpress-translations";
        rev = revision;
        sha256 = sha256s;
      };
      installPhase = "mkdir -p $out; cp -R * $out/";
    };

  selectedLanguages = map (lang: downloadLanguagePack lang supportedLanguages.${lang}.revision supportedLanguages.${lang}.sha256) (config.languages);

  # The wordpress package itself
  wordpressRoot = pkgs.stdenv.mkDerivation rec {
    name = "wordpress";
    src = config.package;
    installPhase = ''
      mkdir -p $out
      # copy all the wordpress files we downloaded
      cp -R * $out/

      # symlink the wordpress config
      ln -s ${wordpressConfig} $out/wp-config.php
      # symlink custom .htaccess
      ln -s ${htaccess} $out/.htaccess
      # symlink uploads directory
      ln -s ${config.wordpressUploads} $out/wp-content/uploads

      # remove bundled plugins(s) coming with wordpress
      rm -Rf $out/wp-content/plugins/*
      # remove bundled themes(s) coming with wordpress
      rm -Rf $out/wp-content/themes/*

      # symlink additional theme(s)
      ${concatMapStrings (theme: "ln -s ${theme} $out/wp-content/themes/${theme.name}\n") config.themes}
      # symlink additional plugin(s)
      ${concatMapStrings (plugin: "ln -s ${plugin} $out/wp-content/plugins/${plugin.name}\n") (config.plugins) }

      # symlink additional translation(s)
      mkdir -p $out/wp-content/languages
      ${concatMapStrings (language: "ln -s ${language}/*.mo ${language}/*.po $out/wp-content/languages/\n") (selectedLanguages) }
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
    package = mkOption {
      type = types.path;
      default = pkgs.wordpress;
      description = ''
        Path to the wordpress sources.
        Upgrading? We have a test! nix-build ./nixos/tests/wordpress.nix
      '';
    };
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
      description = "The dbUser, read: the username, for the database.";
      example = "wordpress";
    };
    dbPassword = mkOption {
      default = "wordpress";
      description = ''
        The mysql password to the respective dbUser.

        Warning: this password is stored in the world-readable Nix store. It's
        recommended to use the $dbPasswordFile option since that gives you control over
        the security of the password. $dbPasswordFile also takes precedence over $dbPassword.
      '';
      example = "wordpress";
    };
    dbPasswordFile = mkOption {
      type = types.str;
      default = toString (pkgs.writeTextFile {
        name = "wordpress-dbpassword";
        text = config.dbPassword;
      });
      example = "/run/keys/wordpress-dbpassword";
      description = ''
        Path to a file that contains the mysql password to the respective dbUser.
        The file should be readable by the user: config.services.httpd.user.

        $dbPasswordFile takes precedence over the $dbPassword option.

        This defaults to a file in the world-readable Nix store that contains the value
        of the $dbPassword option. It's recommended to override this with a path not in
        the Nix store. Tip: use nixops key management:
        <link xlink:href='https://nixos.org/nixops/manual/#idm140737318306400'/>
      '';
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
          List of path(s) to respective plugin(s) which are symlinked from the 'plugins' directory. Note: These plugins need to be packaged before use, see example.
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
          List of path(s) to respective theme(s) which are symlinked from the 'theme' directory. Note: These themes need to be packaged before use, see example.
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
    languages = mkOption {
          default = [];
          description = "Installs wordpress language packs based on the list, see wordpress.nix for possible translations.";
          example = "[ \"en_GB\" \"de_DE\" ];";
    };
    extraConfig = mkOption {
      type = types.lines;
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
    extraHtaccess = mkOption {
      default = "";
      example =
        ''
          php_value upload_max_filesize 20M
          php_value post_max_size 20M
        '';
      description = ''
        Any additional text to be appended to Wordpress's .htaccess file.
      '';
    };
  };

  documentRoot = wordpressRoot;

  # FIXME adding the user has to be done manually for the time being
  startupScript = pkgs.writeScript "init-wordpress.sh" ''
    #!/bin/sh
    mkdir -p ${config.wordpressUploads}
    chown ${serverInfo.serverConfig.user} ${config.wordpressUploads}

    # we should use systemd dependencies here
    if [ ! -d ${serverInfo.fullConfig.services.mysql.dataDir}/${config.dbName} ]; then
      echo "Need to create the database '${config.dbName}' and grant permissions to user named '${config.dbUser}'."
      # Wait until MySQL is up
      while [ ! -e ${serverInfo.fullConfig.services.mysql.pidDir}/mysqld.pid ]; do
        sleep 1
      done
      ${pkgs.mysql}/bin/mysql -e 'CREATE DATABASE ${config.dbName};'
      ${pkgs.mysql}/bin/mysql -e "GRANT ALL ON ${config.dbName}.* TO ${config.dbUser}@localhost IDENTIFIED BY \"$(cat ${config.dbPasswordFile})\";"
    else
      echo "Good, no need to do anything database related."
    fi
  '';
}
