{ stdenv, fetchurl, libX11, libXinerama, libXrandr, libXft, yacc, pkgconfig }:

stdenv.mkDerivation rec {
  name = "cwm-5.6";

  src = fetchurl {
    url = "https://github.com/chneukirchen/cwm/archive/v5.6.tar.gz";
    sha256 = "0986i83i3pg23ffzrdb3h931vwh1rp64sqy5pa9hzk0n2yxj0qq0";
  };

  buildInputs = [ libX11 libXinerama libXrandr libXft yacc pkgconfig ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = with stdenv.lib; {
    description = "a lightweight and efficient window manager for X11";
    homepage = "https://github.com/chneukirchen/cwm";
    maintainers = [];
    license     = licenses.isc;
    platforms   = platforms.linux;
  };
}
