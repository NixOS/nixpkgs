{ stdenv, cmake, fetchurl, pkgconfig, boost, exiv2, fftwFloat, gsl
, ilmbase, lcms2, libraw, libtiff, openexr
, qtbase, qtdeclarative, qttools, qtwebengine
}:

stdenv.mkDerivation rec {
  name = "luminance-hdr-2.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/qtpfsgui/${name}.tar.bz2";
    sha256 = "15hnyk9yjkkc97dmnrg2ipfgwqxprlcyv2kyvbls4d54zc56x658";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  buildInputs =
    [
      qtbase qtdeclarative qttools qtwebengine
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
