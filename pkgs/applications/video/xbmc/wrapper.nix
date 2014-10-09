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
    makeWrapper ${xbmc}/bin/xbmc $out/bin/xbmc \
      --prefix XBMC_HOME : $out/share/xbmc;
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