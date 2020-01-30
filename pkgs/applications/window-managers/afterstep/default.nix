{ stdenv, fetchurl, pkgconfig
, libjpeg, libtiff, libpng, freetype
, fltk, gtk
, libX11, libXext, libICE
, dbus
, fetchpatch
}:

stdenv.mkDerivation rec {

  pname = "afterstep";
  version = "2.2.12";
  sourceName = "AfterStep-${version}";

  src = fetchurl {
    urls = [ "ftp://ftp.afterstep.org/stable/${sourceName}.tar.bz2" ];
    sha256 = "1j7vkx1ig4kzwffdxnkqv3kld9qi3sam4w2nhq18waqjsi8xl5gz";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/afterstep/raw/master/debian/patches/44-Fix-build-with-gcc-5.patch";
      sha256 = "1vipy2lzzd2gqrsqk85pwgcdhargy815fxlbn57hsm45zglc3lj4";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libjpeg libtiff libpng freetype fltk gtk libX11 libXext libICE dbus dbus ];

  # A strange type of bug: dbus is not immediately found by pkgconfig
  preConfigure = ''
     export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config dbus-1 --cflags)"
  '';

  meta = with stdenv.lib; {
    description = "A NEXTStep-inspired window manager";
    longDescription = ''
      AfterStep is a window manager for the Unix X Window
      System. Originally based on the look and feel of the NeXTStep
      interface, it provides end users with a consistent, clean, and
      elegant desktop. The goal of AfterStep development is to provide
      for flexibility of desktop configuration, improving aestetics,
      and efficient use of system resources.
    '';
    homepage = http://www.afterstep.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };

}
