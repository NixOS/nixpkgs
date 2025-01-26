{
  mkDerivation,
  lib,
  extra-cmake-modules,
  karchive,
  kconfig,
  ki18n,
  kiconthemes,
  kio,
  kservice,
  kwindowsystem,
  kxmlgui,
  libkipi,
  qtbase,
  qtsvg,
  qtxmlpatterns,
}:

mkDerivation {
  pname = "kipi-plugins";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    karchive
    kconfig
    ki18n
    kiconthemes
    kio
    kservice
    kwindowsystem
    kxmlgui
    libkipi
    qtbase
    qtsvg
    qtxmlpatterns
  ];

  meta = {
    description = "Plugins for KDE-based image applications";
    license = lib.licenses.gpl2;
    homepage = "https://github.com/KDE/kipi-plugins";
    maintainers = with lib.maintainers; [ ttuegel ];
  };
}
