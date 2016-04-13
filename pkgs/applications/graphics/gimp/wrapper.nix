{ stdenv, lib, buildEnv, gimp, makeWrapper, gimpPlugins, plugins ? null}:

let
allPlugins = lib.filter (pkg: builtins.isAttrs pkg && pkg.type == "derivation") (lib.attrValues gimpPlugins);
selectedPlugins = if plugins == null then allPlugins else plugins;
extraArgs = map (x: x.wrapArgs or "") selectedPlugins;

drv = buildEnv {
  name = "gimp-with-plugins-" + (builtins.parseDrvName gimp.name).version;

  paths = [ gimp ] ++ selectedPlugins;

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${gimp}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    for each in gimp-2.8 gimp-console-2.8; do
      wrapProgram $out/bin/$each \
        --set GIMP2_PLUGINDIR "$out/lib/gimp/2.0" \
        ${toString extraArgs}
    done
    set +x
    for each in gimp gimp-console; do
      ln -sf "$each-2.8" $out/bin/$each
    done
  '';
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })
