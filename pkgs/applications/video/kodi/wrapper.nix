{ stdenv, lib, makeWrapper, kodi, plugins }:

let

  p = builtins.parseDrvName kodi.name;

in

stdenv.mkDerivation {

  name = "kodi-" + p.version;
  version = p.version;

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/share/kodi/addons
    ${stdenv.lib.concatMapStrings
        (plugin: "ln -s ${plugin.out
                            + plugin.kodiPlugin
                            + "/" + plugin.namespace
                          } $out/share/kodi/addons/.;") plugins}
    $(for plugin in ${kodi}/share/kodi/addons/*
    do
      $(ln -s $plugin/ $out/share/kodi/addons/.)
    done)
    $(for share in ${kodi}/share/kodi/*
    do
      $(ln -s $share $out/share/kodi/.)
    done)
    $(for passthrough in icons xsessions applications
    do
      ln -s ${kodi}/share/$passthrough $out/share/
    done)
    $(for exe in kodi{,-standalone}
    do
    makeWrapper ${kodi}/bin/$exe $out/bin/$exe \
      --prefix KODI_HOME : $out/share/kodi;
    done)
  '';

  preferLocalBuilds = true;

  meta = with kodi.meta; {
    inherit license homepage;
    description = description
                + " (with plugins: "
                + lib.concatStrings (lib.intersperse ", " (map (x: ""+x.name) plugins))
                + ")";

    platforms = stdenv.lib.platforms.linux;
  };

}
