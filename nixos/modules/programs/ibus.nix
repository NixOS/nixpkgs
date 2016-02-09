{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.ibus;
in
{
  options = {

    programs.ibus = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable IBus input method";
      };
      plugins = mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
        description = ''
          IBus plugin packages
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ibus pkgs.gnome3.dconf ];

    gtkPlugins = [ pkgs.ibus ];
    qtPlugins = [ pkgs.ibus-qt ];

    environment.variables =
      let
        env = pkgs.buildEnv {
          name = "ibus-env";
          paths = [ pkgs.ibus ] ++ cfg.plugins;
        };
      in {
        GTK_IM_MODULE = "ibus";
        QT_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";

        IBUS_COMPONENT_PATH = "${env}/share/ibus/component";
      };

    services.xserver.displayManager.sessionCommands = "${pkgs.ibus}/bin/ibus-daemon --daemonize --xim --cache=none";
  };
}
