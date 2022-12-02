{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, akonadi-notes, akonadi-search, gpgme, grantlee,
  grantleetheme, karchive, kcodecs, kconfig, kconfigwidgets, kcontacts,
  kiconthemes, kidentitymanagement, kio, kjobwidgets, kldap,
  kmailtransport, kmbox, kmime, kwindowsystem, libgravatar, libkdepim, libkleo,
  pimcommon, qca-qt5, qtwebengine, syntax-highlighting
}:

mkDerivation {
  pname = "messagelib";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi-notes akonadi-search gpgme grantlee grantleetheme karchive kcodecs
    kconfig kconfigwidgets kiconthemes kio kjobwidgets kldap
    kmailtransport kmbox kmime kwindowsystem libgravatar libkdepim qca-qt5
    syntax-highlighting
  ];
  propagatedBuildInputs = [
    akonadi akonadi-mime kcontacts kidentitymanagement kmime libkleo pimcommon
    qtwebengine
  ];
  outputs = [ "out" "dev" ];
}
