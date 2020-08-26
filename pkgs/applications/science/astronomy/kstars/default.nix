{
  mkDerivation, lib, fetchgit,
  extra-cmake-modules,

  kconfig, kdoctools, kguiaddons, ki18n, kinit, kiconthemes, kio,
  knewstuff, kplotting, kwidgetsaddons, kxmlgui,

  qtx11extras, qtwebsockets,

  eigen, zlib,

  cfitsio, indilib, xplanet
}:

mkDerivation {
  name = "kstars";
  
  src = fetchgit {
    url = "https://anongit.kde.org/kstars.git";
    rev = "7acc527939280edd22823371dc4e22494c6c626a";
    sha256 = "1n1lgi7p3dj893fdnzjbnrha40p4apl0dy8zppcabxwrb1khb84v";
  };
  
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kdoctools kguiaddons ki18n kinit kiconthemes kio
    knewstuff kplotting kwidgetsaddons kxmlgui

    qtx11extras qtwebsockets

    eigen zlib

    cfitsio indilib xplanet
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
