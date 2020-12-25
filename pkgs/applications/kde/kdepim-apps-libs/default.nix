{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, grantlee, grantleetheme, kconfig, kconfigwidgets,
  kcontacts, ki18n, kiconthemes, kio, libkleo, pimcommon, prison,
}:

mkDerivation {
  pname = "kdepim-apps-libs";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-contacts grantlee grantleetheme kconfig kconfigwidgets
    kcontacts ki18n kiconthemes kio libkleo pimcommon prison
  ];
  outputs = [ "out" "dev" ];
}
