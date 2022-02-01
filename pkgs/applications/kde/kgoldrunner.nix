{ lib, mkDerivation, extra-cmake-modules, kio, kxmlgui, libkdegames }:

mkDerivation {
  pname = "kgoldrunner";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kio kxmlgui libkdegames ];

  meta = with lib; {
    homepage = "https://apps.kde.org/kgoldrunner/";
    description = "Hunt gold, dodge enemies and solve puzzles";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
