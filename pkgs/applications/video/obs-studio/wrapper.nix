{ lib, obs-studio, symlinkJoin, makeWrapper }:

{ plugins ? [] }:

symlinkJoin {
  name = "wrapped-${obs-studio.name}";

  nativeBuildInputs = [ makeWrapper ];
  paths = [ obs-studio ] ++ plugins;

  postBuild = with lib;
    let
      # Some plugins needs extra environment, see obs-gstreamer for an example.
      pluginArguments =
        lists.concatMap (plugin: plugin.obsWrapperArguments or []) plugins;

      wrapCommand = [
          "wrapProgram"
          "$out/bin/obs"
          ''--set OBS_PLUGINS_PATH "$out/lib/obs-plugins"''
          ''--set OBS_PLUGINS_DATA_PATH "$out/share/obs/obs-plugins"''
        ] ++ pluginArguments;
    in concatStringsSep " " wrapCommand;

  inherit (obs-studio) meta;
  passthru = obs-studio.passthru // {
    passthru.unwrapped = obs-studio;
  };
}
