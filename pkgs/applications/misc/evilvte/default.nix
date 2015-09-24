{ stdenv, fetchgit, makeWrapper, pkgconfig,
  gnome, glib, pango, cairo, gdk_pixbuf, atk, freetype, xorg,
  configH
}:

stdenv.mkDerivation rec {
  name = "evilvte-${version}";
  version = "0.5.2-20140827";

  src = fetchgit {
    url = https://github.com/caleb-/evilvte.git;
    rev = "8dfa41e26bc640dd8d8c7317ff7d04e3c01ded8a";
    sha256 = "70f1d4234d077121e2223a735d749d1b53f0b84393507b635b8a37c3716e94d3";
  };

  buildInputs = [
    gnome.vte glib pango gnome.gtk cairo gdk_pixbuf atk freetype xorg.libX11
    xorg.xproto xorg.kbproto xorg.libXext xorg.xextproto makeWrapper pkgconfig
  ];

  buildPhase = ''
    cat >src/config.h <<EOF
    ${configH}
    EOF
    make
  '';

  meta = with stdenv.lib; {
    description = "VTE based, highly customizable terminal emulator";
    homepage = http://www.calno.com/evilvte;
    license = licenses.gpl2;
    maintainers = [ maintainers.bodil ];
    platforms = platforms.linux;
  };
}
