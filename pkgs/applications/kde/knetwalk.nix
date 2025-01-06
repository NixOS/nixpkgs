{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  libkdegames,
}:

mkDerivation {
  pname = "knetwalk";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.knetwalk";
    description = "Single player logic game";
    mainProgram = "knetwalk";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    kdoctools
    ki18n
    kio
  ];
}
