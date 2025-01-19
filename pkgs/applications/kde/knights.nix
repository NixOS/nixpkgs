{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  kplotting,
  plasma-framework,
  libkdegames,
}:

mkDerivation {
  pname = "knights";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.knights";
    description = "Chess game";
    mainProgram = "knights";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    plasma-framework
    kplotting
    kdoctools
    ki18n
    kio
  ];
}
