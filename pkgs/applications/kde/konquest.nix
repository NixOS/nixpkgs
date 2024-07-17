{
  lib,
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kguiaddons,
  kxmlgui,
  kwidgetsaddons,
  libkdegames,
  qtquickcontrols,
}:

mkDerivation {
  pname = "konquest";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kguiaddons
    kxmlgui
    kwidgetsaddons
    libkdegames
    qtquickcontrols
  ];
  meta = {
    homepage = "https://apps.kde.org/konquest/";
    description = "Galactic strategy game";
    mainProgram = "konquest";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ lheckemann ];
  };
}
