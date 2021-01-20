{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, karchive, kcodecs, kcompletion, kconfigwidgets,
  kdbusaddons, kdesignerplugin, kiconthemes, kio, kitemmodels, kldap,
  kmailtransport, kwindowsystem, mailimporter, messagelib, phonon, libkdepim
}:

mkDerivation {
  pname = "mailcommon";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-mime karchive kcodecs kcompletion kconfigwidgets kdbusaddons
    kdesignerplugin kiconthemes kio kitemmodels kldap kmailtransport
    kwindowsystem mailimporter messagelib phonon libkdepim
  ];
  outputs = [ "out" "dev" ];
}
