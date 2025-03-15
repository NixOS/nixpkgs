{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.sing-box;
  settingsFormat = pkgs.formats.json { };
in
{

  meta = {
    maintainers = with lib.maintainers; [
      nickcao
      oluceps
    ];
  };

  options = {
    services.sing-box = {
      enable = lib.mkEnableOption "sing-box universal proxy platform";

      package = lib.mkPackageOption pkgs "sing-box" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
        };
        default = { };
        description = ''
          The sing-box configuration, see https://sing-box.sagernet.org/configuration/ for documentation.

          Options containing secret data should be set to an attribute set
          containing the attribute `_secret` - a string pointing to a file
          containing the value the option should be set to.
        '';
      };
      configFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = ''
          The path of file that contains sing-box configuration.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      useConfigFile = cfg.configFile != null;
    in
    {
      assertions =
        (lib.singleton {
          assertion =
            let
              settingsSet = cfg.settings != { };
            in
            useConfigFile -> !settingsSet;
          message = ''
            `services.sing-box.settings` or `services.sing-box.configFile` must be set exclusively.
          '';
        })
        ++ (lib.optionals (!useConfigFile) (
          let
            rules = cfg.settings.route.rules or [ ];
          in
          [
            {
              assertion = !lib.any (r: r ? source_geoip || r ? geoip) rules;
              message = ''
                Deprecated option `services.sing-box.settings.route.rules.*.{source_geoip,geoip}` is set.
                See https://sing-box.sagernet.org/migration/#migrate-geoip-to-rule-sets for migration instructions.
              '';
            }
            {
              assertion = !lib.any (r: r ? geosite) rules;
              message = ''
                Deprecated option `services.sing-box.settings.route.rules.*.geosite` is set.
                See https://sing-box.sagernet.org/migration/#migrate-geosite-to-rule-sets for migration instructions.
              '';
            }
          ]
        ));

      systemd.packages = [ cfg.package ];

      systemd.services.sing-box = {

        preStart = lib.mkIf (!useConfigFile) (
          utils.genJqSecretsReplacementSnippet cfg.settings "/run/sing-box/config.json"
        );

        serviceConfig = {
          StateDirectory = "sing-box";
          StateDirectoryMode = "0700";
          RuntimeDirectory = "sing-box";
          RuntimeDirectoryMode = "0700";
          LoadCredential = lib.mkIf useConfigFile [ ("config.json:" + cfg.configFile) ];
          ExecStart = [
            ""
            (
              let
                configArgs =
                  if useConfigFile then "-c $\{CREDENTIALS_DIRECTORY}/config.json" else "-C \${RUNTIME_DIRECTORY}";
              in
              "${lib.getExe cfg.package} -D \${STATE_DIRECTORY} ${configArgs} run"
            )
          ];
        };
        wantedBy = [ "multi-user.target" ];
      };
    }
  );

}
