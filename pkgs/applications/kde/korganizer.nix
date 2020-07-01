{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  qtbase, qttools,
  phonon,
  knewstuff,
  akonadi-calendar, akonadi-contacts, akonadi-notes, akonadi-search,
  calendarsupport, eventviews, incidenceeditor, kcalutils, kdepim-apps-libs,
  kholidays, kidentitymanagement, kldap, kmailtransport, kontactinterface,
  kpimtextedit, pimcommon,
}:

mkDerivation {
  name = "korganizer";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    qtbase qttools
    phonon
    knewstuff
    akonadi-calendar akonadi-contacts akonadi-notes akonadi-search
    calendarsupport eventviews incidenceeditor kcalutils kdepim-apps-libs
    kholidays kidentitymanagement kldap kmailtransport kontactinterface
    kpimtextedit pimcommon
  ];
}
