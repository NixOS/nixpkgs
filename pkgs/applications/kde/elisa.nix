{ mkDerivation
, fetchFromGitHub
, lib
, extra-cmake-modules
, kdoctools
, qtmultimedia
, qtquickcontrols2
, qtwebsockets
, kconfig
, kcmutils
, kcrash
, kdeclarative
, kfilemetadata
, kinit
, kirigami2
, baloo
, vlc
}:

mkDerivation rec {
  name = "elisa";

  buildInputs = [ vlc ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  propagatedBuildInputs = [
    baloo
    kcmutils
    kconfig
    kcrash
    kdeclarative
    kfilemetadata
    kinit
    kirigami2
    qtmultimedia
    qtquickcontrols2
    qtwebsockets
  ];

  meta = with lib; {
    description = "A simple media player for KDE";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
