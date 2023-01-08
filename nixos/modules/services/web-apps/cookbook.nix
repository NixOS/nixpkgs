{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkMerge mkOption mkEnableOption mkPackageOptionMD mdDoc types;
  cfg = config.services.cookbook;
  cookbook-config-file = pkgs.writeText "config.json" (builtins.toJSON {
    SECRET_KEY = cfg.config.secret;
    COOKBOOK_LOCATION = cfg.config.recipes;
    DEFAULT_LANG = cfg.config.default-language;
    SITE_NAME = cfg.config.site-name;
    BASE_URL = "https://${cfg.vhost}";
  });
in
{
  options.services.cookbook = {
    enable = mkEnableOption (mdDoc "cookbook service");

    vhost = mkOption {
      type = types.str;
      description = mdDoc "Domain to serve on.";
    };

    package = mkPackageOptionMD pkgs "cookbook" {
      default = [ "python3Packages" "cookbook" ];
    };

    group = mkOption {
      type = types.str;
      description = mdDoc "Unix group that owns the socket that nginx and uwsgi will communicate with.";
      default = "cookbook";
    };

    useACMEHost = mkOption {
      type = types.nullOr types.str;
      description = mdDoc "Add the cookbook domain to this domain's certificate's list.";
      default = null;
    };

    config = {
      site-name = mkOption {
        type = types.str;
        description = mdDoc "User-visible name of the website.";
        default = "Cookbook";
      };

      default-language = mkOption {
        type = types.str;
        description = mdDoc "Default language to use when users first navigate to the service.";
        default = "en";
      };

      recipes = mkOption {
        type = types.path;
        description = mdDoc "Path to the folder containing the recipes (can be read-only).";
      };

      secret = mkOption {
        type = types.str;
        description = mdDoc "A random string used to sign session cookies (keep this secret).";
        example = "builtins.readFile .secrets/cookbook-secret";
      };
    };
  };

  config = mkIf cfg.enable {
    security.acme.certs = mkIf (cfg.useACMEHost != null) {
      "${cfg.useACMEHost}".extraDomainNames = [ cfg.vhost ];
    };

    users.groups."${cfg.group}".members = [ "nginx" "uwsgi" ];

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.vhost}" = mkMerge [
        (mkIf (cfg.useACMEHost != null) {
          forceSSL = true;
          useACMEHost = cfg.useACMEHost;
        })
        ({
          locations = {
            "/static/".alias = "${cfg.package}/static/";
            "/images/" = {
              alias = "${cfg.config.recipes}/images/";
              extraConfig = ''
                expires 7d;
                add_header Cache-Control "public";
              '';
            };
            "/" = {
              extraConfig = ''
                uwsgi_pass unix:${config.services.uwsgi.runDir}/cookbook.sock;
              '';
            };
          };
        })
      ];
    };

    services.uwsgi = {
      enable = true;
      plugins = [ "python3" ];

      instance = {
        type = "emperor";
        vassals.cookbook = {
          type = "normal";
          master = true;
          workers = 5;
          plugin = "python3";
          chmod-socket = "664";
          chown-socket = "uwsgi:${cfg.group}";
          socket = "${config.services.uwsgi.runDir}/cookbook.sock";

          pythonPackages = self: [ cfg.package ];
          module = "cookbook:app";
          env = [ "COOKBOOK_CONFIG=${cookbook-config-file}" ];
        };
      };
    };
  };
}
