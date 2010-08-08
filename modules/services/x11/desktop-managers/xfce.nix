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
            ${pkgs.xfce.xfwm4}/bin/xfwm4 --daemon
            exec ${pkgs.xfce.terminal}/bin/terminal
          '';
      };

    environment.systemPackages =
      [ pkgs.xfce.xfwm4
        pkgs.xfce.terminal
      ];

  };

}
