{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.croodle;
  group = config.services.nginx.group;
  poolName = "croodle";
  package = pkgs.croodle.override { inherit (cfg) dataDir debug; };

in

{
  options.services.croodle = with types; {
    enable = mkEnableOption (mdDoc "Enable Croodle");
    dataDir = mkOption {
      type = str;
      default = "/var/lib/croodle";
      description = mdDoc "Croodle data directory where polls are stored.";
    };
    debug = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc "Enable Slim debug mode.";
    };
    user = mkOption {
      type = str;
      default = "croodle";
      description = mdDoc "User account under which Croodle runs.";
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
      description = mdDoc ''
        Options for Croodle's PHP-FPM pool.
      '';
    };
    virtualHost = mkOption {
      type = nullOr str;
      default = "localhost";
      description = mdDoc ''
        Name of the nginx virtualhost to setup and use. Disabled if null.
      '';
    };
    enableSSL = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable SSL for the virtualhost.
      '';
    };
    delete-outdated = {
      enable = mkOption {
        type = bool;
        default = true;
        description = mdDoc ''
          Delete outdated polls from the data directory.
        '';
      };
      interval = mkOption {
        type = str;
        default = "daily";
        description = mdDoc ''
          How often deletion of outdated polls should occur (in the format
          described by systemd.time(7)).
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm = {
      pools.${poolName} = {
        inherit (cfg) user;
        inherit group;
        settings =  {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = group;
        } // cfg.poolConfig;
      };
    };

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts."${cfg.virtualHost}" = mkMerge [
        {
          root = "${package}/share/croodle";
          locations = {
            "~ \\.(js|css)$".extraConfig = "expires 365d;";
            "~ \\.php(/|$)".extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi.conf;
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_split_path_info ^(.+\.php)(.+)$;
              fastcgi_param PATH_INFO $fastcgi_path_info;
              fastcgi_pass unix:${config.services.phpfpm.pools.${poolName}.socket};
            '';
          };
        }
        (mkIf cfg.enableSSL {
          enableACME = true;
          forceSSL = true;
        })
      ];
    };

    systemd = {
      tmpfiles.rules = [ "d ${cfg.dataDir} 0750 ${cfg.user} ${group} -" ];
      services.croodle-delete-outdated = {
        description = "Delete outdated polls";
        enable = cfg.delete-outdated.enable;
        script = "${pkgs.php}/bin/php ${package}/share/croodle/api/cron.php";
      };
      timers.croodle-delete-outdated = {
        enable = cfg.delete-outdated.enable;
        wantedBy = [ "timers.target" ];
        partOf = [ "croodle-delete-outdated.service" ];
        after = [ "phpfpm-${poolName}.service" ];
        timerConfig = {
          OnCalendar = cfg.delete-outdated.interval;
          Persistent = true;
        };
      };
    };

    users.users."${cfg.user}" = {
      isSystemUser = true;
      inherit group;
    };
  };

  meta.maintainers = with maintainers; [ jboy ];
}
