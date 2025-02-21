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

      useACMEHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          A host of an existing Let's Encrypt certificate to use.

          *Note that this still requires services.it-tools.nginx.domain to be set.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts.${cfg.nginx.domain} = lib.mkIf cfg.nginx.enable {
      forceSSL = lib.mkDefault true;

      enableACME = lib.mkDefault (cfg.nginx.useACMEHost == null);
      useACMEHost = cfg.nginx.useACMEHost;

      root = "${cfg.package}/lib";
    };

    assertions = [
      {
        assertion = !cfg.nginx.enable || (cfg.nginx.domain != null);
        message = "To use services.it-tools.nginx, you need to set services.it-tools.nginx.domain";
      }
    ];
  };
}
