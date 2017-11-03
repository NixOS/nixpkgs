{ stdenv, fetchurl, cmake, libgcrypt, qt4, xorg, ... }:

stdenv.mkDerivation rec {
  name = "keepassx2-${version}";
  version = "2.0.3";

  src = fetchurl {
    url = "https://www.keepassx.org/releases/${version}/keepassx-${version}.tar.gz";
    sha256 = "1ia7cqx9ias38mnffsl7da7g1f66bcbjsi23k49sln0c6spb9zr3";
  };

  buildInputs = [ cmake libgcrypt qt4 xorg.libXtst ];

  meta = {
    description = "Qt password manager compatible with its Win32 and Pocket PC versions";
    homepage = https://www.keepassx.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ qknight jgeerds ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
