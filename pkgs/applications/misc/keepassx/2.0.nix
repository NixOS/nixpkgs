{ stdenv, fetchurl, cmake, libgcrypt, qt4, xlibs, ... }:

stdenv.mkDerivation {
  name = "keepassx2-2.0alpha6";
  src = fetchurl {
    url = "https://github.com/keepassx/keepassx/archive/2.0-alpha6.tar.gz";
    sha256 = "592f9995b13c4f84724fb24a0078162246397eedccd467daaf0fd3608151f2b0";
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
