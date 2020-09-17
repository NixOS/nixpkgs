{ mkDerivation, lib, extra-cmake-modules, kdoctools, kcoreaddons, kxmlgui, libkdegames }:

mkDerivation {
  name = "kiriki";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kiriki";
    description = "Addictive and fun dice game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kcoreaddons
    kxmlgui
    libkdegames
  ];
}
