{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  openbabel,
  qtscript,
  kparts,
  kplotting,
  kunitconversion,
}:

mkDerivation {
  pname = "kalzium";
  meta = {
    homepage = "https://edu.kde.org/kalzium/";
    description = "Program that shows you the Periodic Table of Elements";
    mainProgram = "kalzium";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
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
