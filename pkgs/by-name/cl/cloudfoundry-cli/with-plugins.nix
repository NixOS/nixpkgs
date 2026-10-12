{
  lib,
  runCommand,
  symlinkJoin,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  cloudfoundry-cli,
  cloudfoundryCliPlugins,
}:

pluginsFun:

let
  plugins = pluginsFun cloudfoundryCliPlugins;

  # cf reads installed plugins from $CF_PLUGIN_HOME/.cf/plugins/config.json,
  # which holds metadata queried from each plugin binary at install time,
  # so let cf itself populate the plugin home.
  pluginHome =
    runCommand "cloudfoundry-cli-plugin-home"
      {
        nativeBuildInputs = [
          cloudfoundry-cli
          writableTmpDirAsHomeHook
        ];
        # cf talks to the plugin over loopback RPC to read its metadata
        __darwinAllowLocalNetworking = true;
      }
      ''
        mkdir -p $out
        export CF_PLUGIN_HOME=$out
        ${lib.concatMapStringsSep "\n" (p: "cf install-plugin -f ${lib.getExe p}") plugins}
      '';
in
symlinkJoin {
  pname = "cloudfoundry-cli-with-plugins";
  inherit (cloudfoundry-cli) version;
  paths = [ cloudfoundry-cli ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild = ''
    rm $out/bin/cf
    makeWrapper ${lib.getExe cloudfoundry-cli} $out/bin/cf \
      --set-default CF_PLUGIN_HOME ${pluginHome}
  '';
  passthru = {
    inherit pluginHome plugins;
  };
  inherit (cloudfoundry-cli) meta;
}
