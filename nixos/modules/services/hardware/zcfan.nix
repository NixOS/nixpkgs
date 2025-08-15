{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zcfan;
in
{
  options = {
    services.zcfan = {
      enable = lib.mkEnableOption "zero-configuration fan daemon for ThinkPads (zcfan)";

      settings = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Optional lines added verbatim to the configuration file.
          Before changing this, read the {manpage}`zcfan(1)`
          and project's readme at
          https://github.com/cdown/zcfan/tree/master?tab=readme-ov-file#usage
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.thinkfan.enable;
        message = ''
          You have set services.zcfan.enable = true;
          which conflicts with services.thinkfan.enable = true;
        '';
      }
    ];

    environment.systemPackages = [ pkgs.zcfan ];
    systemd.packages = [ pkgs.zcfan ];

    environment.etc."zcfan.conf".text = cfg.settings;

    systemd.services = {
      zcfan = {
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = "30s";
        };
        restartTriggers = [ config.environment.etc."zcfan.conf".text ];
        # must be added manually, see issue #81138
        wantedBy = [ "default.target" ];
      };
    };

    boot.extraModprobeConfig = "options thinkpad_acpi fan_control=1";
  };

  meta.maintainers = with lib.maintainers; [ surfaceflinger ];
}
