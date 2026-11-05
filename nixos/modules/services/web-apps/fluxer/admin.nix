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
    systemd.services.fluxer-admin = mkIf (cfg.enable && cfg.admin.enable) (
      lib.mkMerge [
        standardSystemdSettings
        {
          enable = true;
          description = "Fluxer admin console";

          wantedBy = [ "fluxer.target" ];
          partOf = [ "fluxer.target" ];
          after = [
            "fluxer-api.service"
          ];
          requires = lib.optional (cfg.api.enable) "fluxer-api.service";
          environment = settingsToEnvVars cfg.admin.settings;

          script = ''
            set -u
            export HOME="$STATE_DIRECTORY"

            ${fluxer-server}/bin/fluxer-admin
          '';

          serviceConfig = {
            LoadCredential = loadCredential cfg.admin.settings;
            StateDirectory = "fluxer/admin";
            RuntimeDirectory = "fluxer/admin";
          };
        }
      ]
    );
  };
}
