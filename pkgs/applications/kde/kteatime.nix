{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kconfig,
  kcrash,
  kiconthemes,
  knotifyconfig,
}:

mkDerivation {
  pname = "kteatime";
  meta = {
    homepage = "https://kde.org/applications/en/utilities/org.kde.kteatime";
    description = "Handy timer for steeping tea";
    mainProgram = "kteatime";
    maintainers = with lib.maintainers; [ freezeboy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    ki18n
    kconfig
    kcrash
    kiconthemes
    knotifyconfig
  ];
}
