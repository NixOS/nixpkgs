{
  mkDerivation, lib,
  extra-cmake-modules,
  cups, ki18n,
  kconfig, kconfigwidgets, kdbusaddons, kiconthemes, kcmutils, kio,
  knotifications, kwidgetsaddons, kwindowsystem, kitemviews, plasma-framework,
  qtdeclarative
}:

mkDerivation {
  pname = "print-manager";
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ cups ki18n ];
  propagatedBuildInputs = [
    kconfig kconfigwidgets kdbusaddons kiconthemes kcmutils knotifications
    kwidgetsaddons kitemviews kio kwindowsystem plasma-framework qtdeclarative
  ];
  outputs = [ "out" "dev" ];
  # Fix build with cups deprecations etc.
  # See: https://github.com/NixOS/nixpkgs/issues/73334
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations -Wno-error=format-security";
}
