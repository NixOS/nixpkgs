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
    maintainers = with lib.maintainers; [ nickcao ];
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
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
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
      ];

    systemd.packages = [ cfg.package ];

    systemd.services.sing-box = {
      preStart = utils.genJqSecretsReplacementSnippet cfg.settings "/run/sing-box/config.json";
      serviceConfig = {
        StateDirectory = "sing-box";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "sing-box";
        RuntimeDirectoryMode = "0700";
        ExecStart = [
          ""
          "${lib.getExe cfg.package} -D \${STATE_DIRECTORY} -C \${RUNTIME_DIRECTORY} run"
        ];
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

}
