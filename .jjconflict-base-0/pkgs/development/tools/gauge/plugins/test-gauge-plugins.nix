{
  runCommand,
  gauge,
  lib,
}:

/**
  Creates a gauge install with all given plugins and makes sure every plugin is loaded.
*/
{ plugins }:

let
  gaugeWithPlugins = gauge.withPlugins (_: plugins);
in

runCommand "gauge-test" { nativeBuildInputs = [ gaugeWithPlugins ]; } ''
  mkdir $out
  echo $(gauge install || true) > $out/output.txt

  function checkPlugin() {
    plugin="$1"
    version="$2"

    echo Checking for plugin $plugin version $version
    if ! grep "$plugin ($version)" $out/output.txt
    then
      echo "Couldn't find plugin $plugin version $version"
      exit 1
    fi
  }

  ${lib.concatMapStringsSep "\n" (
    p: "checkPlugin '${lib.removePrefix "gauge-plugin-" p.pname}' '${p.version}'"
  ) plugins}
''
