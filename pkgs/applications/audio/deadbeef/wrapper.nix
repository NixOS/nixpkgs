{ stdenv, buildEnv, deadbeef, makeWrapper, plugins }:

let
drv = buildEnv {
  name = "deadbeef-with-plugins-" + (builtins.parseDrvName deadbeef.name).version;

  paths = [ deadbeef ] ++ plugins;

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${deadbeef}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    wrapProgram $out/bin/deadbeef \
      --set DEADBEEF_PLUGIN_DIR "$out/lib/deadbeef"
  '';
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })
