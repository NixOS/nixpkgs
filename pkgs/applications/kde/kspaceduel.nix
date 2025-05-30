{
  mkDerivation,
  lib,
  extra-cmake-modules,
  cmake,
  kdbusaddons,
  ki18n,
  kconfigwidgets,
  kcrash,
  kxmlgui,
  libkdegames,
}:

mkDerivation {
  pname = "kspaceduel";
  meta = {
    homepage = "https://apps.kde.org/kspaceduel/";
    description = "Space arcade game";
    mainProgram = "kspaceduel";
    license = with lib.licenses; [
      lgpl21
      gpl3
    ];
  };
  outputs = [
    "out"
    "dev"
  ];
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    kdbusaddons
    ki18n
    kconfigwidgets
    kcrash
    kxmlgui
    libkdegames
  ];
}
