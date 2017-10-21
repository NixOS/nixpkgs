{
  mkDerivation, copyPathsToStore, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  grantlee5, ki18n, kiconthemes, knewstuff, kservice, kxmlgui, qtbase,
}:

mkDerivation {
  name = "grantleetheme";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  output = [ "out" "dev" ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee5 ki18n kiconthemes knewstuff kservice kxmlgui qtbase
  ];
  propagatedBuildInputs = [ grantlee5 kiconthemes knewstuff ];
}
