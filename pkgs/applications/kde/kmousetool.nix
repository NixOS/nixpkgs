{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, ki18n
, kiconthemes
, knotifications
, kxmlgui
, kwindowsystem
, phonon
, libXtst
, libXt
}:

mkDerivation {
  pname = "kmousetool";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    ki18n
    kiconthemes
    knotifications
    kxmlgui
    kwindowsystem
    phonon
    libXtst
    libXt
  ];
  meta = {
    homepage = "https://github.com/KDE/kmousetool";
    description = "Program that clicks the mouse for you";
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.jayesh-bhoot ];
  };
}

