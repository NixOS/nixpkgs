{ stdenv, fetchurl, pkgconfig
, libjpeg, libtiff, libpng, freetype
, fltk, gtk
, libX11, libXext, libICE
, dbus, dbus_libs
}:

stdenv.mkDerivation rec {

  name = "afterstep-${version}";
  version = "2.2.12";
  sourceName = "AfterStep-${version}";

  src = fetchurl {
    urls = [ "ftp://ftp.afterstep.org/stable/${sourceName}.tar.bz2" ];
    sha256 = "1j7vkx1ig4kzwffdxnkqv3kld9qi3sam4w2nhq18waqjsi8xl5gz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libjpeg libtiff libpng freetype fltk gtk libX11 libXext libICE dbus dbus_libs ];

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
