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
  version = "3.1.4";

  src = fetchurl {
    url = "http://download.kde.org/stable/krita/${version}/${name}.tar.gz";
    sha256 = "1al27v17s70hihk2mcmz3l2g6rl9qzpxaifapdfpkyias6q3f63l";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [
    karchive kconfig kwidgetsaddons kcompletion kcoreaddons kguiaddons
    ki18n kitemmodels kitemviews kwindowsystem kio kcrash
    boost libraw fftw eigen exiv2 lcms2 gsl openexr
    openjpeg opencolorio vc poppler_qt5 curl ilmbase
    qtmultimedia qtx11extras
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/KDE/krita/commit/2f59d0d1.patch";
      sha256 = "0sdlcjn6i3faln3c0aczw3pg4pvmccgszmy8n914mgsccrqrazlr";
    })
  ];

  NIX_CFLAGS_COMPILE = [ "-I${ilmbase.dev}/include/OpenEXR" ];

  meta = with lib; {
    description = "A free an open source painting application";
    homepage = "https://krita.org/";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
