{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.it-tools;
in
{
  options.services.it-tools = {
    enable = lib.mkEnableOption "it-tools";

    package = lib.mkPackageOption pkgs "it-tools" { };

    nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to configure nginx.
        '';
      };

      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The domain used by the nginx virtualHost.
        '';
      };

      forceSSL = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether or not to force the use of SSL.";
      };

      useACMEHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          A host of an existing Let's Encrypt certificate to use.

          *Note that this still requires services.it-tools.nginx.domain to be set.
        '';
      };
    };

    caddy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to configure caddy.
        '';
      };

      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The domain used by the caddy virtualHost.
        '';
      };

      useACMEHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          A host of an existing Let's Encrypt certificate to use.

          *Note that this still requires services.it-tools.caddy.domain to be set.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      recommendedProxySettings = true;

      virtualHosts.${cfg.nginx.domain} = {
        forceSSL = cfg.nginx.forceSSL;

        enableACME = lib.mkDefault (cfg.nginx.forceSSL && cfg.nginx.useACMEHost == null);
        useACMEHost = cfg.nginx.useACMEHost;

        root = "${cfg.package}/lib";
      };
    };

    services.caddy = lib.mkIf cfg.caddy.enable {
      enable = true;

      virtualHosts.${cfg.caddy.domain} = {
        useACMEHost = cfg.caddy.useACMEHost;

        extraConfig = ''
          root * ${cfg.package}/lib
          file_server
        '';
      };
    };

    assertions = [
      {
        assertion = !cfg.nginx.enable || (cfg.nginx.domain != null);
        message = "To use services.it-tools.nginx, you need to set services.it-tools.nginx.domain";
      }
      {
        assertion = !cfg.caddy.enable || (cfg.caddy.domain != null);
        message = "To use services.it-tools.caddy, you need to set services.it-tools.caddy.domain";
      }
    ];
  };

  meta.maintainers = [
    lib.maintainers.akotro
  ];
}
