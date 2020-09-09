{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  shared-mime-info,
  akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-notes,
  kalarmcal, kcalutils, kcontacts, kdav, kdelibs4support, kidentitymanagement,
  kimap, kldap, kmailtransport, kmbox, kmime, knotifications, knotifyconfig,
  pimcommon, qtwebengine, libkgapi, qca-qt5, qtnetworkauth, qtspeech, qtxmlpatterns,
}:

mkDerivation {
  name = "kdepim-runtime";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools shared-mime-info ];
  buildInputs = [
    akonadi akonadi-calendar akonadi-contacts akonadi-mime akonadi-notes
    kalarmcal kcalutils kcontacts kdav kdelibs4support kidentitymanagement kimap
    kldap kmailtransport kmbox kmime knotifications knotifyconfig qtwebengine
    pimcommon libkgapi qca-qt5 qtnetworkauth qtspeech qtxmlpatterns
  ];
}
