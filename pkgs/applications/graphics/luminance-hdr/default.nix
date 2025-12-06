{
  lib,
  stdenv,
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
  libsForQt5,
  eigen,
}:

stdenv.mkDerivation rec {
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
    (fetchpatch {
      name = "luminance-hdr-Fix-building-with-Boost-1.85.0.patch";
      url = "https://github.com/LuminanceHDR/LuminanceHDR/commit/33b364f76b0edca4352cf701c1557d0c0e796c4f.patch";
      hash = "sha256-jzyfKFmmzo6WUOUn33gr1g4MbSVpRfKLUIi49PSF5cg=";
    })
    # Fix lots of errors of form:
    #     include/boost/math/tools/type_traits.hpp:208:12: error: 'is_final' has not been declared in 'std'
    (fetchpatch {
      name = "luminancehdr-fix-boost-1.87.0-compilation.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/luminancehdr/-/raw/d5fdbad3c11b6d414d842a7751e858f51292f544/luminancehdr-fix-boost-1.87.0-compilation.patch";
      hash = "sha256-bKJhENnOWNwKUUSrSUF9fS1Por1A7exYAeiuCa2fRJY=";
    })
    # Fix error:
    #     /build/source/src/Libpfs/manip/gamma_levels.cpp:136:25: error: call of overloaded 'clamp(float, float, float)' is ambiguous
    (fetchpatch {
      name = "luminancehdr-clamp.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/luminancehdr/-/raw/d5fdbad3c11b6d414d842a7751e858f51292f544/clamp.patch";
      hash = "sha256-iAcZV1lFREPzjA9J3feSdhyTougvQA11I0IQRRYOmxY=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
    libsForQt5.qttools
    libsForQt5.qtwebengine
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
    libsForQt5.wrapQtAppsHook
    cmake
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://qtpfsgui.sourceforge.net/";
    description = "Complete open source solution for HDR photography";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
