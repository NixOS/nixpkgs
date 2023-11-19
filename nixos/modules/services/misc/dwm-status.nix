{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dwm-status;

  order = concatMapStringsSep "," (feature: ''"${feature}"'') cfg.order;

  configFile = pkgs.writeText "dwm-status.toml" ''
    order = [${order}]

    ${cfg.extraConfig}
  '';
in

{

  ###### interface

  options = {

    services.dwm-status = {

      enable = mkEnableOption (lib.mdDoc "dwm-status user service");

      package = mkOption {
        type = types.package;
        default = pkgs.dwm-status;
        defaultText = literalExpression "pkgs.dwm-status";
        example = literalExpression "pkgs.dwm-status.override { enableAlsaUtils = false; }";
        description = lib.mdDoc ''
          Which dwm-status package to use.
        '';
      };

      order = mkOption {
        type = types.listOf (types.enum [ "audio" "backlight" "battery" "cpu_load" "network" "time" ]);
        description = lib.mdDoc ''
          List of enabled features in order.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra config in TOML format.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.upower.enable = elem "battery" cfg.order;

    systemd.user.services.dwm-status = {
      description = "Highly performant and configurable DWM status service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig.ExecStart = "${cfg.package}/bin/dwm-status ${configFile}";
    };

  };

}
