{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.compiz;
  xorg = config.services.xserver.package;
  gnome = pkgs.gnome;

  options = { services = { xserver = { windowManager = {

    compiz = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the compiz window manager.";
      };


      renderingFlag = mkOption {
        default = "";
        example = "--indirect-rendering";
        description = "
          Possibly pass --indierct-rendering to Compiz.
        ";
      };
    };

  }; }; }; };
in

mkIf cfg.enable {
  require = options;

  services = {
    xserver = {

      windowManager = {
        session = [{
          name = "compiz";
          start = ''
            # !!! Hack: load the schemas for Compiz.
            GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \
              --makefile-install-rule ${pkgs.compiz}/etc/gconf/schemas/*.schemas # */

            # !!! Hack: turn on most Compiz modules.
            ${gnome.GConf}/bin/gconftool-2 -t list --list-type=string \
              --set /apps/compiz/general/allscreens/options/active_plugins \
              [gconf,png,decoration,wobbly,fade,minimize,move,resize,cube,switcher,rotate,place,scale,water]

            # Start Compiz and the GTK-style window decorator.
            env LD_LIBRARY_PATH=${xorg.libX11}/lib:${xorg.libXext}/lib:/usr/lib/
            ${pkgs.compiz}/bin/compiz gconf ${cfg.renderingFlag} &
            ${pkgs.compiz}/bin/gtk-window-decorator --sync &
          '';
        }];
      };

    };
  };

  environment = {
    x11Packages = [ pkgs.compiz ];
  };
}
