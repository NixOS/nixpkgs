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
  pname = "kollision";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kollision";
    description = "A casual game";
    mainProgram = "kollision";
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
