{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio }:

mkDerivation {
  name = "kmag";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kmag";
    description = "KMag is a small utility for Linux to magnify a part of the screen";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    ki18n
    kio
  ];
}
