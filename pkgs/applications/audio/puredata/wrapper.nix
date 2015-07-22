{ stdenv, buildEnv, puredata, makeWrapper, plugins }:

let
puredataFlags = map (x: "-path ${x}/") plugins;
drv = buildEnv {
  name = "puredata-with-plugins-" + (builtins.parseDrvName puredata.name).version;

  paths = [ puredata ] ++ plugins;

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${puredata}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    wrapProgram $out/bin/pd \
      --add-flags "${toString puredataFlags}"
  '';
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })
