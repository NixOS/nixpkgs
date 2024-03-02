{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio }:

mkDerivation {
  pname = "kmag";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kmag";
    description = "A small Linux utility to magnify a part of the screen";
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
