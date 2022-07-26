{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, akonadi-mime, akonadi-search, grantlee, karchive, kcmutils, kcodecs,
  kcompletion, kconfig, kconfigwidgets, kcontacts, kdbusaddons,
  kiconthemes, kimap, kio, kitemmodels, kjobwidgets, kldap, knewstuff, kpimtextedit,
  kpurpose, kwallet, kwindowsystem, libkdepim, qtwebengine
}:

mkDerivation {
  pname = "pimcommon";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi-mime grantlee karchive kcmutils kcodecs kcompletion kconfigwidgets
    kdbusaddons kiconthemes kio kitemmodels kjobwidgets knewstuff kldap
    kpurpose kwallet kwindowsystem libkdepim qtwebengine
  ];
  propagatedBuildInputs = [
    akonadi akonadi-contacts akonadi-search kconfig kcontacts kimap kpimtextedit
  ];
  outputs = [ "out" "dev" ];
}
