{
  mkDerivation, lib, kdepimTeam, fetchpatch,
  extra-cmake-modules, kdoctools,
  shared_mime_info,
  akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-notes,
  kalarmcal, kcalutils, kcontacts, kdav, kdelibs4support, kidentitymanagement,
  kimap, kmailtransport, kmbox, kmime, knotifications, knotifyconfig,
  qtwebengine,
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
  ];
  patches = [
    # Fix crash in IMAP Akonadi resource
    (fetchpatch {
      url = "https://cgit.kde.org/kdepim-runtime.git/patch/?id=611510d0a005bc93102aa4b9f1a5b5f9905c4179";
      sha256 = "1zidfqwzj5waq01iqzgq1imr8aq7a2h5aysygi4ynakwgr4ypxcj";
    })
  ];
  # Attempts to build some files before dependencies have been generated
  enableParallelBuilding = false;
}
