{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.rss-bridge;

  poolName = "rss-bridge";

  configAttr = lib.recursiveUpdate { FileCache.path = "${cfg.dataDir}/cache/"; } cfg.config;
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
    "fastcgi_param \"${envName}\" \"${envValue}\";"
  ) configAttr;
  cfgEnv = lib.concatStringsSep "\n" (lib.collect lib.isString cfgHalf);
in
{
  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "rss-bridge"
        "whitelist"
      ]
      [
        "services"
        "rss-bridge"
        "config"
        "system"
        "enabled_bridges"
      ]
    )
  ];

  options = {
    services.rss-bridge = {
      enable = mkEnableOption "rss-bridge";

      user = mkOption {
        type = types.str;
        default = "nginx";
        description = ''
          User account under which both the service and the web-application run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nginx";
        description = ''
          Group under which the web-application run.
        '';
      };

      pool = mkOption {
        type = types.str;
        default = poolName;
        description = ''
          Name of existing phpfpm pool that is used to run web-application.
          If not specified a pool will be created automatically with
          default values.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/rss-bridge";
        description = ''
          Location in which cache directory will be created.
          You can put `config.ini.php` in here.
        '';
      };

      virtualHost = mkOption {
        type = types.nullOr types.str;
        default = "rss-bridge";
        description = ''
          Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };

      config = mkOption {
        type =
          with types;
          attrsOf (
            attrsOf (oneOf [
              bool
              int
              str
              (listOf str)
            ])
          );
        default = { };
        defaultText = options.literalExpression "FileCache.path = \"\${config.services.rss-bridge.dataDir}/cache/\"";
        example = options.literalExpression ''
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
    systemd.tmpfiles.settings.rss-bridge =
      let
        perm = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      in
      {
        "${configAttr.FileCache.path}".d = perm;
        "${cfg.dataDir}/config.ini.php".z = perm;
      };

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
              ${cfgEnv}
            '';
          };
        };
      };
    };
  };
}
