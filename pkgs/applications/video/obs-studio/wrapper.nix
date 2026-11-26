{
  lib,
  obs-studio,
  symlinkJoin,
  makeWrapper,
}:

{
  plugins ? [ ],
}:

symlinkJoin {
  name = "wrapped-${obs-studio.name}";

  nativeBuildInputs = [ makeWrapper ];
  paths = [ obs-studio ] ++ plugins;

  postBuild =
    let
      # Some plugins needs extra environment, see obs-gstreamer for an example.
      pluginArguments = lib.lists.concatMap (plugin: plugin.obsWrapperArguments or [ ]) plugins;

      pluginsJoined = symlinkJoin {
        name = "obs-studio-plugins";
        paths = plugins;
      };

      wrapCommandLine = [
        "wrapProgram"
        "$out/bin/obs"
        # Plugins in the new layout, see below
        ''--set OBS_PLUGINS_PATH "$out/lib/obs-studio-plugins"''
        # Plugins in the legacy layout (lib/obs-plugins/<plugin>.so)
        ''--set OBS_LEGACY_PLUGINS_PATH "${pluginsJoined}/lib/obs-plugins"''
        ''--set OBS_LEGACY_PLUGINS_DATA_PATH "${pluginsJoined}/share/obs/obs-plugins"''
      ]
      ++ lib.lists.unique pluginArguments;
    in
    # Plugins in the new layout install lib/obs-modules/plugins/<plugin>.so
    # and share/obs/obs-modules/plugins/<plugin>, but OBS_PLUGINS_PATH
    # expects <plugin>/<plugin>.so and <plugin>/data
    ''
      mkdir -p $out/lib/obs-studio-plugins
      for module in ${pluginsJoined}/lib/obs-modules/plugins/*.so; do
        [ -e "$module" ] || continue
        name=$(basename "$module" .so)
        mkdir "$out/lib/obs-studio-plugins/$name"
        ln -s "$module" "$out/lib/obs-studio-plugins/$name/$name.so"
        data="${pluginsJoined}/share/obs/obs-modules/plugins/$name"
        if [ -d "$data" ]; then
          ln -s "$data" "$out/lib/obs-studio-plugins/$name/data"
        fi
      done

      ${lib.concatStringsSep " " wrapCommandLine}

      # Remove unused obs-plugins dir to not cause confusion
      rm -rf $out/share/obs/obs-plugins
      # Leave some breadcrumbs
      echo 'Plugins are at ${pluginsJoined}/share/obs/obs-plugins' > $out/share/obs/obs-plugins-README
    '';

  inherit (obs-studio) meta;
  passthru = obs-studio.passthru // {
    passthru.unwrapped = obs-studio;
  };
}
