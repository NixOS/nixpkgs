{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  libkdegames,
  libkmahjongg,
}:

mkDerivation {
  pname = "kshisen";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.kshisen";
    description = "Solitaire-like game played using the standard set of Mahjong tiles";
    mainProgram = "kshisen";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    libkmahjongg
    kdoctools
    ki18n
    kio
  ];
}
