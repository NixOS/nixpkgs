{ obs-studio, symlinkJoin, makeWrapper }:

{ plugins ? [] }:

symlinkJoin {
  name = "wrapped-${obs-studio.name}";

  nativeBuildInputs = [ makeWrapper ];
  paths = [ obs-studio ] ++ plugins;

  postBuild = ''
    wrapProgram $out/bin/obs \
      --set OBS_PLUGINS_PATH      "$out/lib/obs-plugins" \
      --set OBS_PLUGINS_DATA_PATH "$out/share/obs/obs-plugins"
  '';

  inherit (obs-studio) meta;
  passthru = obs-studio.passthru // {
    passthru.unwrapped = obs-studio;
  };
}
