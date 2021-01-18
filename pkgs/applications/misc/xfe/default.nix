{ lib, stdenv, fetchurl, fox, pkg-config, gettext, xlibsWrapper, gcc, intltool, file, libpng }:

stdenv.mkDerivation rec {
  name = "xfe-1.42";

  src = fetchurl {
    url = "mirror://sourceforge/xfe/${name}.tar.gz";
    sha256 = "1v1v0vcbnm30kpyd3rj8f56yh7lfnwy7nbs9785wi229b29fiqx1";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fox gettext xlibsWrapper gcc intltool file libpng ];

  preConfigure = ''
    sed -i s,/usr/share/xfe,$out/share/xfe, src/xfedefs.h
  '';

  enableParallelBuilding = true;

  meta = {
    description = "MS-Explorer like file manager for X";
    longDescription = ''
      X File Explorer (Xfe) is an MS-Explorer like file manager for X.
      It is based on the popular, but discontinued, X Win Commander, which was developed by Maxim Baranov.
      Xfe aims to be the filemanager of choice for all the Unix addicts!
    '';
    homepage = "https://sourceforge.net/projects/xfe/";
    license = lib.licenses.gpl2;
    maintainers = [];
    platforms = lib.platforms.linux;
  };
}
