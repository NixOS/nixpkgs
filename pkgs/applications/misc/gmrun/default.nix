{ stdenv, fetchurl, glib, gtk2, pkgconfig, popt }:

let
  version = "0.9.2";
in

stdenv.mkDerivation rec {
  name = "gmrun-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gmrun/${name}.tar.gz";
    sha256 = "180z6hbax1qypy5cyy2z6nn7fzxla4ib47ck8mqwr714ag77na8p";
  };

  buildInputs = [ glib gtk2 pkgconfig popt ];

  doCheck = true;

  enableParallelBuilding = true;

  patches = [
      ./gcc43.patch
      ./gmrun-0.9.2-xdg.patch
    ];

  meta = {
    description = "Gnome Completion-Run Utility";
    longDescription = ''
      A simple program which provides a "run program" window, featuring a bash-like TAB completion.
      It uses GTK+ interface.
      Also, supports CTRL-R / CTRL-S / "!" for searching through history.
      Running commands in a terminal with CTRL-Enter. URL handlers.
    '';
    homepage = https://sourceforge.net/projects/gmrun/;
    license = "GPL";
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
