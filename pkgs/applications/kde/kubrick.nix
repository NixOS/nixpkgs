{ mkDerivation, lib, extra-cmake-modules, kdoctools, kconfig, kio, libkdegames, libGLU }:

mkDerivation {
  name = "kubrick";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kubrick";
    description = "Game based on the Rubik's Cube™ puzzle";
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
    libGLU
  ];
}
