{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kio,
  libkgapi,
  kcalendarcore,
  kcontacts,
  qtkeychain,
  libsecret,
  kaccounts-integration,
}:

mkDerivation {
  pname = "kio-gdrive";
  meta = {
    homepage = "https://github.com/KDE/kio-gdrive";
    description = "KIO slave for Google APIs";
    maintainers = with lib.maintainers; [ kennyballou ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcalendarcore
    kcontacts
    kaccounts-integration
    libkgapi
    libsecret
    kio
    qtkeychain
  ];
}
