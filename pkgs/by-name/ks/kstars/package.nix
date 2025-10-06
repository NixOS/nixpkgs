{
  lib,
  stdenv,
  fetchurl,
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
  version = "3.7.8";

  src = fetchurl {
    url = "mirror://kde/stable/kstars/${finalAttrs.version}/kstars-${finalAttrs.version}.tar.xz";
    hash = "sha256-VbOu8p7Bq6UJBr05PVZein4LWzpdLo4838G1jXGNLAw=";
  };

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
    (cmakeBool "BUILD_QT5" false)
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
