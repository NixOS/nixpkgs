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
    systemd.services.fluxer-push = mkIf (cfg.enable && cfg.push.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;
          description = "Fluxer push notification delivery service and push relay";

          wantedBy = [ "fluxer.target" ];
          partOf = [ "fluxer.target" ];
          after = [
            "nats.service"
            "fluxer-api.service"
          ];
          requires =
            (lib.optional cfg.aux.nats.enable "nats.service")
            ++ (lib.optional cfg.api.enable "fluxer-api.service");

          environment = settingsToEnvVars cfg.push.settings;

          script = ''
            set -u
            ${lib.getExe pkgs.fluxer-server.push};
          '';

          serviceConfig = {
            LoadCredential = loadCredential cfg.push.settings;
          };
        }
      ]
    );
  };
}
