{ stdenv, fetchurl, cmake, libgcrypt, qt4, xorg, ... }:

stdenv.mkDerivation rec {
  name = "keepassx2-${version}";
  version = "2.0";

  src = fetchurl {
    url = "https://www.keepassx.org/releases/${version}/keepassx-${version}.tar.gz";
    sha256 = "1ri2r1sldc62hbg74m4pmci0nrjwvv38rqhyzhyjin247an0zd0f";
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
