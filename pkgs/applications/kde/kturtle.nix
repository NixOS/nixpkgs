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
  meta = with lib; {
    homepage = "https://invent.kde.org/education/kturtle";
    description = "An educational programming environment for learning how to program";
    mainProgram = "kturtle";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
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
