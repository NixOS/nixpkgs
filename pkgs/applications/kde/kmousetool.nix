{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kiconthemes,
  knotifications,
  kxmlgui,
  kwindowsystem,
  phonon,
  libXtst,
  libXt,
}:

mkDerivation {
  pname = "kmousetool";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
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
  meta = with lib; {
    homepage = "https://github.com/KDE/kmousetool";
    description = "Program that clicks the mouse for you";
    mainProgram = "kmousetool";
    license = with licenses; [
      gpl2Plus
      fdl12Plus
    ];
    maintainers = [ maintainers.jayesh-bhoot ];
  };
}
