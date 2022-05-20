{ mkDerivation
, fetchFromGitHub
, lib
, extra-cmake-modules
, kdoctools
, qtbase
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
, libvlc
}:

mkDerivation rec {
  pname = "elisa";

  outputs = [ "out" "dev" ];

  buildInputs = [ libvlc ];

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
    homepage = "https://apps.kde.org/elisa/";
    description = "A simple media player for KDE";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    broken = lib.versionOlder qtbase.version "5.15";
  };
}
