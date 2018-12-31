{ stdenv, fetchurl, bzip2, qt4, qmake4Hook, libX11, xorgproto, libXtst }:

stdenv.mkDerivation rec {
  name = "keepassx-${version}";
  version = "0.4.4";

  src = fetchurl {
    url = "https://www.keepassx.org/releases/${version}/${name}.tar.gz";
    sha256 = "1i5dq10x28mg7m4c0yacm32xfj4j7imir4ph8x9p0s2ym260c9ry";
  };

  patches = [ ./random.patch ];

  buildInputs = [ bzip2 qt4 libX11 xorgproto libXtst ];

  nativeBuildInputs = [ qmake4Hook ];

  meta = {
    description = "Qt password manager compatible with its Win32 and Pocket PC versions";
    homepage = https://www.keepassx.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ qknight jgeerds ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
