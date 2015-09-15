{ stdenv, fetchurl, cmake, libgcrypt, qt4, xlibs, ... }:

stdenv.mkDerivation {
  name = "keepassx2-2.0beta2";
  src = fetchurl {
    url = "https://github.com/keepassx/keepassx/archive/2.0-beta2.tar.gz";
    sha256 = "0ljf9ws3wh62zd0gyb0vk2qw6pqsmxrlybrfs5mqahf44q92ca2q";
  };

  buildInputs = [ cmake libgcrypt qt4 xlibs.libXtst ];

  meta = {
    description = "Qt password manager compatible with its Win32 and Pocket PC versions";
    homepage = http://www.keepassx.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ qknight jgeerds ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
