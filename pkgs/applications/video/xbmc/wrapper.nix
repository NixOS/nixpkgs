{ stdenv, lib, makeWrapper, xbmc, plugins }:

let

  p = builtins.parseDrvName xbmc.name;

in

stdenv.mkDerivation {

  name = "xbmc-" + p.version;
  version = p.version;

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/share/xbmc/addons/packages
    ${stdenv.lib.concatMapStrings
        (plugin: "ln -s ${plugin.out
                            + plugin.xbmcPlugin
                            + "/" + plugin.namespace
                          } $out/share/xbmc/addons/.;") plugins}
    $(for plugin in ${xbmc}/share/xbmc/addons/*
    do
      $(ln -s $plugin/ $out/share/xbmc/addons/.)
    done)
    $(for share in ${xbmc}/share/xbmc/*
    do
      $(ln -s $share $out/share/xbmc/.)
    done)
    $(for passthrough in icons xsessions applications
    do
      ln -s ${xbmc}/share/$passthrough $out/share/
    done)
    $(for exe in xbmc{,-standalone}
    do
    makeWrapper ${xbmc}/bin/$exe $out/bin/$exe \
      --prefix XBMC_HOME : $out/share/xbmc;
    done)
  '';

  preferLocalBuilds = true;

  meta = with xbmc.meta; {
    inherit license homepage;
    description = description
                + " (with plugins: "
                + lib.concatStrings (lib.intersperse ", " (map (x: ""+x.name) plugins))
                + ")";

  };

}