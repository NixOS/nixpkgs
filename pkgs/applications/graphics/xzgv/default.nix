{ stdenv, fetchurl, gtk, pkgconfig, texinfo }:

stdenv.mkDerivation rec {
  name = "xzgv-${version}";
  version = "0.9.1";
  src = fetchurl {
    url = "mirror://sourceforge/xzgv/xzgv-${version}.tar.gz";
    sha256 = "1rh432wnvzs434knzbda0fslhfx0gngryrrnqkfm6gwd2g5mxcph";
  };
  buildInputs = [ gtk pkgconfig texinfo ];
  patches = [ ./fix-linker-paths.patch ];
  postPatch = ''
    substituteInPlace config.mk \
      --replace /usr/local $out
    substituteInPlace config.mk \
      --replace "CFLAGS=-O2 -Wall" "CFLAGS=-Wall"
    substituteInPlace Makefile \
      --replace "all: src man" "all: src man info"
  '';
  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/projects/xzgv/;
    description = "Picture viewer for X with a thumbnail-based selector";
    license = licenses.gpl2;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
