{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, kcalendarcore, kcalutils, kcontacts,
<<<<<<< HEAD
  kidentitymanagement, kio, kmailtransport, messagelib
=======
  kidentitymanagement, kio, kmailtransport,
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    kio kmailtransport messagelib
=======
    kio kmailtransport
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];
  outputs = [ "out" "dev" ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
