{
  stdenv,
  lib,
  cmake,
  fetchFromGitLab,
  kdePackages,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "systemdgenie";
  version = "0.99.0-unstable-2025-10-11";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "SystemdGenie";
    owner = "system";
    rev = "dcfd937a711fb124da6c717c51334dbbb430e48e";
    hash = "sha256-X/qUWStT3vRvJNQMdzUV818bsZkbxaaAd7RHJcK+WEE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kirigami-addons
    kdePackages.kio
    kdePackages.ktexteditor
    kdePackages.kxmlgui
  ];

  meta = with lib; {
    description = "Systemd management utility";
    mainProgram = "systemdgenie";
    homepage = "https://kde.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.pasqui23 ];
    platforms = platforms.linux;
  };
}
