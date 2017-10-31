{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, akonadi-notes, akonadi-search, gpgme, grantlee5,
  grantleetheme, karchive, kcodecs, kconfig, kconfigwidgets, kcontacts,
  kdepim-apps-libs, kiconthemes, kidentitymanagement, kio, kjobwidgets, kldap,
  kmailtransport, kmbox, kmime, kwindowsystem, libgravatar, libkdepim, libkleo,
  pimcommon, qtwebengine, qtwebkit, syntax-highlighting
}:

mkDerivation {
  name = "messagelib";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi-notes akonadi-search gpgme grantlee5 grantleetheme karchive kcodecs
    kconfig kconfigwidgets kdepim-apps-libs kiconthemes kio kjobwidgets kldap
    kmailtransport kmbox kmime kwindowsystem libgravatar libkdepim qtwebkit
    syntax-highlighting
  ];
  propagatedBuildInputs = [
    akonadi akonadi-mime kcontacts kidentitymanagement kmime libkleo pimcommon
    qtwebengine
  ];
  outputs = [ "out" "dev" ];
}
