{
  settingsToEnvVars,
  loadCredential,
  standardSystemdSettings,
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
    systemd.services.fluxer-app-proxy = mkIf (cfg.enable && cfg.app-proxy.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;
          description = "Fluxer web app and edge proxy";

          wantedBy = [ "fluxer.target" ];
          partOf = [ "fluxer.target" ];
          after = [
            "api.service"
            "nginx.service"
            "caddy.service"
          ];
          requires =
            (lib.optional cfg.api.enable "fluxer-api.service")
            ++ (lib.optional cfg.aux.caddy.enable "caddy.service")
            ++ (lib.optional cfg.aux.nginx.enable "nginx.service");

          environment = settingsToEnvVars cfg.app-proxy.settings;

          script = ''
            set -u
            ${fluxer-server}/bin/fluxer-app-proxy
          '';

          serviceConfig = {
            LoadCredential = loadCredential cfg.app-proxy.settings;
            StateDirectory = "fluxer/app-proxy";
            RuntimeDirectory = "fluxer/app-proxy";
          };
        }
      ]
    );
  };
}
