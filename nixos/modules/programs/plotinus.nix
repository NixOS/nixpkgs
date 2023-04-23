{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.plotinus;
in
{
  meta = {
    maintainers = pkgs.plotinus.meta.maintainers;
    doc = ./plotinus.md;
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
