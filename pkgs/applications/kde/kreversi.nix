{ mkDerivation, lib, extra-cmake-modules, libkdegames, kdeclarative }:

mkDerivation {
  pname = "kreversi";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.kreversi";
    description = "A simple one player strategy game played against the computer";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdeclarative
    libkdegames
  ];
}
