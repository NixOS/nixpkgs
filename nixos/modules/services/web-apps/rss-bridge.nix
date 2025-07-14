{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    types
    ;

  cfg = config.services.rss-bridge;

  cfgEnv = lib.pipe cfg.config [
    (lib.mapAttrsRecursive (
      path: value:
      lib.optionalAttrs (value != null) {
        name = lib.toUpper "RSSBRIDGE_${lib.concatStringsSep "_" path}";
        value =
          if lib.isList value then
            lib.concatStringsSep "," value
          else if lib.isBool value then
            lib.boolToString value
          else
            toString value;
      }
    ))
    (lib.collect (x: lib.isString x.name or false && lib.isString x.value or false))
    lib.listToAttrs
  ];
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
        default = if cfg.webserver == null then "rss-bridge" else cfg.webserver;
        defaultText = "{option}`config.services.rss-bridge.webserver` or \"rss-bridge\"";
        description = ''
          The user account under which both the service and the web application run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = if cfg.webserver == null then "rss-bridge" else cfg.webserver;
        defaultText = "{option}`config.services.rss-bridge.webserver` or \"rss-bridge\"";
        description = ''
          The group under which the web application runs.
        '';
      };

      package = mkPackageOption pkgs "rss-bridge" { };

      pool = mkOption {
        type = types.nullOr types.str;
        default = "rss-bridge";
        description = ''
          Name of phpfpm pool that is used to run web-application.
          If `null` specified none will be created, otherwise automatically created with default values.
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
          Name of the nginx or caddy virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };

      webserver = mkOption {
        type = types.nullOr (
          types.enum [
            "nginx"
            "caddy"
          ]
        );
        default = "nginx";
        description = ''
          Type of virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };

      config = mkOption {
        type = types.submodule {
          freeformType = (pkgs.formats.ini { }).type;
          options = {
            system = {
              enabled_bridges = mkOption {
                type = with types; nullOr (either str (listOf str));
                description = "Only enabled bridges are available for feed production";
                default = null;
              };
            };
            FileCache = {
              path = mkOption {
                type = types.str;
                description = "Directory where to store cache files (if cache.type = \"file\").";
                default = "${cfg.dataDir}/cache/";
                defaultText = literalExpression "\${config.services.rss-bridge.dataDir}/cache/";
              };
            };
          };
        };
        example = literalExpression ''
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
    services.phpfpm.pools = mkIf (cfg.pool != null) {
      ${cfg.pool} = {
        user = cfg.user;
        settings = lib.mapAttrs (name: mkDefault) {
          "listen.owner" = cfg.user;
          "listen.group" = cfg.group;
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

    services.nginx = mkIf (cfg.virtualHost != null && cfg.webserver == "nginx") {
      enable = true;
      virtualHosts = {
        ${cfg.virtualHost} = {
          root = "${cfg.package}";

          locations."/" = {
            tryFiles = "$uri /index.php$is_args$args";
          };

          locations."~ ^/index.php(/|$)" = {
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.socket};
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "fastcgi_param \"${n}\" \"${v}\";") cfgEnv)}
            '';
          };
        };
      };
    };

    services.caddy = mkIf (cfg.virtualHost != null && cfg.webserver == "caddy") {
      enable = true;
      virtualHosts.${cfg.virtualHost} = {
        extraConfig = ''
          root * ${cfg.package}
          file_server
          php_fastcgi unix/${config.services.phpfpm.pools.${cfg.pool}.socket} {
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "  env ${n} \"${v}\"") cfgEnv)}
          }
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ quantenzitrone ];
}
