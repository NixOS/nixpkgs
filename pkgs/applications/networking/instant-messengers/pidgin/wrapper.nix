{ stdenv, buildEnv, pidgin, makeWrapper, plugins }:

let drv = buildEnv {
  name = "${pidgin.name}-with-plugins";

  paths = [ pidgin ] ++ plugins;

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${pidgin}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    wrapProgram $out/bin/pidgin \
      --suffix-each PURPLE_PLUGIN_PATH ':' "$out/lib/purple-${pidgin.majorVersion} $out/lib/pidgin"
  '';
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })