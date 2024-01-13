{ config, lib, pkgs, utils, ... }:
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
      enable = lib.mkEnableOption (lib.mdDoc "sing-box universal proxy platform");

      package = lib.mkPackageOption pkgs "sing-box" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            route = {
              geoip.path = lib.mkOption {
                type = lib.types.path;
                default = "${pkgs.sing-geoip}/share/sing-box/geoip.db";
                defaultText = lib.literalExpression "\${pkgs.sing-geoip}/share/sing-box/geoip.db";
                description = lib.mdDoc ''
                  The path to the sing-geoip database.
                '';
              };
              geosite.path = lib.mkOption {
                type = lib.types.path;
                default = "${pkgs.sing-geosite}/share/sing-box/geosite.db";
                defaultText = lib.literalExpression "\${pkgs.sing-geosite}/share/sing-box/geosite.db";
                description = lib.mdDoc ''
                  The path to the sing-geosite database.
                '';
              };
            };
          };
        };
        default = { };
        description = lib.mdDoc ''
          The sing-box configuration, see https://sing-box.sagernet.org/configuration/ for documentation.

          Options containing secret data should be set to an attribute set
          containing the attribute `_secret` - a string pointing to a file
          containing the value the option should be set to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];

    systemd.services.sing-box = {
      preStart = ''
        umask 0077
        mkdir -p /etc/sing-box
        ${utils.genJqSecretsReplacementSnippet cfg.settings "/etc/sing-box/config.json"}
      '';
      wantedBy = [ "multi-user.target" ];
    };
  };

}
