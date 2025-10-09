{
  cmake,
  extra-cmake-modules,
  fancontrol-gui,
  fetchFromGitHub,
  lib,
  libgcc,
  libsForQt5,
  nix-update-script,
  stdenv,
  testers,
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

  patches = [
    ./version.patch
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = fancontrol-gui;
      command = "env QT_QPA_PLATFORM=minimal ${lib.getExe fancontrol-gui} --version";
    };
    updateScript = nix-update-script { };
  };

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
