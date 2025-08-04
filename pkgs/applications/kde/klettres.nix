{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  phonon,
  knewstuff,
}:

mkDerivation {
  pname = "klettres";
  meta = {
    homepage = "https://invent.kde.org/education/klettres";
    description = "Application specially designed to help the user to learn an alphabet";
    mainProgram = "klettres";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    phonon
    knewstuff
    kdoctools
    ki18n
    kio
  ];
}
