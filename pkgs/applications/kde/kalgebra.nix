{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio, analitza, ncurses, qtwebengine, kirigami2, readline }:

mkDerivation {
  name = "kalgebra";
  meta = with lib; {
    homepage = "https://edu.kde.org//kalgebra";
    description = "Fully featured calculator";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kio
    analitza

    # Console
    ncurses
    readline

    # Desktop
    qtwebengine

    # Mobile
    kirigami2
  ];
}
