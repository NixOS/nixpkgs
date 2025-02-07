{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kauth,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  knotifications,
}:

mkDerivation {
  pname = "kde-inotify-survey";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    kauth
    kcoreaddons
    kdbusaddons
    ki18n
    knotifications
  ];

  meta = {
    description = "Tooling for monitoring inotify limits and informing the user when they have been or about to be reached";
    mainProgram = "kde-inotify-survey";
    homepage = "https://invent.kde.org/system/kde-inotify-survey";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}
