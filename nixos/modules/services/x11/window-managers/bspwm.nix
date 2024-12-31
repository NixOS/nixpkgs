{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.windowManager.bspwm;
in

{
  options = {
    services.xserver.windowManager.bspwm = {
      enable = lib.mkEnableOption "bspwm";

      package = lib.mkPackageOption pkgs "bspwm" {
        example = "bspwm-unstable";
      };
      configFile = lib.mkOption {
        type = with lib.types; nullOr path;
        example = lib.literalExpression ''"''${pkgs.bspwm}/share/doc/bspwm/examples/bspwmrc"'';
        default = null;
        description = ''
          Path to the bspwm configuration file.
          If null, $HOME/.config/bspwm/bspwmrc will be used.
        '';
      };

      sxhkd = {
        package = lib.mkPackageOption pkgs "sxhkd" {
          example = "sxhkd-unstable";
        };
        configFile = lib.mkOption {
          type = with lib.types; nullOr path;
          example = lib.literalExpression ''"''${pkgs.bspwm}/share/doc/bspwm/examples/sxhkdrc"'';
          default = null;
          description = ''
            Path to the sxhkd configuration file.
            If null, $HOME/.config/sxhkd/sxhkdrc will be used.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "bspwm";
      start = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        SXHKD_SHELL=/bin/sh ${cfg.sxhkd.package}/bin/sxhkd ${
          lib.optionalString (cfg.sxhkd.configFile != null) "-c \"${cfg.sxhkd.configFile}\""
        } &
        ${cfg.package}/bin/bspwm ${lib.optionalString (cfg.configFile != null) "-c \"${cfg.configFile}\""} &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "xserver" "windowManager" "bspwm-unstable" "enable" ]
      "Use services.xserver.windowManager.bspwm.enable and set services.xserver.windowManager.bspwm.package to pkgs.bspwm-unstable to use the unstable version of bspwm."
    )
    (lib.mkRemovedOptionModule [
      "services"
      "xserver"
      "windowManager"
      "bspwm"
      "startThroughSession"
    ] "bspwm package does not provide bspwm-session anymore.")
    (lib.mkRemovedOptionModule [
      "services"
      "xserver"
      "windowManager"
      "bspwm"
      "sessionScript"
    ] "bspwm package does not provide bspwm-session anymore.")
  ];
}
