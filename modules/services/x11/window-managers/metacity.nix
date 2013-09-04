{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xserver.windowManager.metacity;
  xorg = config.services.xserver.package;
  gnome = pkgs.gnome;

in

{
  options = {

    services.xserver.windowManager.metacity.enable = mkOption {
      default = false;
      example = true;
      description = "Enable the metacity window manager.";
    };

  };

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "metacity";
        start = ''
          env LD_LIBRARY_PATH=${xorg.libX11}/lib:${xorg.libXext}/lib:/usr/lib/
          # !!! Hack: load the schemas for Metacity.
          GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \
            --makefile-install-rule ${gnome.metacity}/etc/gconf/schemas/*.schemas # */
          ${gnome.metacity}/bin/metacity &
          waitPID=$!
        '';
      };

    environment.systemPackages = [ gnome.metacity ];

  };

}
