{
  mkDerivation,
  lib,
  wrapGAppsHook3,
  extra-cmake-modules,
  kdoctools,
  kio,
  libksane,
}:

mkDerivation {
  pname = "skanlite";
  meta = {
    description = "KDE simple image scanning application";
    mainProgram = "skanlite";
    homepage = "https://apps.kde.org/skanlite";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ polendri ];
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kio
    libksane
  ];
}
