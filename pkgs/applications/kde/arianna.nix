{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  qtbase,
  qtdeclarative,
  qtquickcontrols2,
  qtwebchannel,
  qtwebengine,
  qtwebsockets,
  baloo,
  karchive,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  kfilemetadata,
  ki18n,
  kirigami-addons,
  kitemmodels,
  kquickcharts,
  kwindowsystem,
  qqc2-desktop-style,
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
    kitemmodels
    kquickcharts
    kwindowsystem
    qqc2-desktop-style
  ];

  meta = {
    description = "Epub Reader for Plasma and Plasma Mobile";
    mainProgram = "arianna";
    homepage = "https://invent.kde.org/graphics/arianna";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Thra11 ];
  };
}
