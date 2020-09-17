{ mkDerivation, lib, extra-cmake-modules, kdoctools, kxmlgui, phonon }:

mkDerivation {
  name = "blinken";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/blinken";
    description = "Memory game based on an electronic game released in 1978";
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
    phonon
  ];
}
