{ lib
, stdenv
, mkDerivation
, extra-cmake-modules
, fetchurl
, kconfig
, kdoctools
, kguiaddons
, ki18n
, kinit
, kiconthemes
, kio
, knewstuff
, kplotting
, kwidgetsaddons
, kxmlgui
, knotifyconfig
, qtx11extras
, qtwebsockets
, qtkeychain
, qtdatavis3d
, wrapQtAppsHook
, breeze-icons
, libsecret
, eigen
, zlib
, cfitsio
, indi-full
, xplanet
, libnova
, libraw
, gsl
, wcslib
, stellarsolver
, libxisf
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kstars";
  version = "3.7.0";

  src = fetchurl {
    url = "mirror://kde/stable/kstars/kstars-${finalAttrs.version}.tar.xz";
    hash = "sha256-yvN1k0LqUi5Odb34Nk8UP5qoIbFUcvUiyESpoMKmuqg=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];
  buildInputs = [
    kconfig
    kdoctools
    kguiaddons
    ki18n
    kinit
    kiconthemes
    kio
    knewstuff
    kplotting
    kwidgetsaddons
    kxmlgui
    knotifyconfig
    qtx11extras
    qtwebsockets
    qtkeychain
    qtdatavis3d
    breeze-icons
    libsecret
    eigen
    zlib
    cfitsio
    indi-full
    xplanet
    libnova
    libraw
    gsl
    wcslib
    stellarsolver
    libxisf
  ];

  cmakeFlags = [
    "-DINDI_PREFIX=${indi-full}"
    "-DXPLANET_PREFIX=${xplanet}"
  ];

  meta = with lib; {
    description = "Virtual planetarium astronomy software";
    mainProgram = "kstars";
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
})
