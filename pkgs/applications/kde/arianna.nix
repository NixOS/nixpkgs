{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, qtbase
, qtdeclarative
, qtquickcontrols2
, qtwebchannel
, qtwebengine
, qtwebsockets
, baloo
, karchive
, kconfig
, kcoreaddons
, kdbusaddons
, kfilemetadata
, ki18n
, kirigami-addons
, kquickcharts
, kwindowsystem
, qqc2-desktop-style
}:

mkDerivation {
  pname = "arianna";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtquickcontrols2
    qtwebchannel
    qtwebengine
    qtwebsockets
    baloo
    karchive
    kconfig
    kcoreaddons
    kdbusaddons
    kfilemetadata
    ki18n
    kirigami-addons
    kquickcharts
    kwindowsystem
    qqc2-desktop-style
  ];

  meta = with lib; {
    description = "An Epub Reader for Plasma and Plasma Mobile";
    homepage = "https://invent.kde.org/graphics/arianna";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Thra11 ];
  };
}
