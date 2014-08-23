{ stdenv, fetchurl, cmake, libgcrypt, qt4, xlibs, ... }:

stdenv.mkDerivation {
  name = "keepassx2-2.0alpha5";
  src = fetchurl {
    url = "https://github.com/keepassx/keepassx/archive/2.0-alpha5.tar.gz";
    sha256 = "1vxj306zhrr38mvsy3vpjlg6d0xwlcvsi3l69nhhwzkccsc4smfm";
  };

  buildInputs = [ cmake libgcrypt qt4 xlibs.libXtst ];

  meta = {
    description = "Qt password manager compatible with its Win32 and Pocket PC versions";
    homepage = http://www.keepassx.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; linux;
  };
}
