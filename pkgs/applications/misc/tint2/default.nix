{ stdenv, fetchurl, pkgconfig, cmake, pango, cairo, glib, imlib2, libXinerama
, libXrender, libXcomposite, libXdamage, libX11, libXrandr, gtk, libpthreadstubs
, libXdmcp
}:

stdenv.mkDerivation rec {
  name = "tint2-${version}";
  version = "0.11";

  src = fetchurl {
    url = "http://tint2.googlecode.com/files/${name}.tar.bz2";
    sha256 = "07a74ag7lhc6706z34zvqj2ikyyl7wnzisfxpld67ljpc1m6w47y";
  };
        
  buildInputs = [ pkgconfig cmake pango cairo glib imlib2 libXinerama
    libXrender libXcomposite libXdamage libX11 libXrandr gtk libpthreadstubs
    libXdmcp
  ];

  preConfigure = "substituteInPlace CMakeLists.txt --replace /etc $out/etc";

  cmakeFlags = [
    "-DENABLE_TINT2CONF=0"
  ];

  meta = {
    homepage = http://code.google.com/p/tint2;
    license = stdenv.lib.licenses.gpl2;
    description = "A simple panel/taskbar unintrusive and light (memory / cpu / aestetic)";
    platforms = stdenv.lib.platforms.linux;
  };
}
