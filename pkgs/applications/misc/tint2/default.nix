{ stdenv, fetchurl, pkgconfig, cmake, pango, cairo, glib, imlib2, libXinerama
, libXrender, libXcomposite, libXdamage, libX11, libXrandr, gtk, libpthreadstubs
, libXdmcp, librsvg, fetchgit
}:

stdenv.mkDerivation rec {
  name = "tint2-${version}";
  version = "0.12";

  src = fetchgit {
    url = "https://gitlab.com/o9000/tint2.git";
    rev = version;
    sha256 = "0pd84ydpqz2l6gkhj565nqi2xyiph8zfpn4xha60xshqpsg3pqjq";
  };
        
  buildInputs = [ pkgconfig cmake pango cairo glib imlib2 libXinerama
    libXrender libXcomposite libXdamage libX11 libXrandr gtk libpthreadstubs
    libXdmcp librsvg
  ];

  preConfigure =
    ''
      substituteInPlace CMakeLists.txt --replace /etc $out/etc
    '';
  prePatch =
    ''
      substituteInPlace ./src/tint2conf/properties.c --replace /usr/share/ /run/current-system/sw/share/
      substituteInPlace ./src/launcher/apps-common.c --replace /usr/share/ /run/current-system/sw/share/
      substituteInPlace ./src/launcher/icon-theme-common.c --replace /usr/share/ /run/current-system/sw/share/
    '';

  cmakeFlags = [
    "-DENABLE_TINT2CONF=0"
    "-DENABLE_SN=0"
  ];

  meta = {
    homepage = https://gitlab.com/o9000/tint2;
    license = stdenv.lib.licenses.gpl2;
    description = "A simple panel/taskbar unintrusive and light (memory / cpu / aestetic)";
    platforms = stdenv.lib.platforms.linux;
  };
}
