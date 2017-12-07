{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, calendarsupport, eventviews, kdepim-apps-libs,
  kdiagram, kldap, kmime, qtbase,
}:

mkDerivation {
  name = "incidenceeditor";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-mime calendarsupport eventviews kdepim-apps-libs kdiagram
    kldap kmime qtbase
  ];
  outputs = [ "out" "dev" ];
}
