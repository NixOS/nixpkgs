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
  meta = with lib; {
    homepage = "https://invent.kde.org/education/klettres";
    description = "An application specially designed to help the user to learn an alphabet";
    mainProgram = "klettres";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
