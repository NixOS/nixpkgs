{
  lib,
  mkDerivation,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  boost,
  exiv2,
  fftwFloat,
  gsl,
  ilmbase,
  lcms2,
  libraw,
  libtiff,
  openexr,
  qtbase,
  qtdeclarative,
  qttools,
  qtwebengine,
  eigen,
}:

mkDerivation rec {
  pname = "luminance-hdr";
  version = "2.6.1.1";

  src = fetchFromGitHub {
    owner = "LuminanceHDR";
    repo = "LuminanceHDR";
    rev = "v.${version}";
    sha256 = "sha256-PWqtYGx8drfMVp7D7MzN1sIUTQ+Xz5yyeHN87p2r6PY=";
  };

  patches = [
    (fetchpatch {
      name = "exiv2-0.28.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/luminancehdr/-/raw/2e4a7321c7d20a52da104f4aa4dc76ac7224d94b/exiv2-0.28.patch";
      hash = "sha256-Hj+lqAd5VuTjmip8Po7YiGOWWDxnu4IMXOiEFBukXpk=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  buildInputs = [
    qtbase
    qtdeclarative
    qttools
    qtwebengine
    eigen
    boost
    exiv2
    fftwFloat
    gsl
    ilmbase
    lcms2
    libraw
    libtiff
    openexr
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://qtpfsgui.sourceforge.net/";
    description = "A complete open source solution for HDR photography";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.hrdinka ];
  };
}
