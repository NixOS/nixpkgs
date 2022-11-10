{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  grantlee, ki18n, kiconthemes, knewstuff, kservice, kxmlgui, qtbase,
}:

mkDerivation {
  pname = "grantleetheme";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
    broken = lib.versionOlder qtbase.version "5.13.0";
  };
  output = [ "out" "dev" ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee ki18n kiconthemes knewstuff kservice kxmlgui qtbase
  ];
  propagatedBuildInputs = [ grantlee kiconthemes knewstuff ];
}
