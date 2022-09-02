{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  shared-mime-info,
  akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-notes,
  cyrus_sasl, kholidays, kcalutils, kcontacts, kdav, kidentitymanagement,
  kimap, kldap, kmailtransport, kmbox, kmime, knotifications, knotifyconfig,
  pimcommon, libkgapi, libsecret,
  qca-qt5, qtkeychain, qtnetworkauth, qtspeech, qtwebengine, qtxmlpatterns,
}:

mkDerivation {
  pname = "kdepim-runtime";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools shared-mime-info ];
  buildInputs = [
    akonadi akonadi-calendar akonadi-contacts akonadi-mime akonadi-notes
    kholidays kcalutils kcontacts kdav kidentitymanagement kimap
    kldap kmailtransport kmbox kmime knotifications knotifyconfig qtwebengine
    pimcommon libkgapi libsecret
    qca-qt5 qtkeychain qtnetworkauth qtspeech qtxmlpatterns
  ];
  qtWrapperArgs = [
    "--prefix SASL_PATH : ${lib.makeSearchPath "lib/sasl2" [ cyrus_sasl libkgapi ]}"
  ];
}
