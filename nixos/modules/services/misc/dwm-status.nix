{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dwm-status;

  features = [ "audio" "backlight" "battery" "cpu_load" "network" "time" ];

  configText = builtins.toJSON ({ inherit (cfg) order; } // cfg.extraConfig);

  configFile = pkgs.writeText "dwm-status.json" configText;
in

{

  ###### interface

  options = {

    services.dwm-status = {

      enable = mkEnableOption "dwm-status user service";

      package = mkOption {
        type = types.package;
        default = pkgs.dwm-status;
        defaultText = "pkgs.dwm-status";
        example = "pkgs.dwm-status.override { enableAlsaUtils = false; }";
        description = "Which dwm-status package to use.";
      };

      order = mkOption {
        type = types.listOf (types.enum features);
        description = "List of enabled features in order.";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        example = literalExample ''
          {
            separator = "#";

            battery = {
              notifier_levels = [ 2 5 10 15 20 ];
            };

            time = {
              format = "%H:%M";
            };
          }
        '';
        description = "Extra config of dwm-status.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.upower.enable = elem "battery" cfg.order;

    systemd.user.services.dwm-status = {
      description = "DWM status service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig.ExecStart = "${cfg.package}/bin/dwm-status ${configFile}";
    };

  };

}
