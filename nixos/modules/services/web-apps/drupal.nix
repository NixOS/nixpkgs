{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mapAttrs
    mapAttrs'
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    nameValuePair
    types
    ;
  cfg = config.services.drupal;

  siteOpts =
    {
      options,
      config,
      lib,
      name,
      ...
    }:
    {
      options = {
        enable = mkEnableOption "Drupal web application";
        package = mkPackageOption pkgs "drupal" { };

        stateDir = mkOption {
          type = types.path;
          default = "/var/lib/drupal/${name}/data";
          description = "Location of the Drupal site state directory.";
        };

        phpOptions = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = ''
            Options for PHP's php.ini file for this Drupal site.
          '';
          example = literalExpression ''
            {
              "opcache.interned_strings_buffer" = "8";
              "opcache.max_accelerated_files" = "10000";
              "opcache.memory_consumption" = "128";
              "opcache.revalidate_freq" = "15";
              "opcache.fast_shutdown" = "1";
            }
          '';
        };

        poolConfig = mkOption {
          type =
            with types;
            attrsOf (oneOf [
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
            Options for the Drupal PHP pool. See the documentation on `php-fpm.conf`
            for details on configuration directives.
          '';
        };
      };
    };
in
{
  options = {
    services.drupal = {
      enable = mkEnableOption "drupal";
      package = mkPackageOption pkgs "drupal";

      sites = mkOption {
        type = types.attrsOf (types.submodule siteOpts);
        default = { };
        description = "Specification of one or more Drupal sites to serve";
      };

      webserver = mkOption {
        type = types.enum [
          "nginx"
          "caddy"
        ];
        default = "caddy";
        description = ''
          Whether to use nginx or caddy for virtual host management.

          Further nginx configuration can be done by adapting `services.nginx.virtualHosts.<name>`.
          See [](#opt-services.nginx.virtualHosts) for further information.

          Further caddy configuration can be done by adapting `services.caddy.virtualHosts.<name>`.
          See [](#opt-services.caddy.virtualHosts) for further information.
        '';
      };
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    (mkIf (cfg.webserver == "nginx") {
      services.nginx = mkIf (cfg.virtualHost != null) {
        enable = true;
        virtualHosts = mapAttrs (hostName: cfg: {
          serverName = mkDefault hostName;
          root = "${cfg.package}/share/php/drupal";

          locations = {
            "~ /(conf/|bin/|inc/|install.php)" = {
              extraConfig = "deny all;";
            };

            "~ ^/data/" = {
              root = "${cfg.stateDir}";
              extraConfig = "internal;";
            };

            "~ ^/lib.*\.(js|css|gif|png|ico|jpg|jpeg)$" = {
              extraConfig = "expires 365d;";
            };

            "/" = {
              priority = 1;
              index = "index.php";
              extraConfig = ''try_files $uri $uri/ @drupal;'';
            };

            "@drupal" = {
              extraConfig = ''
                # rewrites "doku.php/" out of the URLs if you set the userwrite setting to .htaccess in drupal config page
                rewrite ^/_media/(.*) /lib/exe/fetch.php?media=$1 last;
                rewrite ^/_detail/(.*) /lib/exe/detail.php?media=$1 last;
                rewrite ^/_export/([^/]+)/(.*) /doku.php?do=export_$1&id=$2 last;
                rewrite ^/(.*) /doku.php?id=$1&$args last;
              '';
            };

            "~ \\.php$" = {
              extraConfig = ''
                try_files $uri $uri/ /doku.php;
                include ${config.services.nginx.package}/conf/fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param REDIRECT_STATUS 200;
                fastcgi_pass unix:${config.services.phpfpm.pools."drupal-${hostName}".socket};
              '';
            };

          };
        }) cfg.sites;
      };
    })

    (mkIf (cfg.webserver == "caddy") {
      services.caddy = {
        enable = true;
        virtualHosts = mapAttrs' (
          hostName: cfg:
          (nameValuePair "http://${hostName}" {
            extraConfig = ''
              root * ${cfg.package}/share/php/drupal
              file_server

              encode zstd gzip
              php_fastcgi unix/${config.services.phpfpm.pools."drupal-${hostName}".socket}

              @restrict_files {
                path /data/* /conf/* /bin/* /inc/* /vendor/* /install.php
              }

              respond @restrict_files 404

              @allow_media {
                path_regexp path ^/_media/(.*)$
              }
              rewrite @allow_media /lib/exe/fetch.php?media=/{http.regexp.path.1}

              @allow_detail   {
                path /_detail*
              }
              rewrite @allow_detail /lib/exe/detail.php?media={path}

              @allow_export   {
                path /_export*
                path_regexp export /([^/]+)/(.*)
              }
              rewrite @allow_export /doku.php?do=export_{http.regexp.export.1}&id={http.regexp.export.2}

              try_files {path} {path}/ /doku.php?id={path}&{query}
            '';
          })
        ) cfg.sites;
      };
    })

  ]);
}
