{
  mkDerivation, copyPathsToStore, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  shared-mime-info,
  akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-notes,
  kalarmcal, kcalutils, kcontacts, kdav, kdelibs4support, kidentitymanagement,
  kimap, kmailtransport, kmbox, kmime, knotifications, knotifyconfig,
  pimcommon, qtwebengine, libkgapi, qtnetworkauth, qtspeech, qtxmlpatterns,
}:

mkDerivation {
  name = "kdepim-runtime";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules kdoctools shared-mime-info ];
  buildInputs = [
    akonadi akonadi-calendar akonadi-contacts akonadi-mime akonadi-notes
    kalarmcal kcalutils kcontacts kdav kdelibs4support kidentitymanagement kimap
    kmailtransport kmbox kmime knotifications knotifyconfig qtwebengine
    pimcommon libkgapi qtnetworkauth qtspeech qtxmlpatterns
  ];
  # Attempts to build some files before dependencies have been generated
  enableParallelBuilding = false;
}
