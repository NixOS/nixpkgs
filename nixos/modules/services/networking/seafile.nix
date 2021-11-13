{ config, lib, pkgs, ... }:
with lib;
let
  python = pkgs.python3Packages.python;
  cfg = config.services.seafile;
  settingsFormat = pkgs.formats.ini { };

  ccnetConf = settingsFormat.generate "ccnet.conf" cfg.ccnetSettings;

  seafileConf = settingsFormat.generate "seafile.conf" cfg.seafileSettings;

  seahubSettings = pkgs.writeText "seahub_settings.py" ''
    FILE_SERVER_ROOT = '${cfg.ccnetSettings.General.SERVICE_URL}/seafhttp'
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': '${seahubDir}/seahub.db',
        }
    }
    MEDIA_ROOT = '${seahubDir}/media/'
    THUMBNAIL_ROOT = '${seahubDir}/thumbnail/'

    with open('${seafRoot}/.seahubSecret') as f:
        SECRET_KEY = f.readline().rstrip()

    ${cfg.seahubExtraConf}
  '';

  seafRoot = "/var/lib/seafile"; # hardcode it due to dynamicuser
  ccnetDir = "${seafRoot}/ccnet";
  dataDir = "${seafRoot}/data";
  seahubDir = "${seafRoot}/seahub";

