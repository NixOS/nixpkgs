{
  cmake,
  extra-cmake-modules,
  fetchFromGitHub,
  lib,
  libgcc,
  libsForQt5,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "fancontrol-gui";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "Maldela";
    repo = "fancontrol-gui";
    tag = "v${version}";
    hash = "sha256-hJaU8SL0b6GmTONGSIzUzzbex6KxHf2Np0bCX8YSSVM=";
  };

  buildInputs = with libsForQt5; [
    libgcc
    kcmutils
    kdeclarative
    kio
    plasma-framework
    qt5.qtdeclarative
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    libsForQt5.wrapQtAppsHook
  ];

  meta = {
    description = "GUI for fancontrol with QT and KDE framework 5";
    homepage = "https://github.com/Maldela/fancontrol-gui";
    changelog = "https://github.com/Maldela/fancontrol-gui/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "fancontrol_gui";
    maintainers = with lib.maintainers; [ dashietm ];
    platforms = lib.platforms.linux;
  };
}
