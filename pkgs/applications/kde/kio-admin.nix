{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtbase,
  kio,
  ki18n,
  polkit-qt,
}:

mkDerivation {
  pname = "kio-admin";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtbase
    kio
    ki18n
    polkit-qt
  ];

  meta = {
    description = "Manage files as administrator using the admin:// KIO protocol";
    homepage = "https://invent.kde.org/system/kio-admin";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ k900 ];
  };
}
