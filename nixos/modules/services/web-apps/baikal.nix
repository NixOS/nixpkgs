{
  config,
  lib,
  pkgs,
  ...
}:

let
  common-name = "baikal";
  cfg = config.services.baikal;
in
{
  meta.maintainers = [ lib.maintainers.wrvsrx ];
  options = {
    services.baikal = {
      enable = lib.mkEnableOption "tt-rss";
      user = lib.mkOption {
        type = lib.types.str;
        default = common-name;
        description = ''
          User account under which the web-application run.
        '';
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = common-name;
        description = ''
          Group account under which the web-application run.
        '';
      };
      pool = lib.mkOption {
        type = lib.types.str;
        default = common-name;
        description = ''
          Name of existing phpfpm pool that is used to run web-application.
          If not specified a pool will be created automatically with
          default values.
        '';
      };
      virtualHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = common-name;
        description = ''
          Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };
      phpPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.php;
        defaultText = "pkgs.php";
        description = ''
          php package to use for php fpm daemon.
        '';
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.baikal;
        defaultText = "pkgs.baikal";
        description = ''
          Baikal package to use.
        '';
      };

    };
  };
  config = lib.mkIf cfg.enable {
    services.phpfpm.pools = lib.mkIf (cfg.pool == "${common-name}") {
      ${common-name} = {
        inherit (cfg) user phpPackage;
        phpEnv = {
          "BAIKAL_PATH_CONFIG" = "/var/lib/baikal/config/";
          "BAIKAL_PATH_SPECIFIC" = "/var/lib/baikal/specific/";
        };
        settings = lib.mapAttrs (name: lib.mkDefault) {
          "listen.owner" = "nginx";
          "listen.group" = "nginx";
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 1;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
          "pm.process_idle_timeout" = 30;
          "catch_workers_output" = 1;
        };
      };
    };
    services.nginx = lib.mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts."${cfg.virtualHost}" = {
        root = "${cfg.package}/share/php/baikal/html";
        locations."/" = {
          index = "index.php";
        };
        extraConfig = ''
          rewrite ^/.well-known/caldav /dav.php redirect;
          rewrite ^/.well-known/carddav /dav.php redirect;

          charset utf-8;

          location ~ /(\.ht|Core|Specific|config) {
            deny all;
            return 404;
          }

          location ~ ^(.+\.php)(.*)$ {
            try_files $fastcgi_script_name =404;
            include                  ${config.services.nginx.package}/conf/fastcgi_params;
            include                  ${config.services.nginx.package}/conf/fastcgi.conf;
            fastcgi_split_path_info  ^(.+\.php)(.*)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.socket};
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            fastcgi_param  PATH_INFO        $fastcgi_path_info;
          }
        '';
      };
    };

    users.users.${cfg.user} = lib.optionalAttrs (cfg.user == common-name) {
      description = "baikal service user";
      isSystemUser = true;
      inherit (cfg) group;
    };

    users.groups.${cfg.group} = lib.optionalAttrs (cfg.group == common-name) { };

    systemd.tmpfiles.rules = [
      "d /var/lib/baikal/config 0700 baikal baikal -"
      "d /var/lib/baikal/specific 0700 baikal baikal -"
      "d /var/lib/baikal/specific/db 0700 baikal baikal -"
    ];
  };
}
