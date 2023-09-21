{ lib, symlinkJoin, makeWrapper, gimpPlugins, gnome, plugins ? null}:

let
inherit (gimpPlugins) gimp;
allPlugins = lib.filter (pkg: lib.isDerivation pkg && !pkg.meta.broken or false) (lib.attrValues gimpPlugins);
selectedPlugins = lib.filter (pkg: pkg != gimp) (if plugins == null then allPlugins else plugins);
extraArgs = map (x: x.wrapArgs or "") selectedPlugins;
versionBranch = lib.versions.majorMinor gimp.version;

in symlinkJoin {
  name = "gimp-with-plugins-${gimp.version}";

  paths = [ gimp ] ++ selectedPlugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for each in gimp-${versionBranch} gimp-console-${versionBranch}; do
      wrapProgram $out/bin/$each \
        --set GIMP2_PLUGINDIR "$out/lib/gimp/2.0" \
        --set GIMP2_DATADIR "$out/share/gimp/2.0" \
        --prefix GTK_PATH : "${gnome.gnome-themes-extra}/lib/gtk-2.0" \
        ${toString extraArgs}
    done
    set +x
    for each in gimp gimp-console; do
      ln -sf "$each-${versionBranch}" $out/bin/$each
    done
  '';

  inherit (gimp) meta;
}
