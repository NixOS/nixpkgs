{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, libkdegames, knewstuff }:

mkDerivation {
  name = "katomic";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.katomic";
    description = "Fun educational game built around molecular geometry";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    knewstuff
    libkdegames
    kdoctools
    ki18n
    kio
  ];
}
