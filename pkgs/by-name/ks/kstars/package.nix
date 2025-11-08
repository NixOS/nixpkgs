{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  cfitsio,
  cmake,
  curl,
  eigen_3_4_0,
  gsl,
  indi-full,
  kdePackages,
  libnova,
  libraw,
  libsecret,
  libxisf,
  opencv,
  stellarsolver,
  wcslib,
  xplanet,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kstars";
  version = "3.7.9";

  src = fetchurl {
    url = "mirror://kde/stable/kstars/${finalAttrs.version}/kstars-${finalAttrs.version}.tar.xz";
    hash = "sha256-aE2gtAGzLBcUk+Heg+ZOMLd1wX6VEbrSpxkWETmlEZc=";
  };

  # Qt 6.10 build patch from master
  # can be removed with next release
  patches = [
    (fetchpatch2 {
      url = "https://invent.kde.org/education/kstars/-/commit/ce53888e6dbaeb1b9239fca55288b5ead969b5a7.diff";
      hash = "sha256-awZeOLlG1vlCWC+QfypqHIIYexpywRmNT1ACdkqqLt4=";
    })
  ];

  nativeBuildInputs = with kdePackages; [
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
    cmake
  ];

  buildInputs = with kdePackages; [
    breeze-icons
    cfitsio
    curl
    eigen_3_4_0
    gsl
    indi-full
    kconfig
    kdoctools
    kguiaddons
    ki18n
    kiconthemes
    kio
    knewstuff
    knotifyconfig
    kplotting
    kwidgetsaddons
    kxmlgui
    libnova
    libraw
    libsecret
    libxisf
    opencv
    qtdatavis3d
    qtkeychain
    qtsvg
    qtwayland
    qtwebsockets
    stellarsolver
    wcslib
    xplanet
    zlib
  ];

  cmakeFlags = with lib.strings; [
    (cmakeBool "BUILD_WITH_QT6" true)
    (cmakeFeature "INDI_PREFIX" "${indi-full}")
    (cmakeFeature "XPLANET_PREFIX" "${xplanet}")
    (cmakeFeature "DATA_INSTALL_DIR" (placeholder "out") + "/share/kstars/")
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
    maintainers = with maintainers; [
      timput
      returntoreality
    ];
  };
})
