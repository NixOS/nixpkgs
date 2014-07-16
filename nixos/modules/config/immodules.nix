{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    gtk2ImModules = mkOption {
      type = types.listOf types.path;
      default = [];
      example = [ "${pkgs.uim}/lib/gtk-2.0/2.10.0/immodules/*.so" ];
      description = "input method modules for GTK+ 2";
    };

    gtk3ImModules = mkOption {
      type = types.listOf types.path;
      default = [];
      example = [ "${pkgs.uim}/lib/gtk-3.0/3.0.0/immodules/*.so" ];
      description = "input method modules for GTK+ 3";
    };

    qtImModules = mkOption {
      type = types.listOf types.path;
      default = [];
      example = [ "${pkgs.uim}lib/qt4/plugins/inputmethods/*.so" ];
      description = "input method modules for Qt 4";
    };
  };

  config = {
  };
}
