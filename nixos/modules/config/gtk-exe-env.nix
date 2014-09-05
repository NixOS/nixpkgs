{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  options = {
    gtkPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
      description = ''
        Plugin packages for GTK+ such as input methods.
      '';
    };
  };

  config = {
    environment.variables = if builtins.length config.gtkPlugins > 0
      then
        let
          paths = [ pkgs.gtk2 pkgs.gtk3 ] ++ config.gtkPlugins;
          env = pkgs.buildEnv {
            name = "gtk-exe-env";

            inherit paths;

            postBuild = lib.concatStringsSep "\n"
              (map (d: d.gtkExeEnvPostBuild or "") paths);

            ignoreCollisions = true;
          };
        in {
          GTK_EXE_PREFIX = builtins.toString env;
          GTK_PATH = [
            "${env}/lib/gtk-2.0"
            "${env}/lib/gtk-3.0"
          ];
        }
      else {};
  };
}
