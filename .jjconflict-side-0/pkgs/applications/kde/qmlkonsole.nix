{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kconfig
, ki18n
, kirigami-addons
, kirigami2
, kcoreaddons
, qtquickcontrols2
, kwindowsystem
, qmltermwidget
}:

mkDerivation {
  pname = "qmlkonsole";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    ki18n
    kirigami-addons
    kirigami2
    qtquickcontrols2
    kcoreaddons
    kwindowsystem
    qmltermwidget
  ];

  meta = with lib; {
    description = "Terminal app for Plasma Mobile";
    mainProgram = "qmlkonsole";
    homepage = "https://invent.kde.org/plasma-mobile/qmlkonsole";
    license = with licenses; [ gpl2Plus gpl3Plus cc0 ];
    maintainers = with maintainers; [ balsoft ];
  };
}
