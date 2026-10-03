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

            ${lib.getExe pkgs.fluxer-server.admin}
          '';

          serviceConfig = {
            LoadCredential = loadCredential cfg.admin.settings;
            StateDirectory = "fluxer/admin";
          };
        }
      ]
    );
  };
}
