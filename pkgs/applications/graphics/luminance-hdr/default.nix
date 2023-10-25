{ lib, mkDerivation, cmake, fetchFromGitHub, pkg-config
, boost, exiv2, fftwFloat, gsl
, ilmbase, lcms2, libraw, libtiff, openexr
, qtbase, qtdeclarative, qttools, qtwebengine, eigen
}:

mkDerivation rec {
  pname = "luminance-hdr";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "LuminanceHDR";
    repo = "LuminanceHDR";
    rev = "v.${version}";
    sha256 = "1izmgjjp8mgyxv57sjjr05z7g7059ykb5wchlcn4wrnnb6aslnvn";
  };

  env.NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  buildInputs = [
    qtbase qtdeclarative qttools qtwebengine eigen
    boost exiv2 fftwFloat gsl ilmbase lcms2 libraw libtiff openexr
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    homepage = "https://qtpfsgui.sourceforge.net/";
    description = "A complete open source solution for HDR photography";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.hrdinka ];
  };
}
