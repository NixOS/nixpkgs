{
  mkDerivation, copyPathsToStore, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, grantlee, grantleetheme, kconfig, kconfigwidgets,
  kcontacts, ki18n, kiconthemes, kio, libkleo, pimcommon, prison,
}:

mkDerivation {
  name = "kdepim-apps-libs";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-contacts grantlee grantleetheme kconfig kconfigwidgets
    kcontacts ki18n kiconthemes kio libkleo pimcommon prison
  ];
  outputs = [ "out" "dev" ];
}
