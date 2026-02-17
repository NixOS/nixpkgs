{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  kdePackages,
}:
stdenv.mkDerivation rec {
  pname = "plasma-login-manager";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "plasma-login-manager";
    tag = "v${version}";
    hash = "sha256-yKdXqe9TnyBo0pjjaYSUJ1MxMqepTuMe3GfadMiKUoM=";
  };

  buildInputs = with kdePackages; [
    extra-cmake-modules
    qtbase
    qtdeclarative
    qttools
    ki18n
    kcmutils
    kconfig
    kdbusaddons
    kio
    kwindowsystem
    kauth
    kpackage
    kscreen
    layer-shell-qt
    libxau

    # systemd libs ?
    # unclear if systemd itself is needed as well
    systemdLibs

    # LibKWorkspace ?
    plasma-workspace

    # LibKLookAndFeel ?
    plasma-integration

    # FIXME: need to find PlasmaQuick and probably pam
  ];

  nativeBuildInputs = [
    kdePackages.wrapQtAppsHook
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "KDE Plasma Login Manager";
    homepage = "https://github.com/KDE/plasma-login-manager";
    license = with licenses; [
      gpl2
      cc-by-30
    ];
    maintainers = [ maintainers.justdeeevin ];
    # TODO: mainProgram
    platforms = platforms.linux;
  };
}
