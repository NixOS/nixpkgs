{ mkDerivation
, fetchFromGitHub
, fetchpatch
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
  name = "elisa";

  patches = [
    # Backporting build fix for QT < 5.14
    (fetchpatch {
      url = "https://invent.kde.org/multimedia/elisa/-/commit/159134b4716f07eb1d4ecbaeaae6e1c342088ef0.patch";
      sha256 = "1ijlmmlfzwvmpkb5dnpmg552zz5y5b02spmfd7kz0z1g08cfxdhi";
    })
  ];

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
    description = "A simple media player for KDE";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    broken = lib.versionOlder qtbase.version "5.14";
  };
}
