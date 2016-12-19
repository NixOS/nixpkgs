{ stdenv, fetchurl, cmake, pkgconfig, gtk3, perl, vte, pcre, glib }:

stdenv.mkDerivation rec {
  name = "sakura-${version}";
  version = "3.3.4";

  src = fetchurl {
    url = "http://launchpad.net/sakura/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "1fnkrkzf2ysav1ljgi4y4w8kvbwiwgmg1462xhizlla8jqa749r7";
  };

  nativeBuildInputs = [ cmake perl pkgconfig ];

  buildInputs = [ gtk3 vte pcre glib ];

  meta = with stdenv.lib; {
    description = "A terminal emulator based on GTK and VTE";
    homepage    = http://www.pleyades.net/david/projects/sakura;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ astsmtl codyopel ];
    platforms   = platforms.linux;
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
  };
}
