{ stdenv, fetchurl, glib, gtk2, pkgconfig, popt }:

let
  version = "0.9.2";
in

stdenv.mkDerivation rec {
  name = "gmrun-${version}";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/gmrun/gmrun/${version}/${name}.tar.gz";
    md5 = "6cef37a968006d9496fc56a7099c603c";
  };

  buildInputs = [ glib gtk2 pkgconfig popt ];

  doCheck = true;

  enableParallelBuilding = true;

  patches = [
      ./gcc43.patch
      ./gmrun-0.9.2-xdg.patch
    ];

  meta = {
    description = "Gnome Completion-Run Utility.";
    longDescription = ''
      A simple program which provides a "run program" window, featuring a bash-like TAB completion.
      It uses GTK+ interface.
      Also, supports CTRL-R / CTRL-S / "!" for searching through history.
      Running commands in a terminal with CTRL-Enter. URL handlers.
    '';
    homepage = "http://sourceforge.net/projects/gmrun/";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.all;
  };
}
