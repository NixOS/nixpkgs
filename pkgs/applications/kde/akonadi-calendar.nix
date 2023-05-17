{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, kcalendarcore, kcalutils, kcontacts,
  kidentitymanagement, kio, kmailtransport,
}:

mkDerivation {
  pname = "akonadi-calendar";
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
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
