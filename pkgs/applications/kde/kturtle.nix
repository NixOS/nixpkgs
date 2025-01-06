{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
  knewstuff,
}:

mkDerivation {
  pname = "kturtle";
  meta = {
    homepage = "https://invent.kde.org/education/kturtle";
    description = "Educational programming environment for learning how to program";
    mainProgram = "kturtle";
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
    knewstuff
  ];
}
