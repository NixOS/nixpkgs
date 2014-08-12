{ stdenv, fetchurl, fox, pkgconfig, gettext, x11, gcc, intltool, file, libpng }:

stdenv.mkDerivation rec {
  name = "xfe-1.34";

  src = fetchurl {
    url = "mirror://sourceforge/xfe/${name}.tar.gz";
    sha256 = "0y6gi8vdvw1prz7dv7wadf7v8gl6g75jrlrl5jnsb71l1431ncay";
  };

  buildInputs = [ fox pkgconfig gettext x11 gcc intltool file libpng ];

  preConfigure = ''
    sed -i s,/usr/share/xfe,$out/share/xfe, src/xfedefs.h
  '';

  enableParallelBuilding = true;

  meta = {
    description = "X File Explorer (Xfe) is an MS-Explorer like file manager for X";
    longDescription = ''
      X File Explorer (Xfe) is an MS-Explorer like file manager for X.
      It is based on the popular, but discontinued, X Win Commander, which was developed by Maxim Baranov.
      Xfe aims to be the filemanager of choice for all the Unix addicts!
    '';
    homepage = "http://sourceforge.net/projects/xfe/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.linux;
  };
}
