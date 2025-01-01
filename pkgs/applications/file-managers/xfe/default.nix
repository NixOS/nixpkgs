{
  lib,
  stdenv,
  fetchurl,
  fox,
  fontconfig,
  freetype,
  pkg-config,
  gettext,
  xcbutil,
  gcc,
  intltool,
  file,
  libpng,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "xfe";
  version = "1.46.2";

  src = fetchurl {
    url = "mirror://sourceforge/xfe/xfe-${version}.tar.xz";
    sha256 = "sha256-6hNNda4BKCY9E02uFYJnt0JySNp/is1ZqjFlOwQcRWs=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [
    fox
    gettext
    xcbutil
    gcc
    file
    libpng
    fontconfig
    freetype
    xorg.libX11
    xorg.libXft
  ];

  preConfigure = ''
    sed -i s,/usr/share/xfe,$out/share/xfe, src/xfedefs.h
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "MS-Explorer like file manager for X";
    longDescription = ''
      X File Explorer (Xfe) is an MS-Explorer like file manager for X.
      It is based on the popular, but discontinued, X Win Commander, which was developed by Maxim Baranov.
      Xfe aims to be the filemanager of choice for all the Unix addicts!
    '';
    homepage = "https://sourceforge.net/projects/xfe/";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
