{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, akonadi-mime, grantlee, karchive, kcodecs,
  kcompletion, kconfig, kconfigwidgets, kcontacts, kdbusaddons,
  kiconthemes, kimap, kio, kitemmodels, kjobwidgets, knewstuff, kpimtextedit,
  kwallet, kwindowsystem, libkdepim, qtwebengine
}:

mkDerivation {
  name = "pimcommon";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi-mime grantlee karchive kcodecs kcompletion kconfigwidgets
    kdbusaddons kiconthemes kio kitemmodels kjobwidgets knewstuff kpimtextedit
    kwallet kwindowsystem libkdepim qtwebengine
  ];
  propagatedBuildInputs = [
    akonadi akonadi-contacts kconfig kcontacts kimap
  ];
  outputs = [ "out" "dev" ];
}
