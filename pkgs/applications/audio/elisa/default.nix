{ mkDerivation, fetchFromGitHub, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook
, qtmultimedia, qtquickcontrols2, qtwebsockets
, kconfig, kcmutils, kcrash, kdeclarative, kfilemetadata, kinit, kirigami2
, baloo, vlc
}:

mkDerivation rec {
  pname = "elisa";
  version = "19.12.3";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    rev    = "v${version}";
    sha256 = "0s1sixkrx4czckzg0llkrbp8rp397ljsq1c309z23m277jsmnnb6";
  };

  buildInputs = [ vlc ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [
    qtmultimedia qtquickcontrols2 qtwebsockets
    kconfig kcmutils kcrash kdeclarative kfilemetadata kinit kirigami2
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
