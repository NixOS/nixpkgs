{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  options = {
    qtPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
      description = ''
        Plugin packages for Qt such as input methods.
      '';
    };
  };

  config = {
    environment.variables = if builtins.length config.qtPlugins > 0
      then
        let
          paths = [ pkgs.qt48 ] ++ config.qtPlugins;
          env = pkgs.buildEnv {
            name = "qt-plugin-env";

            inherit paths;

            postBuild = lib.concatStringsSep "\n"
              (map (d: d.qtPluginEnvPostBuild or "") paths);

            ignoreCollisions = true;
          };
        in {
          QT_PLUGIN_PATH = [ (builtins.toString env) ];
        }
      else {};
  };
}
