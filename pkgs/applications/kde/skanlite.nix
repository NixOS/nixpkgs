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
  meta = with lib; {
    description = "KDE simple image scanning application";
    mainProgram = "skanlite";
    homepage = "https://apps.kde.org/skanlite";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ polendri ];
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
