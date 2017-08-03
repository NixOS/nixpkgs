{ stdenv, fetchurl, gtk2, libXft, intltool, automake115x, autoconf, libtool, pkgconfig }:

stdenv.mkDerivation {
  name = "pcmanx-gtk2-1.3";
  src = fetchurl {
    url = "https://github.com/pcman-bbs/pcmanx/archive/1.3.tar.gz";
    sha256 = "2e5c59f6b568036f2ad6ac67ca2a41dfeeafa185451e507f9fb987d4ed9c4302";
  };

  buildInputs = [ gtk2 libXft intltool automake115x autoconf libtool pkgconfig ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://pcman.ptt.cc;
    license = licenses.gpl2;
    description = "Telnet BBS browser with GTK+ interface";
    maintainers = [ maintainers.mingchuan ];
    platforms = platforms.linux;
  };
}
