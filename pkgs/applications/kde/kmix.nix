{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kglobalaccel, kxmlgui, kcoreaddons,
  plasma-framework, libpulseaudio, alsa-lib, libcanberra_kde
}:

mkDerivation {
  pname = "kmix";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.rongcuid ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    alsa-lib kglobalaccel kxmlgui kcoreaddons
    libcanberra_kde libpulseaudio plasma-framework
  ];
  cmakeFlags = [ "-DKMIX_KF5_BUILD=1" ];
}
