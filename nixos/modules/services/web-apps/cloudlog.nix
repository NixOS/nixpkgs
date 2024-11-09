{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cloudlog;
  dbFile = let
    password = if cfg.database.createLocally
               then "''"
               else "trim(file_get_contents('${cfg.database.passwordFile}'))";
  in pkgs.writeText "database.php" ''
    <?php
    defined('BASEPATH') OR exit('No direct script access allowed');
    $active_group = 'default';
    $query_builder = TRUE;
    $db['default'] = array(
      'dsn' => "",
      'hostname' => '${cfg.database.host}',
      'username' => '${cfg.database.user}',
      'password' => ${password},
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
    include('${pkgs.cloudlog}/install/config/config.php');
    $config['datadir'] = "${cfg.dataDir}/";
    $config['base_url'] = "${cfg.baseUrl}";
    ${cfg.extraConfig}
  '';
  package = pkgs.stdenv.mkDerivation rec {
    pname = "cloudlog";
    version = src.version;
    src = pkgs.cloudlog;
    installPhase = ''
      mkdir -p $out
      cp -r * $out/

      ln -s ${configFile} $out/application/config/config.php
      ln -s ${dbFile} $out/application/config/database.php

      # link writable directories
      for directory in updates uploads backup logbook; do
        rm -rf $out/$directory
        ln -s ${cfg.dataDir}/$directory $out/$directory
      done

      # link writable asset files
      for asset in dok sota wwff; do
        rm -rf $out/assets/json/$asset.txt
        ln -s ${cfg.dataDir}/assets/json/$asset.txt $out/assets/json/$asset.txt
      done
    '';
  };
in
{
  options.services.cloudlog = with types; {
    enable = mkEnableOption "Cloudlog";
    dataDir = mkOption {
      type = str;
      default = "/var/lib/cloudlog";
      description = "Cloudlog data directory.";
    };
    baseUrl = mkOption {
      type = str;
      default = "http://localhost";
      description = "Cloudlog base URL";
    };
    user = mkOption {
      type = str;
      default = "cloudlog";
      description = "User account under which Cloudlog runs.";
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
        default = "localhost";
      };
      name = mkOption {
        type = str;
        description = "MySQL database name.";
        default = "cloudlog";
      };
      user = mkOption {
        type = str;
        description = "MySQL user name.";
        default = "cloudlog";
      };
      passwordFile = mkOption {
        type = nullOr str;
        description = "MySQL user password file.";
        default = null;
      };
    };
    poolConfig = mkOption {
      type = attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for Cloudlog's PHP-FPM pool.
      '';
    };
    virtualHost = mkOption {
      type = nullOr str;
      default = "localhost";
      description = ''
        Name of the nginx virtualhost to use and setup. If null, do not setup
         any virtualhost.
      '';
    };
    extraConfig = mkOption {
      description = ''
       Any additional text to be appended to the config.php
       configuration file. This is a PHP script. For configuration
       settings, see <https://github.com/magicbug/Cloudlog/wiki/Cloudlog.php-Configuration-File>.
      '';
      default = "";
      type = str;
      example = ''
        $config['show_time'] = TRUE;
      '';
    };
    upload-lotw = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically upload logs to LoTW. If enabled, a systemd
          timer will run the log upload task as specified by the interval
           option.
        '';
      };
      interval = mkOption {
        type = str;
        default = "daily";
        description = ''
          Specification (in the format described by systemd.time(7)) of the
          time at which the LoTW upload will occur.
        '';
      };
    };
    upload-clublog = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically upload logs to Clublog. If enabled, a systemd
          timer will run the log upload task as specified by the interval option.
        '';
      };
      interval = mkOption {
        type = str;
        default = "daily";
        description = ''
          Specification (in the format described by systemd.time(7)) of the time
          at which the Clublog upload will occur.
        '';
      };
    };
    update-lotw-users = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically update the list of LoTW users. If enabled, a
          systemd timer will run the update task as specified by the interval
          option.
        '';
      };
      interval = mkOption {
        type = str;
        default = "weekly";
        description = ''
          Specification (in the format described by systemd.time(7)) of the
          time at which the LoTW user update will occur.
        '';
      };
    };
    update-dok = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically update the DOK resource file. If enabled, a
          systemd timer will run the update task as specified by the interval option.
        '';
      };
      interval = mkOption {
        type = str;
        default = "monthly";
        description = ''
          Specification (in the format described by systemd.time(7)) of the
          time at which the DOK update will occur.
        '';
      };
    };
    update-clublog-scp = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically update the Clublog SCP database. If enabled,
          a systemd timer will run the update task as specified by the interval
          option.
        '';
      };
      interval = mkOption {
        type = str;
        default = "monthly";
        description = ''
          Specification (in the format described by systemd.time(7)) of the time
          at which the Clublog SCP update will occur.
        '';
      };
    };
    update-wwff = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically update the WWFF database. If enabled, a
          systemd timer will run the update task as specified by the interval
          option.
        '';
      };
      interval = mkOption {
        type = str;
        default = "monthly";
        description = ''
          Specification (in the format described by systemd.time(7)) of the time
          at which the WWFF update will occur.
        '';
      };
    };
    upload-qrz = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically upload logs to QRZ. If enabled, a systemd
          timer will run the update task as specified by the interval option.
        '';
      };
      interval = mkOption {
        type = str;
        default = "daily";
        description = ''
          Specification (in the format described by systemd.time(7)) of the
          time at which the QRZ upload will occur.
        '';
      };
    };
    update-sota = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to periodically update the SOTA database. If enabled, a
          systemd timer will run the update task as specified by the interval option.
        '';
      };
      interval = mkOption {
        type = str;
        default = "monthly";
        description = ''
          Specification (in the format described by systemd.time(7)) of the time
          at which the SOTA update will occur.
        '';
      };
    };
  };
  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "services.cloudlog.database.passwordFile cannot be specified if services.cloudlog.database.createLocally is set to true.";
      }
    ];

    services.phpfpm = {
      pools.cloudlog = {
        inherit (cfg) user;
        group = config.services.nginx.group;
        settings =  {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        } // cfg.poolConfig;
      };
    };

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts = {
        "${cfg.virtualHost}" = {
          root = "${package}";
          locations."/".tryFiles = "$uri /index.php$is_args$args";
          locations."~ ^/index.php(/|$)".extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
              fastcgi_split_path_info ^(.+\.php)(.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.cloudlog.socket};
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            '';
        };
      };
    };

    services.mysql = mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = {
          "${cfg.database.name}.*" = "ALL PRIVILEGES";
        };
      }];
    };

    systemd = {
      services = {
        cloudlog-setup-database = mkIf cfg.database.createLocally {
          description = "Set up cloudlog database";
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          wantedBy = [ "phpfpm-cloudlog.service" ];
          after = [ "mysql.service" ];
          script = let
            mysql = "${config.services.mysql.package}/bin/mysql";
          in ''
            if [ ! -f ${cfg.dataDir}/.dbexists ]; then
              ${mysql} ${cfg.database.name} < ${pkgs.cloudlog}/install/assets/install.sql
              touch ${cfg.dataDir}/.dbexists
            fi
        '';
        };
        cloudlog-upload-lotw = {
          description = "Upload QSOs to LoTW if certs have been provided";
          enable = cfg.upload-lotw.enable;
          script = "${pkgs.curl}/bin/curl -s ${cfg.baseUrl}/lotw/lotw_upload";
        };
        cloudlog-update-lotw-users = {
          description = "Update LOTW Users Database";
          enable = cfg.update-lotw-users.enable;
          script = "${pkgs.curl}/bin/curl -s ${cfg.baseUrl}/lotw/load_users";
        };
        cloudlog-update-dok = {
          description = "Update DOK File for autocomplete";
          enable = cfg.update-dok.enable;
          script = "${pkgs.curl}/bin/curl -s ${cfg.baseUrl}/update/update_dok";
        };
        cloudlog-update-clublog-scp = {
          description = "Update Clublog SCP Database File";
          enable = cfg.update-clublog-scp.enable;
          script = "${pkgs.curl}/bin/curl -s ${cfg.baseUrl}/update/update_clublog_scp";
        };
        cloudlog-update-wwff = {
          description = "Update WWFF File for autocomplete";
          enable = cfg.update-wwff.enable;
          script = "${pkgs.curl}/bin/curl -s ${cfg.baseUrl}/update/update_wwff";
        };
        cloudlog-upload-qrz = {
          description = "Upload QSOs to QRZ Logbook";
          enable = cfg.upload-qrz.enable;
          script = "${pkgs.curl}/bin/curl -s ${cfg.baseUrl}/qrz/upload";
        };
        cloudlog-update-sota = {
          description = "Update SOTA File for autocomplete";
          enable = cfg.update-sota.enable;
          script = "${pkgs.curl}/bin/curl -s ${cfg.baseUrl}/update/update_sota";
        };
      };
      timers = {
        cloudlog-upload-lotw = {
          enable = cfg.upload-lotw.enable;
          wantedBy = [ "timers.target" ];
          partOf = [ "cloudlog-upload-lotw.service" ];
          after = [ "phpfpm-cloudlog.service" ];
          timerConfig = {
            OnCalendar = cfg.upload-lotw.interval;
            Persistent = true;
          };
        };
        cloudlog-upload-clublog = {
          enable = cfg.upload-clublog.enable;
          wantedBy = [ "timers.target" ];
          partOf = [ "cloudlog-upload-clublog.service" ];
          after = [ "phpfpm-cloudlog.service" ];
          timerConfig = {
            OnCalendar = cfg.upload-clublog.interval;
            Persistent = true;
          };
        };
        cloudlog-update-lotw-users = {
          enable = cfg.update-lotw-users.enable;
          wantedBy = [ "timers.target" ];
          partOf = [ "cloudlog-update-lotw-users.service" ];
          after = [ "phpfpm-cloudlog.service" ];
          timerConfig = {
            OnCalendar = cfg.update-lotw-users.interval;
            Persistent = true;
          };
        };
        cloudlog-update-dok = {
          enable = cfg.update-dok.enable;
          wantedBy = [ "timers.target" ];
          partOf = [ "cloudlog-update-dok.service" ];
          after = [ "phpfpm-cloudlog.service" ];
          timerConfig = {
            OnCalendar = cfg.update-dok.interval;
            Persistent = true;
          };
        };
        cloudlog-update-clublog-scp = {
          enable = cfg.update-clublog-scp.enable;
          wantedBy = [ "timers.target" ];
          partOf = [ "cloudlog-update-clublog-scp.service" ];
          after = [ "phpfpm-cloudlog.service" ];
          timerConfig = {
            OnCalendar = cfg.update-clublog-scp.interval;
            Persistent = true;
          };
        };
        cloudlog-update-wwff =  {
          enable = cfg.update-wwff.enable;
          wantedBy = [ "timers.target" ];
          partOf = [ "cloudlog-update-wwff.service" ];
          after = [ "phpfpm-cloudlog.service" ];
          timerConfig = {
            OnCalendar = cfg.update-wwff.interval;
            Persistent = true;
          };
        };
        cloudlog-upload-qrz = {
          enable = cfg.upload-qrz.enable;
          wantedBy = [ "timers.target" ];
          partOf = [ "cloudlog-upload-qrz.service" ];
          after = [ "phpfpm-cloudlog.service" ];
          timerConfig = {
            OnCalendar = cfg.upload-qrz.interval;
            Persistent = true;
          };
        };
        cloudlog-update-sota = {
          enable = cfg.update-sota.enable;
          wantedBy = [ "timers.target" ];
          partOf = [ "cloudlog-update-sota.service" ];
          after = [ "phpfpm-cloudlog.service" ];
          timerConfig = {
            OnCalendar = cfg.update-sota.interval;
            Persistent = true;
          };
        };
      };
      tmpfiles.rules = let
        group = config.services.nginx.group;
      in [
        "d ${cfg.dataDir}                0750 ${cfg.user} ${group} - -"
        "d ${cfg.dataDir}/updates        0750 ${cfg.user} ${group} - -"
        "d ${cfg.dataDir}/uploads        0750 ${cfg.user} ${group} - -"
        "d ${cfg.dataDir}/backup         0750 ${cfg.user} ${group} - -"
        "d ${cfg.dataDir}/logbook        0750 ${cfg.user} ${group} - -"
        "d ${cfg.dataDir}/assets/json    0750 ${cfg.user} ${group} - -"
        "d ${cfg.dataDir}/assets/qslcard 0750 ${cfg.user} ${group} - -"
      ];
    };

    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = config.services.nginx.group;
    };
  };

  meta.maintainers = with maintainers; [ melling ];
}
