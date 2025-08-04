{
  mkDerivation,
  lib,
  extra-cmake-modules,
  libkdegames,
  kdeclarative,
}:

mkDerivation {
  pname = "kreversi";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.kreversi";
    description = "Simple one player strategy game played against the computer";
    mainProgram = "kreversi";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdeclarative
    libkdegames
  ];
}
