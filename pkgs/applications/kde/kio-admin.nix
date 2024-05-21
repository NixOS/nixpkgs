{ mkDerivation, lib, extra-cmake-modules, qtbase, kio, ki18n, polkit-qt }:

mkDerivation {
  pname = "kio-admin";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase kio ki18n polkit-qt ];

  meta = with lib; {
    description = "Manage files as administrator using the admin:// KIO protocol.";
    homepage = "https://invent.kde.org/system/kio-admin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ k900 ];
  };
}
