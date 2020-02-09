{ config, lib, pkgs, ... }:

let
  cfg = config.services.zoneminder;
  fpm = config.services.phpfpm.pools.zoneminder;
  pkg = pkgs.zoneminder;

  dirName = pkg.dirName;

  user = "zoneminder";
  group = {
    nginx = config.services.nginx.group;
    none  = user;
  }.${cfg.webserver};

  useNginx = cfg.webserver == "nginx";

  defaultDir = "/var/lib/${user}";
  home = if useCustomDir then cfg.storageDir else defaultDir;

  useCustomDir = cfg.storageDir != null;

  zms = "/cgi-bin/zms";

  dirs = dirList: [ dirName ] ++ map (e: "${dirName}/${e}") dirList;

  cacheDirs = [ "swap" ];
  libDirs   = [ "events" "exports" "images" "sounds" ];

  dirStanzas = baseDir:
    lib.concatStringsSep "\n" (map (e:
      "ZM_DIR_${lib.toUpper e}=${baseDir}/${e}"
      ) libDirs);

  defaultsFile = pkgs.writeText "60-defaults.conf" ''
    # 01-system-paths.conf
    ${dirStanzas home}
    ZM_PATH_ARP=${lib.getBin pkgs.nettools}/bin/arp
    ZM_PATH_LOGS=/var/log/${dirName}
    ZM_PATH_MAP=/dev/shm
    ZM_PATH_SOCKS=/run/${dirName}
    ZM_PATH_SWAP=/var/cache/${dirName}/swap
    ZM_PATH_ZMS=${zms}

    # 02-multiserver.conf
    ZM_SERVER_HOST=

    # Database
    ZM_DB_TYPE=mysql
    ZM_DB_HOST=${cfg.database.host}
    ZM_DB_NAME=${cfg.database.name}
    ZM_DB_USER=${cfg.database.username}
    ZM_DB_PASS=${cfg.database.password}

    # Web
    ZM_WEB_USER=${user}
    ZM_WEB_GROUP=${group}
  '';

  configFile = pkgs.writeText "80-nixos.conf" ''
    # You can override defaults here

    ${cfg.extraConfig}
  '';

  phpExtensions = with pkgs.phpPackages; [
    { pkg = apcu; name = "apcu"; }
  ];

