{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  wrapGAppsHook3,
  libsForQt5,
  boost,
  graphviz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kgraphviewer";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://kde/stable/kgraphviewer/${finalAttrs.version}/kgraphviewer-${finalAttrs.version}.tar.xz";
    sha256 = "1h6pgg89gvxl8gw7wmkabyqqrzad5pxyv5lsmn1fl4ir8lcc5q2l";
  };

  patches = [ ./cmake-minimum-required.patch ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
    boost
    graphviz
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapGAppsHook3
    libsForQt5.kdoctools
    libsForQt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = with libsForQt5; [
    kconfig
    kinit
    kio
    kparts
    kwidgetsaddons
  ];

  meta = {
    description = "Graphviz dot graph viewer for KDE";
    mainProgram = "kgraphviewer";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
