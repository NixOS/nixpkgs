{ mkDerivation, fetchFromGitHub, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook
, qtmultimedia, qtquickcontrols2, qtwebsockets
, kconfig, kcmutils, kcrash, kdeclarative, kfilemetadata, kinit
, baloo
}:

mkDerivation rec {
  name = "elisa-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    rev    = version;
    sha256 = "13i0fkpwrskric3gfalh7mcpp4l2knwnq7jpq391lgh6krq04r4w";
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
