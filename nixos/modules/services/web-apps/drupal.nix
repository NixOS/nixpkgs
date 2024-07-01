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
        default = {
          "localhost" = {
            enable = true;
          };
        };
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
            "/" = {
              priority = 1;
              index = "index.php";
              extraConfig = ''try_files $uri $uri/'';
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
            '';
          })
        ) cfg.sites;
      };
    })

  ]);
}
