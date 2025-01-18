{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kglobalaccel,
  kxmlgui,
  kcoreaddons,
  plasma-framework,
  libpulseaudio,
  alsa-lib,
  libcanberra_kde,
}:

mkDerivation {
  pname = "kmix";
  meta = with lib; {
    homepage = "https://apps.kde.org/kmix/";
    description = "Sound mixer";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = [ maintainers.rongcuid ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    alsa-lib
    kglobalaccel
    kxmlgui
    kcoreaddons
    libcanberra_kde
    libpulseaudio
    plasma-framework
  ];
  cmakeFlags = [ "-DKMIX_KF5_BUILD=1" ];
}
