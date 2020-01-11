{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-notes, kcalendarcore, kcmutils, kcrash, kdbusaddons,
  kidentitymanagement, kldap, kmailtransport, knewstuff, knotifications,
  knotifyconfig, kparts, kross, ktexteditor, kwallet, libkdepim, libkleo,
  pimcommon, qttools, karchive, mailcommon, messagelib
}:

mkDerivation {
  name = "pim-data-exporter";
  meta = {
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
