{ stdenv, fetchurl, cmake, libgcrypt, qt4, xorg, ... }:

stdenv.mkDerivation rec {
  name = "keepassx2-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "https://www.keepassx.org/releases/${version}/keepassx-${version}.tar.gz";
    sha256 = "1f1nlbd669rmpzr52d9dgfgclg4jcaq2jkrby3b8q1vjkksdqjr0";
  };

  buildInputs = [ cmake libgcrypt qt4 xorg.libXtst ];

  meta = {
    description = "Qt password manager compatible with its Win32 and Pocket PC versions";
    homepage = http://www.keepassx.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ qknight jgeerds ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
