{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-notes, kcalendarcore, kcmutils, kcrash, kdbusaddons,
  kidentitymanagement, kldap, kmailtransport, knewstuff, knotifications,
  knotifyconfig, kparts, kross, ktexteditor, kwallet, libkdepim, libkleo,
  pimcommon, qttools, karchive, mailcommon, messagelib
}:

mkDerivation {
  pname = "pim-data-exporter";
  meta = {
    homepage = "https://apps.kde.org/pimdataexporter/";
    description = "Saves and restores all data from PIM apps";
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-notes kcalendarcore kcmutils kcrash kdbusaddons
    kidentitymanagement kldap kmailtransport knewstuff knotifications
    knotifyconfig kparts kross ktexteditor kwallet libkdepim libkleo pimcommon
    qttools karchive mailcommon messagelib
  ];
}
