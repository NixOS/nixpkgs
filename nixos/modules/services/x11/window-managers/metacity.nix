{ config, lib, pkgs, ... }:

with lib;

let

  wmcfg = config.services.xserver.windowManager;
  cfg = config.services.xserver.windowManager.metacity;
  xorg = config.services.xserver.package;
  gnome = pkgs.gnome;

in

{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "metacity" ]);
    };
  };

  config = mkIf (elem "metacity" wmcfg.select) {

    services.xserver.windowManager.session = singleton
      { name = "metacity";
        start = ''
          env LD_LIBRARY_PATH=${lib.makeLibraryPath [ xorg.libX11 xorg.libXext ]}:/usr/lib/
          # !!! Hack: load the schemas for Metacity.
          GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf.out}/bin/gconftool-2 \
            --makefile-install-rule ${gnome.metacity}/etc/gconf/schemas/*.schemas # */
          ${gnome.metacity}/bin/metacity &
          waitPID=$!
        '';
      };

    environment.systemPackages = [ gnome.metacity ];

  };

}
