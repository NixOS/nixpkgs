{
  settingsToEnvVars,
  loadCredential,
  standardSystemdSettings,
  propagateDefaults,
  ...
}:
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.services.fluxer;
  fluxer-server = cfg.package;
in
{
  config = {
    services.fluxer.gateway.settings = lib.mkMerge [
      (propagateDefaults 1500 cfg.settings)
      {
        gateway = {
          media_proxy_endpoint = cfg.settings.media.endpoint;
          static_cdn_endpoint = cfg.settings.static_cdn.endpoint or cfg.settings.public_origin;
        };
      }
    ];

    systemd.services.fluxer-gateway = mkIf (cfg.enable && cfg.gateway.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;
          description = "Fluxer realtime gateway";

          wantedBy = [ "fluxer.target" ];
          partOf = [ "fluxer.target" ];
          after = [
            "nats.service"
            "redis-fluxer.service"
          ];
          requires =
            (lib.optional (cfg.aux.nats.enable) "nats.service")
            ++ (lib.optional (cfg.aux.valkey.enable) "redis-fluxer.service");

          environment = {
            RELX_OUT_FILE_PATH = "/run/fluxer/gateway";
          }
          // settingsToEnvVars cfg.gateway.settings;

          script = ''
            set -u
            ${fluxer-server}/bin/fluxer-gateway
          '';

          serviceConfig = {
            LoadCredential = loadCredential cfg.gateway.settings;
            StateDirectory = "fluxer/gateway";
            RuntimeDirectory = "fluxer/gateway";
          };
        }
      ]
    );
  };
}
