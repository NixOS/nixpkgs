{ mkDerivation, lib, extra-cmake-modules, kdoctools, kconfig, kio, libkdegames, phonon }:

mkDerivation {
  name = "kgoldrunner";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kgoldrunner";
    description = "Action game where the hero runs collect all the gold nuggets";
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
    kio
    libkdegames
    phonon
  ];
}
