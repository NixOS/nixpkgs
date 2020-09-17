{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio, libkgapi, kcalendarcore, kcontacts, qtkeychain, libsecret, kaccounts-integration }:

mkDerivation {
  name = "kio-gdrive";
  meta = with lib; {
    homepage = "https://github.com/KDE/kio-gdrive";
    description = "KIO slave for Google APIs";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kcalendarcore
    kcontacts
    kaccounts-integration
    libkgapi
    libsecret
    kio
    qtkeychain
  ];
}
