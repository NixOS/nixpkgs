{
  lib,
  config,
  pkgs,
  ...
}:
let
  this = config.services.piped.frontend;
  inherit (config.services.piped) backend;
  https =
    domain: if lib.hasSuffix ".localhost" domain then "http://${domain}" else "https://${domain}";
in
{
  options.services.piped.frontend = {
    enable = lib.mkEnableOption "Piped Frontend";

    package = lib.mkPackageOption pkgs "piped-frontend" { };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "piped.localhost";
      description = ''
        The domain Piped Frontend is reachable on.
      '';
    };

    externalUrl = lib.mkOption {
      type = lib.types.str;
      example = "https://piped.example.com";
      default = https this.domain;
      defaultText = "The {option}`domain`";
      description = ''
        The external URL of Piped Frontend.
      '';
    };
  };

  config = lib.mkIf this.enable {
    services.piped.backend.settings = {
      FRONTEND_URL = this.externalUrl;
    };

    services.nginx = {
      enable = true;
      virtualHosts.${this.domain} = {
        locations."/" = {
          root = pkgs.runCommand "piped-frontend-patched" { } ''
            cp -r ${this.package} $out
            chmod -R +w $out
            # This is terrible but it's the upstream-intended method for this
            ${pkgs.gnused}/bin/sed -i 's|https://pipedapi.kavin.rocks|${backend.externalUrl}|g' $out/{opensearch.xml,assets/*}
          '';
          tryFiles = "$uri /index.html";
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    defelo
    atemu
  ];
}
