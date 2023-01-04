{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.plotinus;
in
{
  meta = {
    maintainers = pkgs.plotinus.meta.maintainers;
    # Don't edit the docbook xml directly, edit the md and generate it:
    # `pandoc plotinus.md -t docbook --top-level-division=chapter --extract-media=media -f markdown+smart --lua-filter ../../../doc/build-aux/pandoc-filters/myst-reader/roles.lua --lua-filter ../../../doc/build-aux/pandoc-filters/docbook-writer/rst-roles.lua > plotinus.xml`
    doc = ./plotinus.xml;
  };

  ###### interface

  options = {
    programs.plotinus = {
      enable = mkOption {
        default = false;
        description = lib.mdDoc ''
          Whether to enable the Plotinus GTK 3 plugin. Plotinus provides a
          popup (triggered by Ctrl-Shift-P) to search the menus of a
          compatible application.
        '';
        type = types.bool;
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.sessionVariables.XDG_DATA_DIRS = [ "${pkgs.plotinus}/share/gsettings-schemas/${pkgs.plotinus.name}" ];
    environment.variables.GTK3_MODULES = [ "${pkgs.plotinus}/lib/libplotinus.so" ];
  };
}
