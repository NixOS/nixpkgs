{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.bspwm;
in

{
  options = {
    services.xserver.windowManager.bspwm = {
      enable = mkEnableOption "bspwm";

      package = mkPackageOption pkgs "bspwm" {
        example = "bspwm-unstable";
      };
      configFile = mkOption {
        type        = with types; nullOr path;
        example     = literalExpression ''"''${pkgs.bspwm}/share/doc/bspwm/examples/bspwmrc"'';
        default     = null;
        description = ''
          Path to the bspwm configuration file.
          If null, $HOME/.config/bspwm/bspwmrc will be used.
        '';
      };

      sxhkd = {
        package = mkPackageOption pkgs "sxhkd" {
          example = "sxhkd-unstable";
        };
        configFile = mkOption {
          type        = with types; nullOr path;
          example     = literalExpression ''"''${pkgs.bspwm}/share/doc/bspwm/examples/sxhkdrc"'';
          default     = null;
          description = ''
            Path to the sxhkd configuration file.
            If null, $HOME/.config/sxhkd/sxhkdrc will be used.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name  = "bspwm";
      start = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        SXHKD_SHELL=/bin/sh ${cfg.sxhkd.package}/bin/sxhkd ${optionalString (cfg.sxhkd.configFile != null) "-c \"${cfg.sxhkd.configFile}\""} &
        ${cfg.package}/bin/bspwm ${optionalString (cfg.configFile != null) "-c \"${cfg.configFile}\""} &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };

  imports = [
   (mkRemovedOptionModule [ "services" "xserver" "windowManager" "bspwm-unstable" "enable" ]
     "Use services.xserver.windowManager.bspwm.enable and set services.xserver.windowManager.bspwm.package to pkgs.bspwm-unstable to use the unstable version of bspwm.")
   (mkRemovedOptionModule [ "services" "xserver" "windowManager" "bspwm" "startThroughSession" ]
     "bspwm package does not provide bspwm-session anymore.")
   (mkRemovedOptionModule [ "services" "xserver" "windowManager" "bspwm" "sessionScript" ]
     "bspwm package does not provide bspwm-session anymore.")
  ];
}
