{
  settingsToEnvVars,
  loadCredential,
  standardSystemdSettings,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.services.fluxer;
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
            ${lib.getExe pkgs.fluxer-server.app-proxy}
          '';

          serviceConfig = {
            LoadCredential = loadCredential cfg.app-proxy.settings;
          };
        }
      ]
    );
  };
}
