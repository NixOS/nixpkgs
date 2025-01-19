{
  stdenv,
  lib,
  cmake,
  extra-cmake-modules,
  kxmlgui,
  fetchFromGitLab,
  kdelibs4support,
  wrapQtAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "systemdgenie";
  version = "0.99.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "SystemdGenie";
    owner = "system";
    rev = "v${version}";
    hash = "sha256-y+A2OuK1ZooPY5W0SsXEb1aaOAJ2b7QSwiumolmAaR4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kxmlgui
    kdelibs4support
  ];

  meta = {
    description = "Systemd management utility";
    mainProgram = "systemdgenie";
    homepage = "https://kde.org";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.pasqui23 ];
    platforms = lib.platforms.linux;
  };
}
