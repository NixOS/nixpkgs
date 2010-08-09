{ config, pkgs, ... }:

with pkgs.lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.xfce;

in

{
  options = {

    services.xserver.desktopManager.xfce.enable = mkOption {
      default = false;
      example = true;
      description = "Enable the Xfce desktop environment.";
    };

  };

  
  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton
      { name = "xfce";
        bgSupport = true;
        start =
          ''
            exec ${pkgs.stdenv.shell} ${pkgs.xfce.xfceutils}/etc/xdg/xfce4/xinitrc
          '';
      };

    environment.systemPackages =
      [
        pkgs.which # Needed by the xfce's xinitrc script.
        pkgs.xfce.exo
        pkgs.xfce.terminal
        pkgs.xfce.xfce4panel
        pkgs.xfce.xfce4session
        pkgs.xfce.xfceutils
        pkgs.xfce.xfconf
        pkgs.xfce.xfdesktop
        pkgs.xfce.xfwm4
      ];

  };

}
