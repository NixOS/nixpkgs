{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, knewstuff }:

mkDerivation {
  name = "kturtle";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kturtle";
    description = "An educational programming environment for learning how to program";
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
