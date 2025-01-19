{
  mkDerivation,
  lib,
  extra-cmake-modules,
  libkdegames,
  kconfig,
  kcrash,
  kio,
  ki18n,
}:

mkDerivation {
  pname = "kbounce";
  meta = {
    homepage = "https://kde.org/applications/en/games/org.kde.kbounce";
    description = "Single player arcade game with the elements of puzzle";
    mainProgram = "kbounce";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    kconfig
    kcrash
    kio
    ki18n
  ];
}
