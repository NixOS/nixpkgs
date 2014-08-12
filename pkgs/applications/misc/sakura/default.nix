{ stdenv, fetchurl, cmake, pkgconfig, gtk, vte, pixman, gettext, perl }:
stdenv.mkDerivation rec {
  name = "sakura-${version}";
  version = "2.4.2";
  src = fetchurl {
    url = "http://launchpad.net/sakura/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "1mpsjsk7dgz56h7yagd9aq0d92vj59yrz4ri6za3mfmglhn29rn5";
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
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
