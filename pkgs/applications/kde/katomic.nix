{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  libkdegames,
  knewstuff,
}:

mkDerivation {
  pname = "katomic";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.katomic";
    description = "Fun educational game built around molecular geometry";
    mainProgram = "katomic";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    knewstuff
    libkdegames
    kdoctools
    ki18n
    kio
  ];
}
