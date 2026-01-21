{
  lib,
  symlinkJoin,
  makeWrapper,
  gimpPlugins,
  gnome-themes-extra,
  plugins ? null,
}:

let
  inherit (gimpPlugins) gimp;
  allPlugins = lib.filter (pkg: lib.isDerivation pkg && !pkg.meta.broken or false) (
    lib.attrValues gimpPlugins
  );
  selectedPlugins = lib.filter (pkg: pkg != gimp) (if plugins == null then allPlugins else plugins);
  extraArgs =
    map (x: x.wrapArgs or "") selectedPlugins
    ++ lib.optionals (gimp.majorVersion == "2.0") [
      ''--prefix GTK_PATH : "${gnome-themes-extra}/lib/gtk-2.0"''
    ];
  exeVersion =
    if gimp.majorVersion == "2.0" then lib.versions.majorMinor gimp.version else gimp.majorVersion;
  majorVersion = lib.versions.major gimp.version;

in
symlinkJoin {
  name = "gimp-with-plugins-${gimp.version}";
  outputs = [
    "out"
    "man"
  ];

  paths = [ gimp ] ++ selectedPlugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for each in gimp-${exeVersion} gimp-console-${exeVersion}; do
      wrapProgram $out/bin/$each \
        --set GIMP${majorVersion}_PLUGINDIR "$out/${gimp.targetLibDir}" \
        --set GIMP${majorVersion}_DATADIR "$out/${gimp.targetDataDir}" \
        ${toString extraArgs}
    done
    set +x
    for each in gimp gimp-console; do
      ln -sf "$each-${exeVersion}" $out/bin/$each
    done

    ln -s ${gimp.man} $man
  '';

  inherit (gimp) meta;
}
