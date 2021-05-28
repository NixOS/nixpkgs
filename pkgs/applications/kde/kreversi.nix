{ mkDerivation, lib, extra-cmake-modules, libkdegames, kdeclarative }:

mkDerivation {
  name = "kreversi";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kreversi";
    description = "KReversi is a simple one player strategy game played against the computer";
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
