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
  meta = with lib; {
    homepage = "https://github.com/KDE/kio-gdrive";
    description = "KIO slave for Google APIs";
    maintainers = with maintainers; [ kennyballou ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
