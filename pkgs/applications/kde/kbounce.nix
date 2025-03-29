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
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kbounce";
    description = "Single player arcade game with the elements of puzzle";
    mainProgram = "kbounce";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
