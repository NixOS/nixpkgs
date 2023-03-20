{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kconfig
, kcoreaddons
, ki18n
, kirigami2
, kirigami-addons
, kwindowsystem
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "krecorder";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    ki18n
    kirigami2
    kirigami-addons
    kwindowsystem
    qtmultimedia
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Audio recorder for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/krecorder";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
