{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  karchive,
  kcmutils,
  kcrash,
  kdnssd,
  ki18n,
  knotifications,
  knotifyconfig,
  kplotting,
  kross,
  libgcrypt,
  libktorrent,
  taglib,
}:

mkDerivation {
  pname = "ktorrent";
  meta = {
    description = "KDE integrated BtTorrent client";
    homepage = "https://apps.kde.org/ktorrent/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    karchive
    kcmutils
    kcrash
    kdnssd
    ki18n
    knotifications
    knotifyconfig
    kplotting
    kross
    libgcrypt
    libktorrent
    taglib
  ];
}
