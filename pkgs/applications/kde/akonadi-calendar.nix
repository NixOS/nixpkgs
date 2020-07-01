{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, kcalendarcore, kcalutils, kcontacts,
  kidentitymanagement, kio, kmailtransport,
}:

mkDerivation {
  name = "akonadi-calendar";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-contacts kcalendarcore kcalutils kcontacts kidentitymanagement
    kio kmailtransport
  ];
  outputs = [ "out" "dev" ];
}
