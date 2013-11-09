{ stdenv, fetchurl, pkgconfig, bzip2, curl, expat, fribidi
, libunibreak, qt4, sqlite, zlib }:

stdenv.mkDerivation {
  name = "fbreader-0.99.4";

  src = fetchurl {
    url = http://fbreader.org/files/desktop/fbreader-sources-0.99.4.tgz;
    sha256 = "1sdq3vvwkq4bkyrvh0p884d66gaddz8hlab3m798ji9ixbak2z1x";
  };

  buildInputs = [
    pkgconfig bzip2 curl expat fribidi libunibreak
    qt4 sqlite zlib
  ];

  makeFlags = "INSTALLDIR=$(out)";

  patchPhase = ''
    # don't try to use ccache
    substituteInPlace makefiles/arch/desktop.mk \
      --replace "CCACHE = " "# CCACHE = "
  
    substituteInPlace fbreader/desktop/Makefile \
      --replace "/usr/share" "$out/share"
  '';

  meta = with stdenv.lib; {
    description = "An e-book reader for Linux";
    homepage = http://www.fbreader.org/;
    license = licenses.gpl3;
    platforms = platforms.linux; # possibly also on unix general
    maintainer = [ maintainers.coroa ];
  }; 
}
