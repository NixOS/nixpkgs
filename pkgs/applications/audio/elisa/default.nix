{ mkDerivation, fetchFromGitHub, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook
, qtmultimedia, qtquickcontrols2, qtwebsockets
, kconfig, kcmutils, kcrash, kdeclarative, kfilemetadata, kinit
, baloo
}:

mkDerivation rec {
  name = "elisa-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    rev    = "v${version}";
    sha256 = "0b3rx3gh6adlrbmgj75dicqv6qzzn4fyfxbf1nwh3zd2hi0ca89w";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [
    qtmultimedia qtquickcontrols2 qtwebsockets
    kconfig kcmutils kcrash kdeclarative kfilemetadata kinit
    baloo
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Elisa Music Player";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kconfig.meta) platforms;
  };
}
