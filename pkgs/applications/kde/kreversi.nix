{
  mkDerivation,
  lib,
  extra-cmake-modules,
  libkdegames,
  kdeclarative,
}:

mkDerivation {
  pname = "kreversi";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kreversi";
    description = "A simple one player strategy game played against the computer";
    mainProgram = "kreversi";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdeclarative
    libkdegames
  ];
}
