{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xserver.windowManager.compiz;
  xorg = config.services.xserver.package;

in

{

  options = {

    services.xserver.windowManager.compiz = {

      enable = mkOption {
        default = false;
        description = "Enable the Compiz window manager.";
      };

      renderingFlag = mkOption {
        default = "";
        example = "--indirect-rendering";
        description = "Pass the <option>--indirect-rendering</option> flag to Compiz.";
      };

    };

  };


  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "compiz";
        start =
          ''
            # Start Compiz using the flat-file configuration backend
            # (ccp).
            export COMPIZ_PLUGINDIR=${config.system.path}/lib/compiz
            export COMPIZ_METADATADIR=${config.system.path}/share/compiz
            ${pkgs.compiz}/bin/compiz ccp ${cfg.renderingFlag} &

            # Start GTK-style window decorator.
            ${pkgs.compiz}/bin/gtk-window-decorator &
          '';
      };

    environment.systemPackages =
      [ pkgs.compiz
        pkgs.compiz_ccsm
        pkgs.compiz_plugins_main
        pkgs.compiz_plugins_extra
        pkgs.libcompizconfig # for the "ccp" plugin
      ];

    environment.pathsToLink = [ "/lib/compiz" "/share/compiz" ];

  };

}
