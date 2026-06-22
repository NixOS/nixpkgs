{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fcitx5,
  kdePackages,
  isocodes,
  xkeyboard-config,
  libxkbfile,
  kcmSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-configtool";
  version = "5.1.13";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-STx2S5fuaZCsGoM8nsihYoW+C1GdkD3K7pT84aMRI9c=";
  };

  cmakeFlags = [
    (lib.cmakeBool "KDE_INSTALL_USE_QT_SYS_PATHS" true)
    (lib.cmakeBool "ENABLE_KCM" kcmSupport)
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    fcitx5
    kdePackages.fcitx5-qt
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qtwayland
    kdePackages.kitemviews
    kdePackages.kwidgetsaddons
    isocodes
    xkeyboard-config
    libxkbfile
  ]
  ++ lib.optionals kcmSupport [
    kdePackages.qtdeclarative
    kdePackages.kcoreaddons
    kdePackages.kdeclarative
    kdePackages.kcmutils
    kdePackages.libplasma
    kdePackages.kirigami
  ];

  meta = {
    description = "Configuration Tool for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-configtool";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
    mainProgram = "fcitx5-config-qt";
  };
}
