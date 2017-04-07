{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, kcalcore, kcalutils, kcontacts, kidentitymanagement, kio, kmailtransport
}:
kdeApp {
  name = "akonadi-calendar";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    akonadi akonadi-contacts kcalcore kcalutils kcontacts kidentitymanagement kio kmailtransport
  ];
}
