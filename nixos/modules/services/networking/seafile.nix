{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.seafile;

  seafileIni = pkgs.writeText "seafile.ini" ''
    ${seafileDataDir}
  '';

  seahubSettings = pkgs.writeText "seahub_settings.py" ''
    FILE_SERVER_ROOT = '${cfg.serviceUrl}/seafhttp'
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': '${seahubDir}/seahub.db',
        }
    }
    MEDIA_ROOT = '${seahubDir}/media/'
    THUMBNAIL_ROOT = '${seahubDir}/thumbnail/'
    ${cfg.seahubExtraConf}
  '';

  centralConfigDir = "${cfg.dataDir}/conf";
  ccnetDir = "${cfg.dataDir}/ccnet";
  seafileDataDir = "${cfg.dataDir}/seafile-data";
  seahubDir = "${cfg.dataDir}/seahub";
  runDir = "/run/seafile";
  logDir = "${cfg.dataDir}/log";

in {

  ###### Interface

  options.services.seafile = {
    enable = mkEnableOption ''
      Enable Seafile Server.

      For further information see [Seafile Manual](http://manual.seafile.com/).
      Current Configuration uses Sqlite Databases and should be run behind
      Nginx or Apache (fastcgi).
    '';

    serviceUrl = mkOption {
      type = types.string;
      example = "https://www.example.com";
      description = ''
        Outside URL for SeaHub.
      '';
    };

    serverName = mkOption {
      default = "Server";
      example = "My Seafile Server";
      type = types.string;
      description = ''
        The name of the server that would be shown on the client.
      '';
    };

    ccnetHost = mkOption {
      type = types.string;
      default = "127.0.0.1";
      description = ''
        The tcp address used by ccnet.
      '';
    };

    ccnetPort = mkOption {
      type = types.int;
      default = 10001;
      description = ''
        The tcp port used by ccnet.
      '';
    };

    seafilePort = mkOption {
      type = types.int;
      default = 12001;
      description = ''
        The tcp port used by seafile.
      '';
    };

    fileserverPort = mkOption {
      type = types.int;
      default = 8082;
      description = ''
        The tcp port used by seafile fileserver.
      '';
    };

    dataDir = mkOption {
      default = "/var/lib/seafile";
      type = types.path;
      description = ''
        The data directory used to store configuration, database and data.
      '';
    };

    adminEmail = mkOption {
      default = "admin@example.com";
      example = "john@example.com";
      type = types.string;
      description = ''
        Seafile Seahub Admin Account Email.
      '';
    };

    initialAdminPassword = mkOption {
      default = "seafile_password";
      example = "123456";
      type = types.string;
      description = ''
        Seafile Seahub Admin Account initial password.
        Should be change via Seahub web front-end.
      '';
    };

    seahubExtraConf = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Extra config to append to `seahub_settings.py` file.
      '';
    };
  };

  ###### Implementation

  config = mkIf cfg.enable {

    systemd.services.ccnet = {
      description = "Seafile ccnet Server";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "forking";
        User = "seafile";
        Group = "seafile";
        RuntimeDirectory = "seafile";
        ExecStart = "${pkgs.ccnet}/bin/ccnet-server -F ${centralConfigDir} -c ${ccnetDir} -f ${logDir}/ccnet.log -d -P ${runDir}/ccnet.pid";
        PIDFile = "${runDir}/ccnet.pid";
      };
      preStart = ''
        mkdir -p ${logDir}
        if [ ! -d "${ccnetDir}" ]; then
          ${pkgs.ccnet}/bin/ccnet-init -F ${centralConfigDir} -c ${ccnetDir} -n ${cfg.serverName} -H ${cfg.ccnetHost} -P ${toString cfg.ccnetPort}
          sed -i "s|^SERVICE_URL.*|SERVICE_URL = ${cfg.serviceUrl}|" ${centralConfigDir}/ccnet.conf
          ln -s ${seafileIni} ${ccnetDir}/seafile.ini
        fi
      '';
    };

    systemd.services.seafile = {
      description = "Seafile Server";
      after = [ "network.target" "ccnet.service" ];
      requires = [ "ccnet.service" ];
      serviceConfig = {
        Type = "forking";
        User = "seafile";
        Group = "seafile";
        RuntimeDirectory = "seafile";
        ExecStart = "${pkgs.seafile}/bin/seaf-server -F ${centralConfigDir} -c ${ccnetDir} -d ${seafileDataDir} -l ${logDir}/seafile.log -P ${runDir}/seafile.pid";
        PIDFile = "${runDir}/seafile.pid";
      };
      preStart = ''
        if [ ! -d "${seafileDataDir}" ]; then
          ${pkgs.seafile}/bin/seaf-server-init -F ${centralConfigDir} \
            --seafile-dir ${seafileDataDir} --port ${toString cfg.seafilePort} --fileserver-port ${toString cfg.fileserverPort}
        fi
      '';
    };

    systemd.services.seahub = {
      description = "Seafile Server Web Frontend";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "seafile.service" ];
      requires = [ "seafile.service" ];
      environment = {
        CCNET_CONF_DIR = ccnetDir;
        SEAFILE_CONF_DIR = seafileDataDir;
        SEAFILE_CENTRAL_CONF_DIR = centralConfigDir;
      };
      serviceConfig = {
        Type = "forking";
        User = "seafile";
        Group = "seafile";
        RuntimeDirectory = "seafile";
        WorkingDirectory = pkgs.seafile-seahub;
        ExecStart = "${pkgs.seafile-seahub}/manage.py runfcgi host=127.0.0.1 port=8000 pidfile=${runDir}/seahub.pid outlog=${logDir}/seahub_access.log errlog=${logDir}/seahub_error.log";
        PIDFile = "${runDir}/seahub.pid";
      };
      preStart = ''
        if [ ! -d "${seahubDir}" ]; then
            mkdir ${seahubDir}
            # copy seahub_settings and add SECRET_KEY
            cp ${seahubSettings} ${centralConfigDir}/seahub_settings.py
            chmod +w ${centralConfigDir}/seahub_settings.py
            echo -n "SECRET_KEY = '" >> ${centralConfigDir}/seahub_settings.py
            < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c40 >> ${centralConfigDir}/seahub_settings.py
            echo "'" >> ${centralConfigDir}/seahub_settings.py
            # link media into local seahubDir, for avatars
            mkdir -p ${seahubDir}/media
            for m in ${pkgs.seafile-seahub}/media/*/ ; do
              ln -s $m ${seahubDir}/media/
            done
            rm ${seahubDir}/media/avatars
            cp -rf ${pkgs.seafile-seahub}/media/avatars ${seahubDir}/media/
            # create admin account
            ${pkgs.expect}/bin/expect -c 'spawn ${pkgs.seafile-seahub}/manage.py createsuperuser --email=${cfg.adminEmail}; expect "Password: "; send "${cfg.initialAdminPassword}\r"; expect "Password (again): "; send "${cfg.initialAdminPassword}\r"; expect "Superuser created successfully."'
            # init database
            ${pkgs.seafile-seahub}/manage.py syncdb
        fi
      '';
    };

    users.extraUsers.seafile = {
      description = "Seafile server daemon owner";
      group = "seafile";
      uid = config.ids.uids.seafile;
      home = cfg.dataDir;
      createHome = true;
    };

    users.extraGroups.seafile.gid = config.ids.gids.seafile;

  };
}
