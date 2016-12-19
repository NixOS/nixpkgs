{ stdenv, cmake, fetchurl, fetchpatch, pkgconfig, boost, exiv2, fftwFloat, gsl
, ilmbase, lcms2, libraw, libtiff, openexr
, qtbase, qtdeclarative, qttools, qtwebkit
}:

stdenv.mkDerivation rec {
  name = "luminance-hdr-2.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/qtpfsgui/${name}.tar.bz2";
    sha256 = "00fldbcizrx8jcnjgq74n3zmbm27dxzl96fxa7q49689mfnlw08l";
  };

  patches = [(fetchpatch {
    name = "fix-qt53-build.diff";
    url = "http://anonscm.debian.org/cgit/pkg-phototools/luminance-hdr.git/"
      + "plain/debian/patches/51_qt5_printsupport.diff?id=00c869a860062dac181303f2c03a3513c0e210bc";
    sha256 = "0nzvfxd3ybxx61rj6vxcaaxfrsxrl9af3h8jj7pr3rncisnl9gkl";
  })];

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  buildInputs =
    [
      qtbase qtdeclarative qttools qtwebkit
      boost exiv2 fftwFloat gsl ilmbase lcms2 libraw libtiff openexr
    ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://qtpfsgui.sourceforge.net/;
    description = "A complete open source solution for HDR photography";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.hrdinka ];
  };
}
