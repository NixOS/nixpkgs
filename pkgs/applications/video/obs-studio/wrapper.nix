{ lib, obs-studio, symlinkJoin, makeWrapper }:

{ plugins ? [] }:

symlinkJoin {
  name = "wrapped-${obs-studio.name}";

  nativeBuildInputs = [ makeWrapper ];
  paths = [ obs-studio ];

  postBuild = with lib;
    let
      # Some plugins needs extra environment, see obs-gstreamer for an example.
      pluginArguments =
        lists.concatMap (plugin: plugin.obsWrapperArguments or []) plugins;

      pluginsJoined = symlinkJoin {
        name = "obs-studio-plugins";
        paths = lists.map (plugin: "${plugin}/lib/obs-plugins") plugins;
      };

      pluginsDataJoined = symlinkJoin {
        name = "obs-studio-plugins-data";
        paths = lists.map (plugin: "${plugin}/share/obs/obs-plugins") plugins;
      };

      wrapCommand = [
          "wrapProgram"
          "$out/bin/obs"
          ''--set OBS_PLUGINS_PATH "${pluginsJoined}"''
          ''--set OBS_PLUGINS_DATA_PATH "${pluginsDataJoined}"''
        ] ++ pluginArguments;
    in concatStringsSep " " wrapCommand;

  inherit (obs-studio) meta;
  passthru = obs-studio.passthru // {
    passthru.unwrapped = obs-studio;
  };
}
