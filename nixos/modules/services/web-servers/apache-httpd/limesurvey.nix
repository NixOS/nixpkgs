{ config, lib, pkgs, serverInfo, ... }:

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

  limesurveyConfig = pkgs.writeText "config.php" ''
    <?php
    $config = array();
    $config['name']  = "${config.siteName}";
    $config['runtimePath'] = "${config.dataDir}/tmp/runtime";
    $config['components'] = array();
    $config['components']['db'] = array();
    $config['components']['db']['connectionString'] = '${config.dbType}:host=${config.dbHost};port=${toString config.dbPort};user=${config.dbUser};password=${config.dbPassword};dbname=${config.dbName};';
    $config['components']['db']['username'] = '${config.dbUser}';
    $config['components']['db']['password'] = '${config.dbPassword}';
    $config['components']['db']['charset'] = 'utf-8';
    $config['components']['db']['tablePrefix'] = "prefix_";
    $config['components']['assetManager'] = array();
    $config['components']['assetManager']['basePath'] = '${config.dataDir}/tmp/assets';
    $config['config'] = array();
    $config['config']['debug'] = 1;
    $config['config']['tempdir']  = "${config.dataDir}/tmp";
    $config['config']['tempdir']  = "${config.dataDir}/tmp";
    $config['config']['uploaddir']  = "${config.dataDir}/upload";
    $config['config']['force_ssl'] = '${if config.forceSSL then "on" else ""}';
    $config['config']['defaultlang'] = '${config.defaultLang}';
    return $config;
    ?>
  '';

  limesurveyRoot = "${pkgs.limesurvey}/share/limesurvey/";

in rec {

  extraConfig = ''
    Alias ${config.urlPrefix}/tmp ${config.dataDir}/tmp

    <Directory ${config.dataDir}/tmp>
      ${allGranted}
      Options -Indexes +FollowSymlinks
    </Directory>

    Alias ${config.urlPrefix}/upload ${config.dataDir}/upload

    <Directory ${config.dataDir}/upload>
      ${allGranted}
      Options -Indexes
    </Directory>

    ${if config.urlPrefix != "" then ''
      Alias ${config.urlPrefix} ${limesurveyRoot}
    '' else ''
      RewriteEngine On
      RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
      RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
    ''}

    <Directory ${limesurveyRoot}>
      DirectoryIndex index.php
    </Directory>
  '';

  globalEnvVars = [
    { name = "LIMESURVEY_CONFIG"; value = limesurveyConfig; }
  ];

  documentRoot = if config.urlPrefix == "" then limesurveyRoot else null;

  enablePHP = true;

  options = {

    id = mkOption {
      default = "main";
      description = ''
        A unique identifier necessary to keep multiple Limesurvey server
        instances on the same machine apart.  This is used to
        disambiguate the administrative scripts, which get names like
        mediawiki-$id-change-password.
      '';
    };

    urlPrefix = mkOption {
      default = "";
      description = "Url prefix for site.";
      type = types.str;
    };

    dbType = mkOption {
      default = "pgsql";
      description = "Type of database for limesurvey, for now, only pgsql.";
      type = types.enum ["pgsql"];
    };

    dbName = mkOption {
      default = "limesurvey";
      description = "Name of the database that holds the limesurvey data.";
      type = types.str;
    };

    dbHost = mkOption {
      default = "localhost";
      description = "Limesurvey database host.";
      type = types.str;
    };

    dbPort = mkOption {
      default = 5432;
      description = "Limesurvey database port.";
      type = types.int;
    };

    dbUser = mkOption {
      default = "limesurvey";
      description = "Limesurvey database user.";
      type = types.str;
    };

    dbPassword = mkOption {
      example = "foobar";
      description = "Limesurvey database password.";
      type = types.str;
    };

    adminUser = mkOption {
      description = "Limesurvey admin username.";
      default = "admin";
      type = types.str;
    };

    adminPassword = mkOption {
      description = "Default limesurvey admin password.";
      default = "admin";
      type = types.str;
    };

    adminEmail = mkOption {
      description = "Limesurvey admin email.";
      default = "admin@admin.com";
      type = types.str;
    };

    forceSSL = mkOption {
      default = false;
      description = "Force use of HTTPS connection.";
      type = types.bool;
    };

    siteName = mkOption {
      default = "LimeSurvey";
      description = "LimeSurvey name of the site.";
      type = types.str;
    };

    defaultLang = mkOption {
      default = "en";
      description = "LimeSurvey default language.";
      type = types.str;
    };

    dataDir = mkOption {
      default = "/var/lib/limesurvey";
      description = "LimeSurvey data directory.";
      type = types.path;
    };
  };

  startupScript = pkgs.writeScript "limesurvey_startup.sh" ''
    if [ ! -f ${config.dataDir}/.created ]; then
      mkdir -p ${config.dataDir}/{tmp/runtime,tmp/assets,tmp/upload,upload}
      chmod -R ug+rw ${config.dataDir}
      chmod -R o-rwx ${config.dataDir}
      chown -R wwwrun:wwwrun ${config.dataDir}

      ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole "${config.dbUser}" || true
      ${pkgs.postgresql}/bin/createdb "${config.dbName}" -O "${config.dbUser}" || true
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/psql -U postgres -d postgres -c "alter user ${config.dbUser} with password '${config.dbPassword}';" || true

      ${pkgs.limesurvey}/bin/limesurvey-console install '${config.adminUser}' '${config.adminPassword}' '${config.adminUser}' '${config.adminEmail}'

      touch ${config.dataDir}/.created
    fi
  '';
}
