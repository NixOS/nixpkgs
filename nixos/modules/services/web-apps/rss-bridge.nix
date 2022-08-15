{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.rss-bridge;

  poolName = "rss-bridge";

  whitelist = pkgs.writeText "rss-bridge_whitelist.txt"
    (concatStringsSep "\n" cfg.whitelist);
in
{
  options = {
    services.rss-bridge = {
      enable = mkEnableOption "rss-bridge";

      user = mkOption {
        type = types.str;
        default = "nginx";
        description = lib.mdDoc ''
          User account under which both the service and the web-application run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nginx";
        description = lib.mdDoc ''
          Group under which the web-application run.
        '';
      };

      pool = mkOption {
        type = types.str;
        default = poolName;
        description = lib.mdDoc ''
          Name of existing phpfpm pool that is used to run web-application.
          If not specified a pool will be created automatically with
          default values.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/rss-bridge";
        description = lib.mdDoc ''
          Location in which cache directory will be created.
          You can put `config.ini.php` in here.
        '';
      };

      virtualHost = mkOption {
        type = types.nullOr types.str;
        default = "rss-bridge";
        description = lib.mdDoc ''
          Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };

      whitelist = mkOption {
        type = types.listOf types.str;
        default = [];
        example = options.literalExpression ''
          [
            "Facebook"
            "Instagram"
            "Twitter"
          ]
        '';
        description = lib.mdDoc ''
          List of bridges to be whitelisted.
          If the list is empty, rss-bridge will use whitelist.default.txt.
          Use `[ "*" ]` to whitelist all.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools = mkIf (cfg.pool == poolName) {
      ${poolName} = {
        user = cfg.user;
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = cfg.user;
          "listen.group" = cfg.user;
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = 1;
        };
      };
    };
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}/cache' 0750 ${cfg.user} ${cfg.group} - -"
      (mkIf (cfg.whitelist != []) "L+ ${cfg.dataDir}/whitelist.txt - - - - ${whitelist}")
      "z '${cfg.dataDir}/config.ini.php' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts = {
        ${cfg.virtualHost} = {
          root = "${pkgs.rss-bridge}";

          locations."/" = {
            tryFiles = "$uri /index.php$is_args$args";
          };

          locations."~ ^/index.php(/|$)" = {
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.socket};
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param RSSBRIDGE_DATA ${cfg.dataDir};
            '';
          };
        };
      };
    };
  };
}
