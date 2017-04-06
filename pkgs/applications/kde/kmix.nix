{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kglobalaccel, kxmlgui, kcoreaddons, kdelibs4support,
  plasma-framework, libpulseaudio, alsaLib, libcanberra_kde
}:

let
  unwrapped =
    kdeApp {
      name = "kmix";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.rongcuid ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      buildInputs = [ libpulseaudio alsaLib libcanberra_kde ];
      propagatedBuildInputs = [
        kglobalaccel kxmlgui kcoreaddons kdelibs4support
        plasma-framework
      ];
      cmakeFlags = [
        "-DKMIX_KF5_BUILD=1"
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kmix" ];
}
