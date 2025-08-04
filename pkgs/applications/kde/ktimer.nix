{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  ki18n,
  kio,
}:

mkDerivation {
  pname = "ktimer";
  meta = {
    homepage = "https://kde.org/applications/en/utilities/org.kde.ktimer";
    description = "Little tool to execute programs after some time";
    mainProgram = "ktimer";
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
    kio
  ];
}
