{ stdenv, fetchurl, alsaLib, cmake, jack2, fftw, fltk13, libjpeg
, minixml, pkgconfig, zlib
}:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "2.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/zynaddsubfx-${version}.tar.xz";
    sha256 = "15byz08p5maf3v8l1zz11xan6s0qcfasjf1b81xc8rffh13x5f53";
  };

  buildInputs = [ alsaLib jack2 fftw fltk13 libjpeg minixml zlib ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "High quality software synthesizer";
    homepage = http://zynaddsubfx.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
