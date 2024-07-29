{ lib, mkDerivation, fetchurl, cmake, extra-cmake-modules, pkg-config, wrapGAppsHook3
, kconfig, kinit, kdoctools, kio, kparts, kwidgetsaddons
, qtbase, qtsvg
, boost, graphviz
}:

mkDerivation rec {
  pname = "kgraphviewer";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://kde/stable/kgraphviewer/${version}/${pname}-${version}.tar.xz";
    sha256 = "1h6pgg89gvxl8gw7wmkabyqqrzad5pxyv5lsmn1fl4ir8lcc5q2l";
  };

  buildInputs = [
    qtbase qtsvg
    boost graphviz
  ];

  nativeBuildInputs = [
    cmake extra-cmake-modules pkg-config wrapGAppsHook3
    kdoctools
  ];

  propagatedBuildInputs = [
    kconfig kinit kio kparts kwidgetsaddons
  ];

  meta = with lib; {
    description = "Graphviz dot graph viewer for KDE";
    mainProgram = "kgraphviewer";
    license     = licenses.gpl2;
    maintainers = [ ];
    platforms   = platforms.linux;
  };
}
