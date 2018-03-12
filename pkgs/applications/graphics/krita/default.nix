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
  version = "3.3.3";

  src = fetchurl {
    url = "https://download.kde.org/stable/krita/${version}/${name}.tar.gz";
    sha256 = "0pc6hnakkqy81x5b5ncivaps6hqv43i50sjwgi3i3cz9j8rlxh5y";
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
    description = "A free and open source painting application";
    homepage = https://krita.org/;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
