{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.rss-bridge;

  poolName = "rss-bridge";

  cfgHalf = lib.mapAttrsRecursive (
    path: value:
    let
      envName = lib.toUpper ("RSSBRIDGE_" + lib.concatStringsSep "_" path);
      envValue =
        if lib.isList value then
          lib.concatStringsSep "," value
        else if lib.isBool value then
          lib.boolToString value
        else
          toString value;
    in
    if (value != null) then "fastcgi_param \"${envName}\" \"${envValue}\";" else null
  ) cfg.config;
  cfgEnv = lib.concatStringsSep "\n" (lib.collect lib.isString cfgHalf);
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "rss-bridge" "whitelist" ]
      [ "services" "rss-bridge" "config" "system" "enabled_bridges" ]
    )
  ];

  options = {
    services.rss-bridge = {
      enable = lib.mkEnableOption "rss-bridge";

      user = lib.mkOption {
        type = lib.types.str;
        default = "nginx";
        description = ''
          User account under which both the service and the web-application run.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "nginx";
        description = ''
          Group under which the web-application run.
        '';
      };

      pool = lib.mkOption {
        type = lib.types.str;
        default = poolName;
        description = ''
          Name of existing phpfpm pool that is used to run web-application.
          If not specified a pool will be created automatically with
          default values.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/rss-bridge";
        description = ''
          Location in which cache directory will be created.
          You can put `config.ini.php` in here.
        '';
      };

      virtualHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "rss-bridge";
        description = ''
          Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };

      config = lib.mkOption {
        type = lib.types.submodule {
          freeformType = (pkgs.formats.ini { }).type;
          options = {
            system = {
              enabled_bridges = lib.mkOption {
                type = with lib.types; nullOr (either str (listOf str));
                description = "Only enabled bridges are available for feed production";
                default = null;
              };
            };
            FileCache = {
              path = lib.mkOption {
                type = lib.types.str;
                description = "Directory where to store cache files (if cache.type = \"file\").";
                default = "${cfg.dataDir}/cache/";
                defaultText = lib.options.literalExpression "\${config.services.rss-bridge.dataDir}/cache/";
              };
            };
          };
        };
        example = lib.options.literalExpression ''
          {
            system.enabled_bridges = [ "*" ];
            error = {
              output = "http";
              report_limit = 5;
            };
            FileCache = {
              enable_purge = true;
            };
          }
        '';
        description = ''
          Attribute set of arbitrary config options.
          Please consult the documentation at the [wiki](https://rss-bridge.github.io/rss-bridge/For_Hosts/Custom_Configuration.html)
          and [sample config](https://github.com/RSS-Bridge/rss-bridge/blob/master/config.default.ini.php) to see a list of available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.phpfpm.pools = lib.mkIf (cfg.pool == poolName) {
      ${poolName} = {
        user = cfg.user;
        settings = lib.mapAttrs (name: lib.mkDefault) {
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

    systemd.tmpfiles.settings.rss-bridge = {
      "${cfg.config.FileCache.path}".d = {
        mode = "0750";
        user = cfg.user;
        group = cfg.group;
      };
    };

    services.nginx = lib.mkIf (cfg.virtualHost != null) {
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
              ${cfgEnv}
            '';
          };
        };
      };
    };
  };
}
