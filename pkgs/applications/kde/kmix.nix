{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kglobalaccel, kxmlgui, kcoreaddons, kdelibs4support,
  plasma-framework, libpulseaudio, alsaLib, libcanberra_kde
}:

mkDerivation {
  name = "kmix";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.rongcuid ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    alsaLib kglobalaccel kxmlgui kcoreaddons kdelibs4support
    libcanberra_kde libpulseaudio plasma-framework
  ];
  cmakeFlags = [ "-DKMIX_KF5_BUILD=1" ];
}
