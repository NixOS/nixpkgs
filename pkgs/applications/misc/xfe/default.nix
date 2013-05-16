{ stdenv, fetchurl, fox, pkgconfig, gettext, x11, gcc, intltool, file, libpng }:

let
  version = "1.33";
in

stdenv.mkDerivation rec {
  name = "xfe-${version}";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/xfe/xfe/${version}/${name}.tar.gz";
    md5 = "fb089ba73add411b08a6560eeb51742d";
  };

  buildInputs = [ fox pkgconfig gettext x11 gcc intltool file libpng ];

  preConfigure = ''
    sed -i s,/usr/share/xfe,$out/share/xfe, src/xfedefs.h
  '';

  enableParallelBuilding = true;

  meta = {
    description = "X File Explorer (Xfe) is an MS-Explorer like file manager for X.";
    longDescription = ''
      X File Explorer (Xfe) is an MS-Explorer like file manager for X.
      It is based on the popular, but discontinued, X Win Commander, which was developed by Maxim Baranov.
      Xfe aims to be the filemanager of choice for all the Unix addicts!
    '';
    homepage = "http://sourceforge.net/projects/xfe/";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.all;
  };
}
