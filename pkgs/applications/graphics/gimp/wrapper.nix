{ stdenv, lib, symlinkJoin, gimp, makeWrapper, gimpPlugins, gnome3, plugins ? null}:

let
allPlugins = lib.filter (pkg: builtins.isAttrs pkg && pkg.type == "derivation" && !pkg.meta.broken or false) (lib.attrValues gimpPlugins);
selectedPlugins = if plugins == null then allPlugins else plugins;
extraArgs = map (x: x.wrapArgs or "") selectedPlugins;
versionBranch = stdenv.lib.versions.majorMinor gimp.version;

in symlinkJoin {
  name = "gimp-with-plugins-${gimp.version}";

  paths = [ gimp ] ++ selectedPlugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    for each in gimp-${versionBranch} gimp-console-${versionBranch}; do
      wrapProgram $out/bin/$each \
        --set GIMP2_PLUGINDIR "$out/lib/gimp/2.0" \
        --prefix GTK_PATH : "${gnome3.gnome-themes-extra}/lib/gtk-2.0" \
        ${toString extraArgs}
    done
    set +x
    for each in gimp gimp-console; do
      ln -sf "$each-${versionBranch}" $out/bin/$each
    done
  '';
}
