{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kcrash,
  kguiaddons,
  ki18n,
  kparts,
  kwidgetsaddons,
  kdbusaddons,
}:

mkDerivation {
  pname = "kmplot";
  meta = {
    homepage = "https://apps.kde.org/kmplot/";
    description = "Mathematical function plotter";
    mainProgram = "kmplot";
    license = with lib.licenses; [
      gpl2Plus
      fdl12Plus
    ];
    maintainers = [ lib.maintainers.orivej ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcrash
    kguiaddons
    ki18n
    kparts
    kwidgetsaddons
    kdbusaddons
  ];
}
