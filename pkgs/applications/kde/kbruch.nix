{ mkDerivation, lib, extra-cmake-modules, kdoctools, kconfig, kcrash, kxmlgui }:

mkDerivation {
  name = "kbruch";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kbruch";
    description = "Small program to practice calculating with fractions and percentages";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kconfig
    kcrash
    kxmlgui
  ];
}
