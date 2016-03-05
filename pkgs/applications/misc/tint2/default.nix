{ stdenv, fetchFromGitLab, pkgconfig, cmake, pango, cairo, glib, imlib2, libXinerama
, libXrender, libXcomposite, libXdamage, libX11, libXrandr, gtk, libpthreadstubs
, libXdmcp, librsvg, libstartup_notification
}:

stdenv.mkDerivation rec {
  name = "tint2-${version}";
  version = "0.12.7";

  src = fetchFromGitLab {
    owner = "o9000";
    repo = "tint2";
    rev = version;
    sha256 = "01wb1yy7zfi01fl34yzpn1d30fykcf8ivmdlynnxp5znqrdsqm2r";
  };

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig cmake pango cairo glib imlib2 libXinerama
    libXrender libXcomposite libXdamage libX11 libXrandr gtk libpthreadstubs
    libXdmcp librsvg libstartup_notification
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

  meta = {
    homepage = https://gitlab.com/o9000/tint2;
    license = stdenv.lib.licenses.gpl2;
    description = "A simple panel/taskbar unintrusive and light (memory / cpu / aestetic)";
    platforms = stdenv.lib.platforms.linux;
  };
}
