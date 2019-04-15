{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  shared-mime-info,
  akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-notes,
  kalarmcal, kcalutils, kcontacts, kdav, kdelibs4support, kidentitymanagement,
  kimap, kmailtransport, kmbox, kmime, knotifications, knotifyconfig,
  pimcommon, qtwebengine, libkgapi, qtspeech, qtxmlpatterns,
  qca-qt5, qtnetworkauth
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
    kmailtransport kmbox kmime knotifications knotifyconfig qtwebengine
    pimcommon libkgapi qtspeech qtxmlpatterns qca-qt5 qtnetworkauth
  ];
  # Attempts to build some files before dependencies have been generated
  enableParallelBuilding = false;

  # build failure, not worth fixing, rc anyway
  postPatch = ''
    sed -i resources/CMakeLists.txt -e '/facebook/d'
  '';
}
