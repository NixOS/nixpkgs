{ lib, symlinkJoin, glimpse, makeWrapper, glimpsePlugins, gnome, plugins ? null }:

let
  allPlugins = lib.filter (pkg: lib.isDerivation pkg && !pkg.meta.broken or false) (lib.attrValues glimpsePlugins);
  selectedPlugins = if plugins == null then allPlugins else plugins;
  extraArgs = map (x: x.wrapArgs or "") selectedPlugins;
  versionBranch = lib.versions.majorMinor glimpse.version;

in
symlinkJoin {
  name = "glimpse-with-plugins-${glimpse.version}";

  paths = [ glimpse ] ++ selectedPlugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for each in glimpse-${versionBranch} glimpse-console-${versionBranch}; do
      wrapProgram $out/bin/$each \
        --set GIMP2_PLUGINDIR "$out/lib/glimpse/2.0" \
        --set GIMP2_DATADIR "$out/share/glimpse/2.0" \
        --prefix GTK_PATH : "${gnome.gnome-themes-extra}/lib/gtk-2.0" \
        ${toString extraArgs}
    done

    for each in glimpse glimpse-console; do
      ln -sf "$each-${versionBranch}" $out/bin/$each
    done
  '';
}
