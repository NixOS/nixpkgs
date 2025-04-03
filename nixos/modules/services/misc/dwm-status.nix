{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dwm-status;

  order = lib.concatMapStringsSep "," (feature: ''"${feature}"'') cfg.order;

  configFile = pkgs.writeText "dwm-status.toml" ''
    order = [${order}]

    ${cfg.extraConfig}
  '';
in

{

  ###### interface

  options = {

    services.dwm-status = {

      enable = lib.mkEnableOption "dwm-status user service";

      package = lib.mkPackageOption pkgs "dwm-status" {
        example = "dwm-status.override { enableAlsaUtils = false; }";
      };

      order = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "audio"
            "backlight"
            "battery"
            "cpu_load"
            "network"
            "time"
          ]
        );
        description = ''
          List of enabled features in order.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra config in TOML format.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.upower.enable = lib.elem "battery" cfg.order;

    systemd.user.services.dwm-status = {
      description = "Highly performant and configurable DWM status service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig.ExecStart = "${cfg.package}/bin/dwm-status ${configFile}";
    };

  };

}
