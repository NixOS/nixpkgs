{ mkDerivation, lib, extra-cmake-modules, kdoctools, kxmlgui, libkdegames }:

mkDerivation {
  name = "ksnakeduel";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/ksnakeduel";
    description = "Simple Tron-Clone";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kxmlgui
    libkdegames
  ];
}
