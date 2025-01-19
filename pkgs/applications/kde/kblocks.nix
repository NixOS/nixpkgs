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
  pname = "kblocks";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.kblocks";
    description = "Classic falling blocks game";
    mainProgram = "kblocks";
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
