{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    toUpper
    ;
  cfg = config.services.wavelog;
  webserver = config.services.${cfg.webserver};
  dbFile = pkgs.writeText "database.php" ''
    <?php
    defined('BASEPATH') OR exit('No direct script access allowed');
    $active_group = 'default';
    $query_builder = TRUE;
    $db['default'] = array(
      'dsn' => "",
      'hostname' => '${cfg.database.host}',
      'username' => '${cfg.database.user}',
      'password' => "",
      'database' => '${cfg.database.name}',
      'dbdriver' => 'mysqli',
      'dbprefix' => "",
      'pconnect' => TRUE,
      'db_debug' => (ENVIRONMENT !== 'production'),
      'cache_on' => FALSE,
      'cachedir' => "",
      'char_set' => 'utf8mb4',
      'dbcollat' => 'utf8mb4_general_ci',
      'swap_pre' => "",
      'encrypt' => FALSE,
      'compress' => FALSE,
      'stricton' => FALSE,
      'failover' => array(),
      'save_queries' => TRUE
    );
  '';
  configFile = pkgs.writeText "config.php" ''
    <?php
    include('${pkgs.wavelog}/application/config/config.sample.php');
    $config['datadir'] = "${cfg.dataDir}/";
    $config['base_url'] = "${cfg.baseUrl}";
    ${cfg.extraConfig}
  '';
  package = pkgs.stdenv.mkDerivation rec {
    pname = "wavelog";
    version = src.version;
    src = pkgs.wavelog;
    installPhase = ''
      mkdir -p $out
      cp -r * $out/

      touch $out/install/.lock

      ln -s ${configFile} $out/application/config/config.php
      ln -s ${dbFile} $out/application/config/database.php

      # make a copy of the original assets/json to prime the datadir
      cp -a "$out/assets/json/" "$out/assets/json.original/"

      # link writable directories
      for directory in updates uploads backup assets/qslcard images/eqsl_card_images assets/json userdata application/cache application/logs; do
        rm -rf $out/$directory
        ln -s ${cfg.dataDir}/$directory $out/$directory
      done
    '';
  };
in
{
  options.services.wavelog = with types; {
    enable = mkEnableOption "Wavelog";
    dataDir = mkOption {
      type = str;
      default = "/var/lib/wavelog";
      description = "Wavelog data directory.";
    };
    baseUrl = mkOption {
      type = str;
      default = "http://localhost";
      description = "Wavelog base URL";
    };
    user = mkOption {
      type = str;
      default = "wavelog";
      description = "User account under which Wavelog runs.";
    };
    webserver = mkOption {
      type = enum [
        "httpd"
        "nginx"
      ];
      default = "httpd";
      description = ''
        Which webserver to use for virtual host management.

        Further nginx configuration can be done by adapting
        {option}`services.nginx.virtualHosts.<name>`, and apache2
        configuration by adapting {option}`services.httpd.virtualHosts.<name>`.
      '';
    };
    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };
      host = mkOption {
        type = str;
        description = "MySQL database host";
        default = "/run/mysqld/mysqld.sock";
      };
      name = mkOption {
        type = str;
        description = "MySQL database name.";
        default = "wavelog";
      };
      user = mkOption {
        type = str;
        description = "MySQL user name.";
        default = "wavelog";
      };
    };
    poolConfig = mkOption {
      type = attrsOf (oneOf [
        str
        int
        bool
      ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for Wavelog's PHP-FPM pool.
      '';
    };
    virtualHost = mkOption {
      type = nullOr str;
      default = "localhost";
      description = ''
        Name of the webserver virtualhost to use and setup. If null, do not setup
         any virtualhost.
      '';
    };
    extraConfig = mkOption {
      description = ''
        Any additional text to be appended to the config.php
        configuration file. This is a PHP script.
      '';
      default = "";
      type = str;
      example = ''
        $config['show_time'] = TRUE;
      '';
    };
    initialUser = {
      name = mkOption {
        type = str;
        default = "wavelog";
        description = "Login name of the account created when the database is initialised.";
      };
      passwordFile = mkOption {
        type = path;
        description = ''
          Path to a file containing the initial password in plaintext. It is
          hashed with bcrypt before being stored and is only read when the
          database is first initialised.
        '';
      };
      email = mkOption {
        type = str;
        default = "wavelog@localhost";
        description = "E-mail address of the initial account.";
      };
      callsign = mkOption {
        type = str;
        default = "N0CALL";
        description = "Callsign of the initial station profile.";
      };
      locator = mkOption {
        type = str;
        default = "AA00AA";
        description = "Maidenhead locator of the initial station profile.";
      };
      language = mkOption {
        type = str;
        default = "english";
        description = ''
          Interface language of the initial account. Must be one of the
          identifiers listed in Wavelog's `application/config/gettext.php`,
          for example `english`, `german` or `polish`.
        '';
      };
    };
    cron = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically run Wavelog's maintenance tasks: uploads to
          LoTW, Clublog and QRZ, and refreshes of the callsign and reference
          databases. The tasks are triggered over HTTP against
          {option}`services.wavelog.baseUrl`.
        '';
      };
      interval = mkOption {
        type = str;
        default = "minutely";
        description = ''
          Specification (in the format described by {manpage}`systemd.time(7)`)
          of the time at which the maintenance tasks run. Wavelog rate-limits
          the endpoint to one run per 30 seconds.
        '';
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.database.createLocally -> cfg.database.user == cfg.user;
          message = "services.wavelog.database.user must be set to services.wavelog.user if services.wavelog.database.createLocally is set to true.";
        }
      ];

      services.phpfpm = {
        pools.wavelog = {
          inherit (cfg) user;
          group = webserver.group;
          settings = {
            "listen.owner" = webserver.user;
            "listen.group" = webserver.group;
          }
          // cfg.poolConfig;
        };
      };

      services.mysql = mkIf cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensurePermissions = {
              "${cfg.database.name}.*" = "ALL PRIVILEGES";
            };
          }
        ];
      };

      systemd = {
        services = {
          wavelog-setup-database = mkIf cfg.database.createLocally {
            description = "Set up wavelog database";
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            requiredBy = [ "phpfpm-wavelog.service" ];
            before = [ "phpfpm-wavelog.service" ];
            after = [
              "mysql.service"
              "systemd-tmpfiles-setup.service"
            ];
            script =
              let
                mysql = "${config.services.mysql.package}/bin/mysql";
                u = cfg.initialUser;
              in
              ''
                if [ ! -f ${cfg.dataDir}/.dbexists ]; then
                  hash=$(${pkgs.php}/bin/php -r \
                    'echo password_hash(trim(file_get_contents($argv[1])), PASSWORD_DEFAULT);' \
                    ${u.passwordFile})

                  ${pkgs.gnused}/bin/sed \
                    -e "s|%%FIRSTUSER_NAME%%|${u.name}|g" \
                    -e "s|%%FIRSTUSER_PASS%%|$hash|g" \
                    -e "s|%%FIRSTUSER_MAIL%%|${u.email}|g" \
                    -e "s|%%FIRSTUSER_CALL%%|${toUpper u.callsign}|g" \
                    -e "s|%%FIRSTUSER_LOCATOR%%|${toUpper u.locator}|g" \
                    -e "s|%%FIRSTUSER_USERLANGUAGE%%|${u.language}|g" \
                    -e "s|%%FIRSTUSER_FIRSTNAME%%||g" \
                    -e "s|%%FIRSTUSER_LASTNAME%%||g" \
                    -e "s|%%FIRSTUSER_CITY%%||g" \
                    -e "s|%%FIRSTUSER_TIMEZONE%%|0|g" \
                    -e "s|%%FIRSTUSER_DXCC%%|0|g" \
                    ${pkgs.wavelog}/install/assets/install.sql \
                    | ${mysql} ${cfg.database.name}

                  touch ${cfg.dataDir}/.dbexists
                fi
              '';
          };
          wavelog-cron = mkIf cfg.cron.enable {
            description = "Wavelog maintenance tasks";
            after = [ "${cfg.webserver}.service" ];
            serviceConfig = {
              Type = "oneshot";
              User = cfg.user;
            };
            script = "${pkgs.curl}/bin/curl -sS --fail ${cfg.baseUrl}/index.php/cron/run";
          };
          wavelog-migrate = {
            description = "Apply Wavelog database migrations";
            wantedBy = [ "multi-user.target" ];
            after = [
              "mysql.service"
              "phpfpm-wavelog.service"
              "${cfg.webserver}.service"
            ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              User = cfg.user;
            };
            script = ''
              response=$(${pkgs.curl}/bin/curl -sS --fail \
                --retry 10 --retry-delay 2 --retry-connrefused \
                ${cfg.baseUrl}/index.php/migrate)
              echo "$response"
              case "$response" in
                *'"status":"success"'*) ;;
                *) echo "wavelog migration did not report success" >&2; exit 1 ;;
              esac
            '';
          };
        };
        timers.wavelog-cron = mkIf cfg.cron.enable {
          description = "Wavelog maintenance tasks";
          wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = cfg.cron.interval;
        };
        tmpfiles.rules =
          let
            group = webserver.group;
          in
          [
            "d ${cfg.dataDir}                         0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/updates                 0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/uploads                 0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/backup                  0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/assets                  0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/assets/json             0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/assets/qslcard          0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/images/eqsl_card_images 0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/userdata                0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/application/logs        0750 ${cfg.user} ${group} - -"
            "d ${cfg.dataDir}/application/cache       0750 ${cfg.user} ${group} - -"
            "C ${cfg.dataDir}/assets/json/US_counties.csv                      0640 ${cfg.user} ${group} - ${package}/assets/json.original/US_counties.csv"
            "C+ ${cfg.dataDir}/assets/json/datatables_languages                0750 ${cfg.user} ${group} - ${package}/assets/json.original/datatables_languages"
          ];
      };
      users.users."${cfg.user}" = {
        isSystemUser = true;
        group = webserver.group;
      };
    }
    (mkIf (cfg.webserver == "nginx") {
      services.nginx = mkIf (cfg.virtualHost != null) {
        enable = true;
        virtualHosts = {
          "${cfg.virtualHost}" = {
            root = "${package}";
            locations = {
              "/".tryFiles = "$uri /index.php$is_args$args";

              "~ ^/(application|system|install)/".extraConfig = ''
                deny all;
              '';

              "~ ^/index.php(/|$)".extraConfig = ''
                include ${config.services.nginx.package}/conf/fastcgi.conf;
                fastcgi_param PATH_INFO $fastcgi_path_info;
                fastcgi_split_path_info ^(.+\.php)(.+)$;
                fastcgi_pass unix:${config.services.phpfpm.pools.wavelog.socket};
              '';
            };
          };
        };
      };
    })
    (mkIf (cfg.webserver == "httpd") {
      services.httpd = mkIf (cfg.virtualHost != null) {
        enable = true;
        extraModules = [ "proxy_fcgi" ];
        virtualHosts."${cfg.virtualHost}" = {
          documentRoot = "${package}";
          extraConfig = ''
            <Directory "${package}">
              <FilesMatch "\.php$">
                <If "-f %{REQUEST_FILENAME}">
                  SetHandler "proxy:unix:${config.services.phpfpm.pools.wavelog.socket}|fcgi://localhost/"
                </If>
              </FilesMatch>

              DirectoryIndex index.php
              Require all granted
              Options +FollowSymLinks -Indexes

              <IfModule mod_rewrite.c>
                RewriteEngine On
                RewriteCond %{REQUEST_FILENAME} !-f
                RewriteCond %{REQUEST_FILENAME} !-d
                RewriteRule ^(.*)$ /index.php?/$1 [L,QSA]
              </IfModule>
            </Directory>

            <Directory "${package}/application">
              Require all denied
            </Directory>

            <Directory "${package}/system">
              Require all denied
            </Directory>

            <Directory "${package}/install">
              Require all denied
            </Directory>
          '';
        };
      };
    })
  ]);
  meta.maintainers = pkgs.wavelog.meta.maintainers;
}
