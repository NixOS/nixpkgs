{
  lib, mkDerivation, extra-cmake-modules, fetchurl,

  kconfig, kdoctools, kguiaddons, ki18n, kinit, kiconthemes, kio,
  knewstuff, kplotting, kwidgetsaddons, kxmlgui, knotifyconfig,


  qtx11extras, qtwebsockets, qtkeychain, libsecret,

  eigen, zlib,

  cfitsio, indi-full, xplanet, libnova, libraw, gsl, wcslib, stellarsolver
}:

mkDerivation rec {
  pname = "kstars";
  version = "3.5.4";

  src = fetchurl {
    url = "mirror://kde/stable/kstars/kstars-${version}.tar.xz";
    sha256 = "sha256-JCdSYcogvoUmu+vB/vye+6ZMIJqVoScAKreh89dxoDU=";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kdoctools kguiaddons ki18n kinit kiconthemes kio
    knewstuff kplotting kwidgetsaddons kxmlgui knotifyconfig

    qtx11extras qtwebsockets qtkeychain libsecret

    eigen zlib

    cfitsio indi-full xplanet libnova libraw gsl wcslib stellarsolver
  ];

  # See https://bugs.kde.org/show_bug.cgi?id=439541
  preConfigure = ''
    rm po/de/docs/kstars/index.docbook
  '';

  cmakeFlags = [
    "-DINDI_PREFIX=${indi-full}"
    "-DXPLANET_PREFIX=${xplanet}"
  ];

  meta = with lib; {
    description = "Virtual planetarium astronomy software";
    homepage = "https://kde.org/applications/education/org.kde.kstars";
    longDescription = ''
      It provides an accurate graphical simulation of the night sky, from any location on Earth, at any date and time.
      The display includes up to 100 million stars, 13.000 deep-sky objects, all 8 planets, the Sun and Moon, and thousands of comets, asteroids, supernovae, and satellites.
      For students and teachers, it supports adjustable simulation speeds in order to view phenomena that happen over long timescales, the KStars Astrocalculator to predict conjunctions, and many common astronomical calculations.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ timput hjones2199 ];
  };
}
