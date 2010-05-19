{ stdenv, fetchurl, cmake, pkgconfig, gtk, vte, pixman, gettext, perl }:
stdenv.mkDerivation rec {
  name = "sakura-2.3.8";
  src = fetchurl {
    url = "http://www.pleyades.net/david/projects/sakura/${name}.tar.bz2";
    sha256 = "1gfjh1xxqgna0njh0pd4srnbmj67ir4b13slrdri6bm80shfbz8l";
  };
  buildInputs = [ cmake pkgconfig gtk vte pixman gettext perl ];
  meta = {
    homepage = "http://www.pleyades.net/david/sakura.php";
    description = "A terminal emulator based on GTK and VTE";
    longDescription = ''
      sakura is a terminal emulator based on GTK and VTE. It's a terminal
      emulator with few dependencies, so you don't need a full GNOME desktop
      installed to have a decent terminal emulator. Current terminal emulators
      based on VTE are gnome-terminal, XFCE Terminal, TermIt and a small
      sample program included in the vte sources. The differences between
      sakura and the last one are that it uses a notebook to provide several
      terminals in one window and adds a contextual menu with some basic
      options. No more no less.
    '';
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
