{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, akonadi-notes, akonadi-search, gpgme, grantlee,
  grantleetheme, karchive, kcodecs, kconfig, kconfigwidgets, kcontacts,
  kiconthemes, kidentitymanagement, kio, kjobwidgets, kldap,
  kmailtransport, kmbox, kmime, kwindowsystem, libgravatar, libkdepim, libkleo,
  pimcommon, qca-qt5, qtwebengine, syntax-highlighting, fetchpatch
}:

mkDerivation {
  pname = "messagelib";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  patches = [
    # fix compatibility with cmake 3.24
    (fetchpatch {
      url = "https://invent.kde.org/pim/messagelib/-/commit/6eaef36d42bdb05f3.patch";
      hash = "sha256-H0ayU81HxX5moHOQ3hDW7tg824oqK1p9atrBhuvZ8K8=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/pim/messagelib/-/commit/3edc93673f94604c2.patch";
      hash = "sha256-tBFWCfttjDjyQyWnKdhVfLY6QsixzqqYuvD77GVH080=";
    })
  ];
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
