{
  service,
  location ? "/",
  proxyPass ? "http://unix:/run/${service}/socket",
  recommendedProxySettings ? true,
  proxyWebsockets ? false,
  group ? service,
  virtualHost ? { },
}:

{
  lib,
  config,
  options,
  ...
}:

let
  cfg = config.services.${service};
in
{
  options = {
    services.${service} = {
      nginx = {
        enable = lib.mkEnableOption "an Nginx reverse-proxy to ${service}";
        virtualHost = lib.mkOption {
          description = ''
            With this option, you can customize an nginx virtual host which already has sensible defaults for `${service}`.
            Set to `{}` if you do not need any customization to the virtual host.
            If enabled, then by default, the {option}`serverName` is
            `${service}.''${config.networking.domain}`,
            TLS is active, and certificates are acquired via ACME.
          '';
          default = { };
          example = lib.literalExpression ''
            {
              enableACME = false;
              useACMEHost = config.networking.domain;
            }
          '';
          type = lib.types.submodule (
            lib.recursiveUpdate
              (import ../../web-servers/nginx/vhost-options.nix {
                inherit config lib;
              })
              {
                options.serverName = {
                  default = "${service}.${config.networking.domain}";
                  defaultText = "${service}.\${config.networking.domain}";
                };
              }
          );
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.nginx.enable {
      services.nginx = {
        enable = true;
        virtualHosts.${cfg.nginx.virtualHost.serverName} = lib.mkMerge [
          virtualHost
          cfg.nginx.virtualHost
          {
            forceSSL = lib.mkDefault true;
            enableACME = lib.mkDefault true;
            locations.${location} = {
              proxyPass = lib.mkDefault proxyPass;
              recommendedProxySettings = lib.mkDefault recommendedProxySettings;
              proxyWebsockets = lib.mkDefault proxyWebsockets;
            };
          }
        ];
      };
    })
    (lib.optionalAttrs (options ? systemd) {
      systemd.services.nginx.serviceConfig.SupplementaryGroups = [
        group
      ];
    })
  ];
}
