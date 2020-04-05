{ mkDerivation, fetchFromGitHub, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook
, qtmultimedia, qtquickcontrols2, qtwebsockets
, kconfig, kcmutils, kcrash, kdeclarative, kfilemetadata, kinit, kirigami2
, baloo, vlc
}:

mkDerivation rec {
  pname = "elisa";
  version = "20.03.90";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    rev    = "v${version}";
    sha256 = "0ql6rd7988d4r7mg4fg3hlyq1k1jzra4qcb1f7sil9kv27mkchgi";
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
