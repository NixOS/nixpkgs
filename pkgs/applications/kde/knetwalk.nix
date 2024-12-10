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
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.knetwalk";
    description = "A single player logic game";
    mainProgram = "knetwalk";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
