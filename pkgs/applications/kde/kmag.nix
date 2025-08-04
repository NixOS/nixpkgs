{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
}:

mkDerivation {
  pname = "kmag";
  meta = {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kmag";
    description = "Small Linux utility to magnify a part of the screen";
    mainProgram = "kmag";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
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
