{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.bspwm;
  updateSessionEnvironmentScript = ''
    systemctl --user import-environment PATH DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_RUNTIME_DIR XDG_SESSION_ID DBUS_SESSION_BUS_ADDRESS || true
    dbus-update-activation-environment --systemd --all || true
  '';
in

{
  options = {
    services.xserver.windowManager.bspwm = {
      enable = mkEnableOption "bspwm";

      package = mkPackageOption pkgs "bspwm" { };
      configFile = mkOption {
        type = with types; nullOr path;
        example = literalExpression ''"''${pkgs.bspwm}/share/doc/bspwm/examples/bspwmrc"'';
        default = null;
        description = ''
          Path to the bspwm configuration file.
          If null, $HOME/.config/bspwm/bspwmrc will be used.
        '';
      };
      updateSessionEnvironment = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to run dbus-update-activation-environment and systemctl import-environment before session start.
          Required for xdg portals to function properly.
        '';
      };

      sxhkd = {
        package = mkPackageOption pkgs "sxhkd" { };
        configFile = mkOption {
          type = with types; nullOr path;
          example = literalExpression ''"''${pkgs.bspwm}/share/doc/bspwm/examples/sxhkdrc"'';
          default = null;
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
      name = "bspwm";
      start = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        ${lib.optionalString cfg.updateSessionEnvironment updateSessionEnvironmentScript}
        SXHKD_SHELL=/bin/sh ${cfg.sxhkd.package}/bin/sxhkd ${
          optionalString (cfg.sxhkd.configFile != null) "-c ${escapeShellArg cfg.sxhkd.configFile}"
        } &
        ${cfg.package}/bin/bspwm ${
          optionalString (cfg.configFile != null) "-c ${escapeShellArg cfg.configFile}"
        } &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };

  imports = [
    (mkRemovedOptionModule [
      "services"
      "xserver"
      "windowManager"
      "bspwm"
      "startThroughSession"
    ] "bspwm package does not provide bspwm-session anymore.")
    (mkRemovedOptionModule [
      "services"
      "xserver"
      "windowManager"
      "bspwm"
      "sessionScript"
    ] "bspwm package does not provide bspwm-session anymore.")
  ];
}
