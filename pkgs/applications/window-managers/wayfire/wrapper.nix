<<<<<<< HEAD
{ symlinkJoin, lib, makeWrapper, wayfire, plugins ? [ ] }:

symlinkJoin {
  name = "wayfire-wrapped-${lib.getVersion wayfire}";

  nativeBuildInputs = [ makeWrapper ];

  paths = [
    wayfire
  ] ++ plugins;

  postBuild = ''
    for binary in $out/bin/*; do
      wrapProgram $binary \
        --prefix WAYFIRE_PLUGIN_PATH : $out/lib/wayfire \
        --prefix WAYFIRE_PLUGIN_XML_PATH : $out/share/wayfire/metadata
    done
  '';

  preferLocalBuild = true;

  passthru = wayfire.passthru // {
    unwrapped = wayfire;
  };

  meta = wayfire.meta // {
    # To prevent builds on hydra
    hydraPlatforms = [];
    # prefer wrapper over the package
    priority = (wayfire.meta.priority or 0) - 1;
  };
}
=======
{ runCommand, lib, makeWrapper, wayfirePlugins }:

let
  inherit (lib) escapeShellArg makeBinPath;

  xmlPath = plugin: "${plugin}/share/wayfire/metadata/wf-shell";

  makePluginPath = lib.makeLibraryPath;
  makePluginXMLPath = lib.concatMapStringsSep ":" xmlPath;
in

application:

choosePlugins:

let
  plugins = choosePlugins wayfirePlugins;
in

runCommand "${application.name}-wrapped" {
  nativeBuildInputs = [ makeWrapper ];

  passthru = application.passthru // {
    unwrapped = application;
  };

  inherit (application) meta;
} ''
  mkdir -p $out/bin
  for bin in ${application}/bin/*
  do
      makeWrapper "$bin" $out/bin/''${bin##*/} \
          --suffix PATH : ${escapeShellArg (makeBinPath plugins)} \
          --suffix WAYFIRE_PLUGIN_PATH : ${escapeShellArg (makePluginPath plugins)} \
          --suffix WAYFIRE_PLUGIN_XML_PATH : ${escapeShellArg (makePluginXMLPath plugins)}
  done
  find ${application} -mindepth 1 -maxdepth 1 -not -name bin \
      -exec ln -s '{}' $out ';'
''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
