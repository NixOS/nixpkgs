{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, openbabel, avogadro, qtscript, kparts, kplotting, kunitconversion }:

mkDerivation {
  name = "kalzium";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kalzium";
    description = "Kalzium is a program that shows you the Periodic Table of Elements";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    qtscript
    #avogadro
    kdoctools
    ki18n
    kio
    openbabel
    kparts
    kplotting
    kunitconversion
  ];
}
