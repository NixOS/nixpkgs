{ mkDerivation
, lib
, fetchurl
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, karchive
, kconfig
, kcrash
, kguiaddons
, kinit
, kparts
, kwindowsystem
}:

mkDerivation rec {
  pname = "krusader";
  version = "2.8.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-jkzwWpMYsLwbCUGBG5iLLyuwwEoNHjeZghKpGQzywpo=";
  };

  patches = [
    # Fix compilation error due to forceful header include
    ./compat-fix.patch
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    karchive
    kconfig
    kcrash
    kguiaddons
    kinit
    kparts
    kwindowsystem
  ];

  meta = with lib; {
    homepage = "http://www.krusader.org";
    description = "Norton/Total Commander clone for KDE";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sander ];
    mainProgram = "krusader";
  };
}
