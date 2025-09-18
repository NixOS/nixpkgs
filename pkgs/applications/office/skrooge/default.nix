{
  stdenv,
  lib,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qtbase,
  wrapQtAppsHook,
  qtwebengine,
  grantlee,
  kxmlgui,
  kwallet,
  kparts,
  kdoctools,
  kjobwidgets,
  kiconthemes,
  knewstuff,
  sqlcipher,
  qca,
  plasma-activities,
  karchive,
  kguiaddons,
  knotifyconfig,
  krunner,
  ktexttemplate,
  kwindowsystem,
  libofx,
  shared-mime-info,
}:

stdenv.mkDerivation rec {
  pname = "skrooge";
  version = "25.4.0";

  src = fetchurl {
    url = "mirror://kde/stable/skrooge/skrooge-${version}.tar.xz";
    hash = "sha256-HNui/SjCN9LWxUxHDae59n5qPIwYWHX1uFSlVnwBlL8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    pkg-config
    shared-mime-info
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwebengine
    grantlee
    kxmlgui
    kwallet
    kparts
    kjobwidgets
    kiconthemes
    knewstuff
    sqlcipher
    qca
    plasma-activities
    karchive
    kguiaddons
    knotifyconfig
    krunner
    ktexttemplate
    kwindowsystem
    libofx
  ];

  cmakeFlags = [
    "-DQT_MAJOR_VERSION=6"
    # SKG_DESIGNER must be used to generate the needed library for QtDesigner.
    # This is needed ONLY for developers. So NOT NEEDED for end user.
    # Source: https://forum.kde.org/viewtopic.php?f=210&t=143375#p393675
    "-DSKG_DESIGNER=OFF"
    "-DSKG_WEBENGINE=ON"
    "-DSKG_WEBKIT=OFF"
    "-DBUILD_TESTS=ON"
  ];

  meta = with lib; {
    description = "Personal finances manager, powered by KDE";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ joko ];
    homepage = "https://skrooge.org/";
  };
}
