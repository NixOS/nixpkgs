{ stdenv, cmake, fetchurl, pkgconfig, qt5, boost, exiv2, fftwFloat, gsl
, ilmbase, lcms2, libraw, libtiff, openexr
}:

stdenv.mkDerivation rec {
  name = "luminance-hdr-2.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/qtpfsgui/${name}.tar.bz2";
    sha256 = "00fldbcizrx8jcnjgq74n3zmbm27dxzl96fxa7q49689mfnlw08l";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  buildInputs = [ qt5 boost exiv2 fftwFloat gsl ilmbase lcms2 libraw libtiff openexr ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://qtpfsgui.sourceforge.net/;
    description = "A complete open source solution for HDR photography";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.hrdinka ];
  };
}
