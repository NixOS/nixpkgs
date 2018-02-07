{ stdenv, mkDerivation, fetchurl, cmake, extra-cmake-modules, pkgconfig, wrapGAppsHook
, kconfig, kcrash, kinit, kdoctools, kiconthemes, kio, kparts, kwidgetsaddons
, qtbase, qtsvg
, boost, graphviz
}:

mkDerivation rec {
  name = "kgraphviewer-${version}";
  version = "2.4.2";

  src = fetchurl {
    url = "mirror://kde/stable/kgraphviewer/${version}/${name}.tar.xz";
    sha256 = "1jc5zfgy4narwgn7rscfwz7l5pjy0jghal6yb3kd4sfadi78nhs9";
  };

  buildInputs = [
    qtbase qtsvg
    boost graphviz
  ];

  nativeBuildInputs = [
    cmake extra-cmake-modules pkgconfig wrapGAppsHook
    kdoctools
  ];

  propagatedBuildInputs = [
    kconfig kinit kio kparts kwidgetsaddons
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Graphviz dot graph viewer for KDE";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lethalman ];
    platforms   = platforms.linux;
  };
}