in {

  ###### Interface

  options.services.seafile = {
    enable = mkEnableOption "Seafile server";

    ccnetSettings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          General = {
            SERVICE_URL = mkOption {
              type = types.str;
              example = "https://www.example.com";
              description = ''
                Seahub public URL.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        Configuration for ccnet, see
        <link xlink:href="https://manual.seafile.com/config/ccnet-conf/"/>
        for supported values.
      '';
    };

    seafileSettings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          fileserver = {
            port = mkOption {
              type = types.port;
              default = 8082;
              description = ''
                The tcp port used by seafile fileserver.
              '';
            };
            host = mkOption {
              type = types.str;
              default = "127.0.0.1";
              example = "0.0.0.0";
              description = ''
                The binding address used by seafile fileserver.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        Configuration for seafile-server, see
        <link xlink:href="https://manual.seafile.com/config/seafile-conf/"/>
        for supported values.
      '';
    };

    workers = mkOption {
      type = types.int;
      default = 4;
      example = 10;
      description = ''
        The number of gunicorn worker processes for handling requests.
      '';
    };

    adminEmail = mkOption {
      example = "john@example.com";
      type = types.str;
      description = ''
        Seafile Seahub Admin Account Email.
      '';
    };

    initialAdminPassword = mkOption {
      example = "someStrongPass";
      type = types.str;
      description = ''
        Seafile Seahub Admin Account initial password.
        Should be change via Seahub web front-end.
      '';
    };

    seafilePackage = mkOption {
      type = types.package;
      description = "Which package to use for the seafile server.";
      default = pkgs.seafile-server;
    };

    seahubExtraConf = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Extra config to append to `seahub_settings.py` file.
        Refer to <link xlink:href="https://manual.seafile.com/config/seahub_settings_py/" />
        for all available options.
      '';
    };
  };

  ###### Implementation

  config = mkIf cfg.enable {

    environment.etc."seafile/ccnet.conf".source = ccnetConf;
    environment.etc."seafile/seafile.conf".source = seafileConf;
    environment.etc."seafile/seahub_settings.py".source = seahubSettings;

    systemd.targets.seafile = {
      wantedBy = [ "multi-user.target" ];
      description = "Seafile components";
    };

    systemd.services = let
      securityOptions = {
        ProtectHome = true;
        PrivateUsers = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" ];
      };
    in {
      seaf-server = {
        description = "Seafile server";
        partOf = [ "seafile.target" ];
        after = [ "network.target" ];
        wantedBy = [ "seafile.target" ];
        restartTriggers = [ ccnetConf seafileConf ];
        serviceConfig = securityOptions // {
          User = "seafile";
          Group = "seafile";
          DynamicUser = true;
          StateDirectory = "seafile";
          RuntimeDirectory = "seafile";
          LogsDirectory = "seafile";
          ConfigurationDirectory = "seafile";
          ExecStart = ''
            ${cfg.seafilePackage}/bin/seaf-server \
            --foreground \
            -F /etc/seafile \
            -c ${ccnetDir} \
            -d ${dataDir} \
            -l /var/log/seafile/server.log \
            -P /run/seafile/server.pid \
            -p /run/seafile
          '';
        };
        preStart = ''
          if [ ! -f "${seafRoot}/server-setup" ]; then
              mkdir -p ${dataDir}/library-template
              mkdir -p ${ccnetDir}/{GroupMgr,misc,OrgMgr,PeerMgr}
              ${pkgs.sqlite}/bin/sqlite3 ${ccnetDir}/GroupMgr/groupmgr.db ".read ${cfg.seafilePackage}/share/seafile/sql/sqlite/groupmgr.sql"
              ${pkgs.sqlite}/bin/sqlite3 ${ccnetDir}/misc/config.db ".read ${cfg.seafilePackage}/share/seafile/sql/sqlite/config.sql"
              ${pkgs.sqlite}/bin/sqlite3 ${ccnetDir}/OrgMgr/orgmgr.db ".read ${cfg.seafilePackage}/share/seafile/sql/sqlite/org.sql"
              ${pkgs.sqlite}/bin/sqlite3 ${ccnetDir}/PeerMgr/usermgr.db ".read ${cfg.seafilePackage}/share/seafile/sql/sqlite/user.sql"
              ${pkgs.sqlite}/bin/sqlite3 ${dataDir}/seafile.db ".read ${cfg.seafilePackage}/share/seafile/sql/sqlite/seafile.sql"
              echo "${cfg.seafilePackage.version}-sqlite" > "${seafRoot}"/server-setup
          fi
          # checking for upgrades and handling them
          # WARNING: needs to be extended to actually handle major version migrations
          installedMajor=$(cat "${seafRoot}/server-setup" | cut -d"-" -f1 | cut -d"." -f1)
          installedMinor=$(cat "${seafRoot}/server-setup" | cut -d"-" -f1 | cut -d"." -f2)
          pkgMajor=$(echo "${cfg.seafilePackage.version}" | cut -d"." -f1)
          pkgMinor=$(echo "${cfg.seafilePackage.version}" | cut -d"." -f2)
          if [ $installedMajor != $pkgMajor ] || [ $installedMinor != $pkgMinor ]; then
              echo "Unsupported upgrade" >&2
              exit 1
          fi
        '';
      };

      seahub = let
        penv = (pkgs.python3.withPackages (ps: with ps; [ gunicorn seahub ]));
      in {
        description = "Seafile Server Web Frontend";
        wantedBy = [ "seafile.target" ];
        partOf = [ "seafile.target" ];
        after = [ "network.target" "seaf-server.service" ];
        requires = [ "seaf-server.service" ];
        restartTriggers = [ seahubSettings ];
        environment = {
          PYTHONPATH =
            "${pkgs.python3Packages.seahub}/thirdpart:${pkgs.python3Packages.seahub}:${penv}/${python.sitePackages}";
          DJANGO_SETTINGS_MODULE = "seahub.settings";
          CCNET_CONF_DIR = ccnetDir;
          SEAFILE_CONF_DIR = dataDir;
          SEAFILE_CENTRAL_CONF_DIR = "/etc/seafile";
          SEAFILE_RPC_PIPE_PATH = "/run/seafile";
          SEAHUB_LOG_DIR = "/var/log/seafile";
        };
        serviceConfig = securityOptions // {
          User = "seafile";
          Group = "seafile";
          DynamicUser = true;
          RuntimeDirectory = "seahub";
          StateDirectory = "seafile";
          LogsDirectory = "seafile";
          ConfigurationDirectory = "seafile";
          ExecStart = ''
            ${penv}/bin/gunicorn seahub.wsgi:application \
            --name seahub \
            --workers ${toString cfg.workers} \
            --log-level=info \
            --preload \
            --timeout=1200 \
            --limit-request-line=8190 \
            --bind unix:/run/seahub/gunicorn.sock
          '';
        };
        preStart = ''
          mkdir -p ${seahubDir}/media
          # Link all media except avatars
          for m in `find ${pkgs.python3Packages.seahub}/media/ -maxdepth 1 -not -name "avatars"`; do
            ln -sf $m ${seahubDir}/media/
          done
          if [ ! -e "${seafRoot}/.seahubSecret" ]; then
              ${penv}/bin/python ${pkgs.python3Packages.seahub}/tools/secret_key_generator.py > ${seafRoot}/.seahubSecret
              chmod 400 ${seafRoot}/.seahubSecret
          fi
          if [ ! -f "${seafRoot}/seahub-setup" ]; then
              # avatars directory should be writable
              install -D -t ${seahubDir}/media/avatars/ ${pkgs.python3Packages.seahub}/media/avatars/default.png
              install -D -t ${seahubDir}/media/avatars/groups ${pkgs.python3Packages.seahub}/media/avatars/groups/default.png
              # init database
              ${pkgs.python3Packages.seahub}/manage.py migrate
              # create admin account
              ${pkgs.expect}/bin/expect -c 'spawn ${pkgs.python3Packages.seahub}/manage.py createsuperuser --email=${cfg.adminEmail}; expect "Password: "; send "${cfg.initialAdminPassword}\r"; expect "Password (again): "; send "${cfg.initialAdminPassword}\r"; expect "Superuser created successfully."'
              echo "${pkgs.python3Packages.seahub.version}-sqlite" > "${seafRoot}/seahub-setup"
          fi
          if [ $(cat "${seafRoot}/seahub-setup" | cut -d"-" -f1) != "${pkgs.python3Packages.seahub.version}" ]; then
              # update database
              ${pkgs.python3Packages.seahub}/manage.py migrate
              echo "${pkgs.python3Packages.seahub.version}-sqlite" > "${seafRoot}/seahub-setup"
          fi
        '';
      };
    };
  };
}