in {
  options = {
    services.zoneminder = with lib; {
      enable = lib.mkEnableOption ''
        ZoneMinder
        </para><para>
        If you intend to run the database locally, you should set
        `config.services.zoneminder.database.createLocally` to true. Otherwise,
        when set to `false` (the default), you will have to create the database
        and database user as well as populate the database yourself.
        Additionally, you will need to run `zmupdate.pl` yourself when
        upgrading to a newer version.
      '';

      webserver = mkOption {
        type = types.enum [ "nginx" "none" ];
        default = "nginx";
        description = ''
          The webserver to configure for the PHP frontend.
          </para>
          <para>

          Set it to `none` if you want to configure it yourself. PRs are welcome
          for support for other web servers.
        '';
      };

      hostname = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          The hostname on which to listen.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 8095;
        description = ''
          The port on which to listen.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open the firewall port(s).
        '';
      };

      database = {
        createLocally = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Create the database and database user locally.
          '';
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            Hostname hosting the database.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "zm";
          description = ''
            Name of database.
          '';
        };

        username = mkOption {
          type = types.str;
          default = "zmuser";
          description = ''
            Username for accessing the database.
          '';
        };

        password = mkOption {
          type = types.str;
          default = "zmpass";
          description = ''
            Username for accessing the database.
            Not used if <literal>createLocally</literal> is set.
          '';
        };
      };

      cameras = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Set this to the number of cameras you expect to support.
        '';
      };

      storageDir = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/storage/tank";
        description = ''
          ZoneMinder can generate quite a lot of data, so in case you don't want
          to use the default ${home}, you can override the path here.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional configuration added verbatim to the configuration file.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.createLocally -> cfg.database.username == user;
        message = "services.zoneminder.database.username must be set to ${user} if services.zoneminder.database.createLocally is set true";
      }
    ];

    environment.etc = {
      "zoneminder/60-defaults.conf".source = defaultsFile;
      "zoneminder/80-nixos.conf".source    = configFile;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
      6802 # zmtrigger
    ];

    services = {
      fcgiwrap = lib.mkIf useNginx {
        enable = true;
        preforkProcesses = cfg.cameras;
        inherit user group;
      };

      mysql = lib.mkIf cfg.database.createLocally {
        enable = true;
        package = lib.mkDefault pkgs.mariadb;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [{
          name = cfg.database.username;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }];
      };

      nginx = lib.mkIf useNginx {
        enable = true;
        virtualHosts = {
          ${cfg.hostname} = {
            default = true;
            root = "${pkg}/share/zoneminder/www";
            listen = [ { addr = "0.0.0.0"; inherit (cfg) port; } ];
            extraConfig = let
              fcgi = config.services.fcgiwrap;
            in ''
              index index.php;

              location / {
                try_files $uri $uri/ /index.php?$args =404;

                rewrite ^/skins/.*/css/fonts/(.*)$ /fonts/$1 permanent;

                location ~ /api/(css|img|ico) {
                  rewrite ^/api(.+)$ /api/app/webroot/$1 break;
                  try_files $uri $uri/ =404;
                }

                location ~ \.(gif|ico|jpg|jpeg|png)$ {
                  access_log off;
                  expires 30d;
                }

                location /api {
                  rewrite ^/api(.+)$ /api/app/webroot/index.php?p=$1 last;
                }

                location /cgi-bin {
                  gzip off;

                  include ${pkgs.nginx}/conf/fastcgi_params;
                  fastcgi_param SCRIPT_FILENAME ${pkg}/libexec/zoneminder/${zms};
                  fastcgi_param HTTP_PROXY "";
                  fastcgi_intercept_errors on;

                  fastcgi_pass ${fcgi.socketType}:${fcgi.socketAddress};
                }

                location /cache/ {
                  alias /var/cache/${dirName}/;
                }

                location ~ \.php$ {
                  try_files $uri =404;
                  fastcgi_index index.php;

                  include ${pkgs.nginx}/conf/fastcgi_params;
                  fastcgi_param SCRIPT_FILENAME $request_filename;
                  fastcgi_param HTTP_PROXY "";

                  fastcgi_pass unix:${fpm.socket};
                }
              }
            '';
          };
        };
      };

      phpfpm = lib.mkIf useNginx {
        pools.zoneminder = {
          inherit user group;
          phpOptions = ''
            date.timezone = "${config.time.timeZone}"

            ${lib.concatStringsSep "\n" (map (e:
            "extension=${e.pkg}/lib/php/extensions/${e.name}.so") phpExtensions)}
          '';
          settings = lib.mapAttrs (name: lib.mkDefault) {
            "listen.owner" = user;
            "listen.group" = group;
            "listen.mode" = "0660";

            "pm" = "dynamic";
            "pm.start_servers" = 1;
            "pm.min_spare_servers" = 1;
            "pm.max_spare_servers" = 2;
            "pm.max_requests" = 500;
            "pm.max_children" = 5;
            "pm.status_path" = "/$pool-status";
            "ping.path" = "/$pool-ping";
          };
        };
      };
    };

    systemd.services = {
      zoneminder = with pkgs; {
        inherit (zoneminder.meta) description;
        documentation = [ "https://zoneminder.readthedocs.org/en/latest/" ];
        path = [
          coreutils
          procps
          psmisc
        ];
        after = [ "nginx.service" ] ++ lib.optional cfg.database.createLocally "mysql.service";
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ defaultsFile configFile ];
        preStart = lib.optionalString useCustomDir ''
          install -dm775 -o ${user} -g ${group} ${cfg.storageDir}/{${lib.concatStringsSep "," libDirs}}
        '' + lib.optionalString cfg.database.createLocally ''
          if ! test -e "/var/lib/${dirName}/db-created"; then
            ${config.services.mysql.package}/bin/mysql < ${pkg}/share/zoneminder/db/zm_create.sql
            touch "/var/lib/${dirName}/db-created"
          fi

          ${zoneminder}/bin/zmupdate.pl -nointeractive
        '';
        serviceConfig = {
          User = user;
          Group = group;
          SupplementaryGroups = [ "video" ];
          ExecStart  = "${zoneminder}/bin/zmpkg.pl start";
          ExecStop   = "${zoneminder}/bin/zmpkg.pl stop";
          ExecReload = "${zoneminder}/bin/zmpkg.pl restart";
          PIDFile = "/run/${dirName}/zm.pid";
          Type = "forking";
          Restart = "on-failure";
          RestartSec = "10s";
          CacheDirectory = dirs cacheDirs;
          RuntimeDirectory = dirName;
          ReadWriteDirectories = lib.mkIf useCustomDir [ cfg.storageDir ];
          StateDirectory = dirs (if useCustomDir then [] else libDirs);
          LogsDirectory = dirName;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectKernelTunables = true;
          SystemCallArchitectures = "native";
          NoNewPrivileges = true;
        };
      };
    };

    users.groups.${user} = {
      gid = config.ids.gids.zoneminder;
    };

    users.users.${user} = {
      uid = config.ids.uids.zoneminder;
      group = user;
      inherit home;
      inherit (pkgs.zoneminder.meta) description;
    };
  };

  meta.maintainers = with lib.maintainers; [ peterhoeg ];
}
