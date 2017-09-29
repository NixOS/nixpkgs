{ mkDerivation, lib, fetchurl, fetchpatch, cmake, extra-cmake-modules
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash
, boost, libraw, fftw, eigen, exiv2, lcms2, gsl, openexr
, openjpeg, opencolorio, vc, poppler_qt5, curl, ilmbase
, qtmultimedia, qtx11extras
}:

mkDerivation rec {
  name = "krita-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/krita/${version}/${name}.tar.gz";
    sha256 = "0fafy5ggplgq2rz85sqa42vmkzs2r9dq47qfrbnn2n6pfzkcw1pg";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [
    karchive kconfig kwidgetsaddons kcompletion kcoreaddons kguiaddons
    ki18n kitemmodels kitemviews kwindowsystem kio kcrash
    boost libraw fftw eigen exiv2 lcms2 gsl openexr
    openjpeg opencolorio vc poppler_qt5 curl ilmbase
    qtmultimedia qtx11extras
  ];

  NIX_CFLAGS_COMPILE = [ "-I${ilmbase.dev}/include/OpenEXR" ];

  meta = with lib; {
    description = "A free an open source painting application";
    homepage = https://krita.org/;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
