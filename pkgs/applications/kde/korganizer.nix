{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  qtbase, qttools,
  phonon,
  knewstuff,
  akonadi-calendar, akonadi-contacts, akonadi-notes, akonadi-search,
  calendarsupport, eventviews, incidenceeditor, kcalutils,
  kholidays, kidentitymanagement, kldap, kmailtransport, kontactinterface,
  kparts, kpimtextedit, pimcommon,
}:

mkDerivation {
  pname = "korganizer";
  meta = {
    homepage = "https://apps.kde.org/korganizer/";
    description = "Personal organizer";
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    qtbase qttools
    phonon
    knewstuff
    akonadi-calendar akonadi-contacts akonadi-notes akonadi-search
    calendarsupport eventviews incidenceeditor kcalutils
    kholidays kidentitymanagement kldap kmailtransport kontactinterface
    kparts kpimtextedit pimcommon
  ];
}
