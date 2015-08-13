{ stdenv, fetchurl, cmake, libgcrypt, qt4, xlibs, ... }:

stdenv.mkDerivation {
  name = "keepassx2-2.0beta1";
  src = fetchurl {
    url = "https://github.com/keepassx/keepassx/archive/2.0-beta1.tar.gz";
    sha256 = "1wnbk9laixz16lmchr1lnv8m9i6rkxv6slnx8f0fyczx90y97qdw";
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
