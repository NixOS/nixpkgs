{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  shared_mime_info,
  akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-notes,
  kalarmcal, kcalutils, kcontacts, kdav, kdelibs4support, kidentitymanagement,
  kimap, kmailtransport, kmbox, kmime, knotifications, knotifyconfig,
  pimcommon, qtwebengine,
}:

mkDerivation {
  name = "kdepim-runtime";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools shared_mime_info ];
  buildInputs = [
    akonadi akonadi-calendar akonadi-contacts akonadi-mime akonadi-notes
    kalarmcal kcalutils kcontacts kdav kdelibs4support kidentitymanagement kimap
    kmailtransport kmbox kmime knotifications knotifyconfig qtwebengine
    pimcommon
  ];
  # Attempts to build some files before dependencies have been generated
  enableParallelBuilding = false;
}
