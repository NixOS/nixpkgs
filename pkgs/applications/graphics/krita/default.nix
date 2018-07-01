{ mkDerivation, lib, fetchurl, fetchpatch, cmake, extra-cmake-modules
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash
, boost, libraw, fftw, eigen, exiv2, libheif, lcms2, gsl, openexr, giflib
, openjpeg, opencolorio, vc, poppler_qt5, curl, ilmbase
, qtmultimedia, qtx11extras
, python3
}:

mkDerivation rec {
  name = "krita-${version}";
  version = "4.1.0";

  src = fetchurl {
    url = "https://download.kde.org/stable/krita/${version}/${name}.tar.gz";
    sha256 = "1mbyybc7h3sblbaklvz0cci3ys4zcyi616fgdn06p62v2vw2sybq";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [
    karchive kconfig kwidgetsaddons kcompletion kcoreaddons kguiaddons
    ki18n kitemmodels kitemviews kwindowsystem kio kcrash
    boost libraw fftw eigen exiv2 lcms2 gsl openexr libheif giflib
    openjpeg opencolorio vc poppler_qt5 curl ilmbase
    qtmultimedia qtx11extras
    python3
  ];

  NIX_CFLAGS_COMPILE = [ "-I${ilmbase.dev}/include/OpenEXR" ];

  meta = with lib; {
    description = "A free and open source painting application";
    homepage = https://krita.org/;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
