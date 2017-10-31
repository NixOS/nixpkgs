{ stdenv, lib, symlinkJoin, gimp, makeWrapper, gimpPlugins, plugins ? null}:

let
allPlugins = lib.filter (pkg: builtins.isAttrs pkg && pkg.type == "derivation") (lib.attrValues gimpPlugins);
selectedPlugins = if plugins == null then allPlugins else plugins;
extraArgs = map (x: x.wrapArgs or "") selectedPlugins;

in symlinkJoin {
  name = "gimp-with-plugins-${gimp.version}";

  paths = [ gimp ] ++ selectedPlugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
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
}
