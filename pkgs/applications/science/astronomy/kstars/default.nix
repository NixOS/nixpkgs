{
  lib, mkDerivation, extra-cmake-modules, fetchurl,

  kconfig, kdoctools, kguiaddons, ki18n, kinit, kiconthemes, kio,
  knewstuff, kplotting, kwidgetsaddons, kxmlgui, knotifyconfig,


  qtx11extras, qtwebsockets, qtkeychain, libsecret,

  eigen, zlib,

  cfitsio, indilib, xplanet, libnova, libraw, gsl, wcslib
}:

mkDerivation rec {
  pname = "kstars";
  version = "3.4.3";

  src = fetchurl {
    url = "https://mirrors.mit.edu/kde/stable/kstars/kstars-${version}.tar.xz";
    sha256 = "0j5yxg6ay6sic194skz6vjzg6yvrpb3gvypvs0frjrcjbsl1j4f8";
  };

  patches = [
    ./indi-fix.patch
  ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kdoctools kguiaddons ki18n kinit kiconthemes kio
    knewstuff kplotting kwidgetsaddons kxmlgui knotifyconfig

    qtx11extras qtwebsockets qtkeychain libsecret

    eigen zlib

    cfitsio indilib xplanet libnova libraw gsl wcslib
  ];

  cmakeFlags = [
    "-DINDI_NIX_ROOT=${indilib}"
  ];

  meta = with lib; {
    description = "Virtual planetarium astronomy software";
    homepage = "https://kde.org/applications/education/org.kde.kstars";
    longDescription = ''
      It provides an accurate graphical simulation of the night sky, from any location on Earth, at any date and time.
      The display includes up to 100 million stars, 13.000 deep-sky objects, all 8 planets, the Sun and Moon, and thousands of comets, asteroids, supernovae, and satellites.
      For students and teachers, it supports adjustable simulation speeds in order to view phenomena that happen over long timescales, the KStars Astrocalculator to predict conjunctions, and many common astronomical calculations.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ timput ];
  };
}
