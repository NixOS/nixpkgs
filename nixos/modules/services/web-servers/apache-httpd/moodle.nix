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

  moodleConfig = pkgs.writeText "config.php"
    ''
      <?php
      unset($CFG);
      global $CFG;
      $CFG = new stdClass();
      $CFG->dbtype    = '${config.dbType}';
      $CFG->dblibrary = 'native';
      $CFG->dbhost    = '${config.dbHost}';
      $CFG->dbname    = '${config.dbName}';
      $CFG->dbuser    = '${config.dbUser}';
      $CFG->dbpass    = '${config.dbPassword}';
      $CFG->prefix    = '${config.dbPrefix}';
      $CFG->dboptions = array(
          'dbpersist' => false,
          'dbsocket'  => false,
          'dbport'    => "${config.dbPort}",
      );
      $CFG->wwwroot   = '${config.wwwRoot}';
      $CFG->dataroot  = '${config.dataRoot}';
      $CFG->directorypermissions = 02777;
      $CFG->admin = 'admin';
      ${optionalString (config.debug.noEmailEver == true) ''
        $CFG->noemailever = true;
      ''}

      ${config.extraConfig}
      require_once(dirname(__FILE__) . '/lib/setup.php'); // Do not edit
    '';
  # Unpack Moodle and put the config file in its root directory.
  moodleRoot = pkgs.stdenv.mkDerivation rec {
    name= "moodle-2.8.10";

    src = pkgs.fetchurl {
      url = "https://download.moodle.org/stable28/${name}.tgz";
      sha256 = "0c3r5081ipcwc9s6shakllnrkd589y2ln5z5m1q09l4h6a7cy4z2";
    };

    buildPhase =
      ''
      '';

    installPhase =
      ''
        mkdir -p $out
        cp -r * $out
        cp ${moodleConfig} $out/config.php
      '';
  };

in

{

  extraConfig =
  ''
    # this should be config.urlPrefix instead of /
    Alias / ${moodleRoot}/
    <Directory ${moodleRoot}>
      DirectoryIndex index.php
    </Directory>
  '';

  documentRoot = moodleRoot; # TODO: fix this, should be config.urlPrefix

  enablePHP = true;

  options = {

    id = mkOption {
      default = "main";
      description = ''
        A unique identifier necessary to keep multiple Moodle server
        instances on the same machine apart.
      '';
    };

    dbType = mkOption {
      default = "postgres";
      example = "mysql";
      description = "Database type.";
    };

    dbName = mkOption {
      default = "moodle";
      description = "Name of the database that holds the Moodle data.";
    };

    dbHost = mkOption {
      default = "localhost";
      example = "10.0.2.2";
      description = ''
        The location of the database server.
      '';
    };

    dbPort = mkOption {
      default = ""; # use the default port
      example = "12345";
      description = ''
        The port that is used to connect to the database server.
      '';
    };

    dbUser = mkOption {
      default = "moodle";
      description = "The user name for accessing the database.";
    };

    dbPassword = mkOption {
      default = "";
      example = "password";
      description = ''
        The password of the database user.  Warning: this is stored in
        cleartext in the Nix store!
      '';
    };

    dbPrefix = mkOption {
      default = "mdl_";
      example = "my_other_mdl_";
      description = ''
        A prefix for each table, if multiple moodles should run in a single database.
      '';
    };

    wwwRoot = mkOption {
      type = types.string;
      example = "http://my.machine.com/my-moodle";
      description = ''
        The full web address where moodle has been installed.
      '';
    };

    dataRoot = mkOption {
      default = "/var/lib/moodledata";
      example = "/var/lib/moodledata";
      description = ''
        The data directory for moodle. Needs to be writable!
      '';
      type = types.path;
      };


    extraConfig = mkOption {
      default = "";
      example =
        ''
        '';
      description = ''
        Any additional text to be appended to Moodle's
        configuration file.  This is a PHP script.
      '';
    };

    debug = {
      noEmailEver = mkOption {
        default = false;
	example = "true";
	description = ''
	  Set this to true to prevent Moodle from ever sending any email.
	'';
	};
    };
  };

  startupScript = pkgs.writeScript "moodle_startup.sh" ''
  echo "Checking for existence of ${config.dataRoot}"
  if [ ! -e "${config.dataRoot}" ]
  then
    mkdir -p "${config.dataRoot}"
    chown ${serverInfo.serverConfig.user}.${serverInfo.serverConfig.group} "${config.dataRoot}"
  fi
  '';

}
