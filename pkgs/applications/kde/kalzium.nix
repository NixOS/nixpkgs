{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, openbabel, qtscript, kparts, kplotting, kunitconversion }:

mkDerivation {
  pname = "kalzium";
  meta = with lib; {
    homepage = "https://edu.kde.org/kalzium/";
    description = "Program that shows you the Periodic Table of Elements";
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
